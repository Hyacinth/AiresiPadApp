//
//  LoginViewController.m
//  aires
//
//  Created by Gautham on 10/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginTableCell.h"
#import "AiresSingleton.h"

#define mSingleton 	((AiresSingleton *) [AiresSingleton getSingletonInstance])

@interface LoginViewController ()

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localNotificationhandler:) name:NOTIFICATION_LOGIN_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localNotificationhandler:) name:NOTIFICATION_LOGIN_SUCCESS object:nil];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *buttonImage = [[UIImage imageNamed:@"btn_login"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];

    [loginButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    [forgotPasswordButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:14.0]];
    [loginButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:24]];
    [welcomeLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:24]];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (isLoggingIn)
    {
        if(!loggingInAlert)
            loggingInAlert = [[UIAlertView alloc] initWithTitle:@"Logging In" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [loggingInAlert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark IBAction

-(IBAction)onLogin:(id)sender
{
    //Save values in keychain
    SecurityManager *mSecurityManager = [mSingleton getSecurityManager];
    for (NSIndexPath *indexPath in loginCredentials)
    {
        LoginTableCell *cell = (LoginTableCell *)[loginFieldTable cellForRowAtIndexPath:indexPath];
        if (cell.tag == CELL_USER_FIELD && [cell.cellTextField.text length] > 0)
        {
            [mSecurityManager setValue:cell.cellTextField.text forKey:LOGIN_USERNAME];
        }
        else if (cell.tag == CELL_PWD_FIELD && [cell.cellTextField.text length] > 0)
        {
            [mSecurityManager setValue:cell.cellTextField.text forKey:LOGIN_PASSWORD];
        }
    }
    //Check internet connectivity
    if(![mSingleton isConnectedToInternet])
    {
        UIAlertView *noNetworkAlert = [[UIAlertView alloc] initWithTitle:@"Connection error" message:@"Unable to connect.\n Check your internet connection and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [noNetworkAlert show];
        return;
    }
    
    //Do Login
    [[mSingleton getWebServiceManager] loginWithUserName:[mSecurityManager getValueForKey:LOGIN_USERNAME] andpassword:[mSecurityManager getValueForKey:LOGIN_PASSWORD]];
    
    if(!loggingInAlert)
        loggingInAlert = [[UIAlertView alloc] initWithTitle:@"Logging in..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [loggingInAlert show];
}

-(IBAction)onForgotPassword:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
    if (![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

-(IBAction)onSettings:(id)sender
{
    if(!mLoginSettingsViewController)
        mLoginSettingsViewController = [[LoginSettingsViewController alloc] init];
    
    if(!popover)
        popover = [[UIPopoverController alloc]initWithContentViewController:mLoginSettingsViewController];
    
    [popover setContentViewController:mLoginSettingsViewController];
    [popover setPopoverContentSize:CGSizeMake(300, 180)];
    [popover setDelegate:self];
    
    [popover presentPopoverFromRect:settingsButton.bounds inView:settingsButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark-
#pragma mark UITableView Delegate and Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //Preset login environment before table loads
    [loginCredentials removeAllObjects];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"loginFieldTable";
    SecurityManager *mSecurityManager = [mSingleton getSecurityManager];
    LoginTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[LoginTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LoginTableCell" owner:self options:nil];
		cell = (LoginTableCell *)[nib objectAtIndex:0];
    }
    [cell.cellTextField setDelegate:self];
    [cell.cellTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [cell.cellLabel setTextColor:[UIColor colorWithRed:178/255 green:178/255 blue:178/255 alpha:1.0]];
    [cell.cellLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:14.0]];
    if(indexPath.row == 0)
    {
        cell.cellLabel.text = @"User Name";
        [cell.cellTextField setText:[mSecurityManager getValueForKey:LOGIN_USERNAME]];
        [cell.cellTextField setReturnKeyType:UIReturnKeyNext];
        cell.tag = CELL_USER_FIELD;
        //cell.cellTextField.text = @"gbtpa\\dcreggett";
        
    }
    else
    {
        cell.cellLabel.text = @"Password";
        [cell.cellTextField setSecureTextEntry:TRUE];
        if ([[mSecurityManager getValueForKey:LOGIN_AUTOLOGIN] isEqualToString:@"TRUE"])
            [cell.cellTextField setText:[mSecurityManager getValueForKey:LOGIN_PASSWORD]];
        [cell.cellTextField setReturnKeyType:UIReturnKeyDone];
        [cell.cellTextField setClearsOnBeginEditing:FALSE];
        cell.tag = CELL_PWD_FIELD;
        //cell.cellTextField.text = @"password123";
    }
    [loginCredentials addObject:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoginTableCell *cell = (LoginTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.cellTextField becomeFirstResponder];
}

#pragma mark-
#pragma mark UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    LoginTableCell * currentCell = (LoginTableCell *) textField.superview.superview;
    if (currentCell.tag == CELL_USER_FIELD)
    {
        NSIndexPath * currentIndexPath = [loginFieldTable indexPathForCell:currentCell];
        NSIndexPath * nextIndexPath = [NSIndexPath indexPathForRow:currentIndexPath.row + 1 inSection:0];
        LoginTableCell * nextCell = (LoginTableCell *) [loginFieldTable cellForRowAtIndexPath:nextIndexPath];
        
        [nextCell.cellTextField becomeFirstResponder];
    }
    else if (currentCell.tag == CELL_PWD_FIELD)
    {
        [textField resignFirstResponder];
        [self onLogin:nil];
    }
    
    return TRUE;
}

#pragma mark-
#pragma mark Notification Handler
- (void) localNotificationhandler:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:NOTIFICATION_LOGIN_FAILED])
    {
        [loggingInAlert dismissWithClickedButtonIndex:0 animated:YES];
    }
    else if ([[notification name] isEqualToString:NOTIFICATION_LOGIN_SUCCESS])
    {
        [loggingInAlert dismissWithClickedButtonIndex:0 animated:TRUE];
    }
}
@end
