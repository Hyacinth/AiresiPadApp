//
//  LoginViewController.m
//  aires
//
//  Created by Gautham on 10/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "LoginViewController.h"
#import "AiresSingleton.h"
#import "KSCustomPopoverBackgroundView.h"
#import "PreviewReportViewController.h"

#define mSingleton 	((AiresSingleton *) [AiresSingleton getSingletonInstance])

@interface LoginViewController (private)

-(void)adjustLoginFieldFrame:(BOOL)flag;

@end

@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed: @"popover-black-bcg-image"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

-(void)setBackgroundImage:(UIImage*)image{
    if(image == NULL){ //might be called with NULL argument
        return;
    }
    UIImageView *aTabBarBackground = [[UIImageView alloc]initWithImage:image];
    aTabBarBackground.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    [self addSubview:aTabBarBackground];
    [self sendSubviewToBack:aTabBarBackground];
}

@end

@implementation LoginViewController
@synthesize isLoggingIn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if(!loginCredentials)
            loginCredentials = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    loginFieldsView.delegate = self;
    
    if(!mLoginSettingsViewController)
        mLoginSettingsViewController = [[LoginSettingsViewController alloc] init];
    
    UIImage *buttonImage = [[UIImage imageNamed:@"btn_login"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    
    [loginButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    [forgotPasswordButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:14.0]];
    [loginButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Bold" size:24]];
    [welcomeLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:24]];
    [welcomeLabel setTextColor:[UIColor blackColor]];

    loginButton.alpha = 0;
    welcomeLabel.alpha = 0;
    forgotPasswordButton.alpha = 0;
    settingsButton.alpha = 0;
    loginFieldsView.alpha = 0;
    
    CGRect logoFrame = airesLogoImageView.frame;
    logoFrame.origin.y = 78.0f;

    [UIView animateWithDuration:0.45
                     animations:^{
                         airesLogoImageView.frame = logoFrame;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.3
                                          animations:^{
                                              loginButton.alpha = 1.0f;
                                              welcomeLabel.alpha = 1.0f;
                                              forgotPasswordButton.alpha = 1.0f;
                                              settingsButton.alpha = 1.0f;
                                              loginFieldsView.alpha = 1.0f;
                                          }];
                     }];
    
    //[self preLoadLoginSettings];
    if (isLoggingIn)
    {
        [self setElementsEnabled:FALSE];
        [loginFieldsView showLoadingMessage:@"Signing in..."];
    }
    [self performSelector:@selector(preLoadLoginSettings) withObject:nil afterDelay:1.5];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)preLoadLoginSettings
{
    if (isLoggingIn)
    {
        //If user deletes the app and reinstalls
        if(![[mSingleton getPersistentStoreManager] getAiresUser])
        {
            if(![mSingleton isConnectedToInternet])
            {
                UIAlertView *noNetworkAlert = [[UIAlertView alloc] initWithTitle:@"Connection error" message:@"Unable to connect.\n Check your internet connection and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [noNetworkAlert show];
                return;
            }

            NSString *user = [[mSingleton getSecurityManager] getValueForKey:LOGIN_USERNAME];
            NSString *pwd = [[mSingleton getSecurityManager] getValueForKey:LOGIN_PASSWORD];
            [[mSingleton getWebServiceManager] loginWithUserName:user andpassword:pwd];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN_SUCCESS object:self];
        }
        isLoggingIn = FALSE;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[loginFieldsView hideLoadingMessage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localNotificationhandler:) name:NOTIFICATION_LOGIN_FAILED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localNotificationhandler:) name:NOTIFICATION_LOGIN_SUCCESS object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localNotificationhandler:) name:NOTIFICATION_ENVIRONMENT_FAILED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localNotificationhandler:) name:NOTIFICATION_ENVIRONMENT_SUCCESS object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    SecurityManager *mSecurityManager = [mSingleton getSecurityManager];
    [loginFieldsView setUserFieldText:[mSecurityManager getValueForKey:LOGIN_USERNAME]];
    BOOL switchValue = [[[mSingleton getSecurityManager] getValueForKey:LOGIN_AUTOLOGIN] boolValue];
    
    if (switchValue)
        [loginFieldsView setPassFieldText:[mSecurityManager getValueForKey:LOGIN_PASSWORD]];
    else
        [loginFieldsView setPassFieldText:@""];
    
    [loginFieldsView setUserFieldText:@"gbtpa\\dcreggett"];
    //[loginFieldsView setPassFieldText:@"password123"];
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [loginFieldsView hideLoadingMessage];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark IBAction

-(IBAction)onLogin
{
    //Check internet connectivity
    if(![mSingleton isConnectedToInternet])
    {
        UIAlertView *noNetworkAlert = [[UIAlertView alloc] initWithTitle:@"Connection error" message:@"Unable to connect.\n Check your internet connection and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [noNetworkAlert show];
        return;
    }
    
    [self setElementsEnabled:FALSE];

    [loginFieldsView showLoadingMessage:@"Signing in..."];
    [self.view endEditing:YES];
    [self performSelector:@selector(changingMessage) withObject:nil afterDelay:1.0];
}

-(void)changingMessage
{
    [loginFieldsView changeLoadingMessage:@"Fetching Projects..."];
    [self performSelector:@selector(loginAction) withObject:nil afterDelay:2.0];
}

-(void)loginAction
{
    [popover dismissPopoverAnimated:YES];
    //Save values in keychain
    SecurityManager *mSecurityManager = [mSingleton getSecurityManager];
    [mSecurityManager setValue:[loginFieldsView getUserFieldText] forKey:LOGIN_USERNAME];
    [mSecurityManager setValue:[loginFieldsView getPassFieldText] forKey:LOGIN_PASSWORD];
    
    //Do Login
    [[mSingleton getWebServiceManager] loginWithUserName:[mSecurityManager getValueForKey:LOGIN_USERNAME] andpassword:[mSecurityManager getValueForKey:LOGIN_PASSWORD]];
}

-(IBAction)onForgotPassword
{
    [welcomeLabel setTextColor:[UIColor blackColor]];
    welcomeLabel.text = @"Welcome. Please login.";
    
    NSURL *url = [NSURL URLWithString:@"http://password.ajg.com"];
    if (![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

-(IBAction)onSettings
{
    [welcomeLabel setTextColor:[UIColor blackColor]];
    welcomeLabel.text = @"Welcome. Please login.";
    
    if(!mLoginSettingsViewController)
        mLoginSettingsViewController = [[LoginSettingsViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mLoginSettingsViewController];
    //[[navController navigationBar] setBackgroundImage:[UIImage imageNamed:@"nav_bar"]];

    if(!popover)
        popover = [[UIPopoverController alloc]initWithContentViewController:navController];
    
    [popover setContentViewController:navController];
    [popover setPopoverContentSize:CGSizeMake(300, 216)];
    [popover setDelegate:self];
    //popover.popoverBackgroundViewClass = [KSCustomPopoverBackgroundView class];

    [popover presentPopoverFromRect:settingsButton.bounds inView:settingsButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

}

#pragma mark-
#pragma mark Private methods
-(void)adjustLoginFieldFrame:(BOOL)flag
{
    [welcomeLabel setTextColor:[UIColor blackColor]];
    welcomeLabel.text = @"Welcome. Please login.";
    
    CGRect labelFrame;
    CGRect loginFrame;
    
    if(flag)
    {
        labelFrame = CGRectMake(383, 236, 261, 26);
        loginFrame = CGRectMake(352, 294, 322, 88);
    }
    else
    {
        labelFrame = CGRectMake(383, 292, 261, 26);
        loginFrame = CGRectMake(352, 360, 322, 88);
    }
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         [welcomeLabel setFrame:labelFrame];
                         [loginFieldsView setFrame:loginFrame];
                     }];
}

-(void)keyboardWillShow
{
    [self adjustLoginFieldFrame:YES];
}

-(void)keyboardWillHide
{
    [self adjustLoginFieldFrame:NO];
}

-(void)keyboardReturnedOnPasswordField
{
    [self onLogin];
}

-(void)setElementsEnabled:(BOOL)flag
{
    NSArray *viewsArray = [self.view subviews];
    
    for (UIView *view in viewsArray) 
        [view setUserInteractionEnabled:flag];
}

#pragma mark-
#pragma mark Notification Handler
- (void) localNotificationhandler:(NSNotification *) notification
{
    [self setElementsEnabled:TRUE];
    if ([[notification name] isEqualToString:NOTIFICATION_LOGIN_FAILED])
    {
        [welcomeLabel setTextColor:[UIColor redColor]];
        welcomeLabel.text = @"Login Failed";
        [loginFieldsView hideLoadingMessage];
    }
    else if ([[notification name] isEqualToString:NOTIFICATION_LOGIN_SUCCESS])
    {
        
        if(!mDashboardViewController)
            mDashboardViewController = [[DashboardViewController alloc] initWithNibName:@"DashboardViewController" bundle:nil];
        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.25;
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromRight;
        
        [self.navigationController.view.layer
         addAnimation:transition forKey:kCATransition];
        
        [self.navigationController pushViewController:mDashboardViewController animated:NO];
        
    }
    else if ([[notification name] isEqualToString:NOTIFICATION_ENVIRONMENT_FAILED])
    {
        [welcomeLabel setTextColor:[UIColor redColor]];
        welcomeLabel.text = @"Login Failed";
        [loginFieldsView hideLoadingMessage];
    }
    else if ([[notification name] isEqualToString:NOTIFICATION_ENVIRONMENT_SUCCESS])
    {
        [welcomeLabel setTextColor:[UIColor blackColor]];
        welcomeLabel.text = @"Welcome. Please login.";
    }
}

@end
