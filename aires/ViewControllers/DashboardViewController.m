//
//  DashboardViewController.m
//  AiresConsulting
//
//  Created by Manigandan Parthasarathi on 24/03/13.
//  Copyright (c) 2013 Manigandan Parthasarathi. All rights reserved.
//

#import "DashboardViewController.h"
#import "ActiveProjectTileView.h"
#import "CompletedProjectTileView.h"
#import "ProjectViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "AiresSingleton.h"
#import "User.h"
#import "Project.h"

#define mSingleton 	((AiresSingleton *) [AiresSingleton getSingletonInstance])

@interface DashboardViewController ()

@end

@implementation DashboardViewController

//@synthesize carousel, carousel2, liveProjectsLabel, completedProjectsLabel, seeAllButton, profileImageView, welcomeLabel, usernameLabel, airesLabel, searchField, searchView, btnSettings, btnRefresh;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _activeProjectsCarousel.type = iCarouselTypeAires;
    _activeProjectsCarousel.bounceDistance = 0.25f;
    
    _completedProjectsCarousel.type = iCarouselTypeLinear;
    _completedProjectsCarousel.bounceDistance = 0.25f;
    _completedProjectsCarousel.scrollSpeed = 0.6f;
    
    //[self addGradeintToCarousel];
    
    _searchView.layer.cornerRadius = 15.0f;
    
    UIImage *bgimage = [UIImage imageNamed:@"btn_navbar_nor.png"];
	bgimage = [bgimage stretchableImageWithLeftCapWidth:bgimage.size.width/2 topCapHeight:bgimage.size.height/2];
    
    [_btnSettings setBackgroundImage:bgimage forState:UIControlStateNormal];
    [_btnRefresh setBackgroundImage:bgimage forState:UIControlStateNormal];
    
    bgimage = [UIImage imageNamed:@"btn_navbar_pressed.png"];
	bgimage = [bgimage stretchableImageWithLeftCapWidth:bgimage.size.width/2 topCapHeight:bgimage.size.height/2];
    
    [_btnSettings setBackgroundImage:bgimage forState:UIControlStateHighlighted];
    [_btnRefresh setBackgroundImage:bgimage forState:UIControlStateHighlighted];
    
    
    User *tempUser = [[mSingleton getPersistentStoreManager] getAiresUser];
    [_usernameLabel setText:[NSString stringWithFormat:@"%@ %@",tempUser.user_FirstName,tempUser.user_LastName]];
    
    _projectsArray = [[NSMutableArray alloc] init];
    [_projectsArray addObjectsFromArray:[[mSingleton getPersistentStoreManager] getUserProjects]];
    
    _activeProjectsCarousel.alpha = 0.0f;
    _completedProjectsCarousel.alpha = 0.0f;
    [self performSelector:@selector(loadCarousel) withObject:nil afterDelay:0.5];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localNotificationhandler:) name:NOTIFICATION_LOGOUT_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localNotificationhandler:) name:NOTIFICATION_LOGOUT_SUCCESS object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localNotificationhandler:) name:NOTIFICATION_FETCH_PROJECT_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localNotificationhandler:) name:NOTIFICATION_FETCH_PROJECT_SUCCESS object:nil];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)loadCarousel
{
    [UIView animateWithDuration:0.3 animations:^{
        _activeProjectsCarousel.alpha = 1.0f;
        _completedProjectsCarousel.alpha = 1.0f;
    }];
    [_activeProjectsCarousel reloadData];
    [_completedProjectsCarousel reloadData];
}

-(void)awakeFromNib
{
    [_liveProjectsLabel setFont:[UIFont fontWithName:@"ProximaNova-Bold" size:20.0f]];
    [_completedProjectsLabel setFont:[UIFont fontWithName:@"ProximaNova-Bold" size:20.0f]];
    [_seeAllButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:12.0f]];
    [_welcomeLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:12.0f]];
    [_usernameLabel setFont:[UIFont fontWithName:@"ProximaNova-Bold" size:14.0f]];
    [_airesLabel setFont:[UIFont fontWithName:@"ProximaNova-Bold" size:20.0f]];
    [_searchField setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:14.0f]];
    [_searchField setDelegate:self];
    [_loadingView setHidden:TRUE];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(void)addGradeintToCarousel
{
    // Recreate gradient mask with new fade length
    CAGradientLayer *gradientMask = [CAGradientLayer layer];
    CGRect bounds = _activeProjectsCarousel.layer.bounds;
    bounds.origin.y -= 70;
    bounds.size.height += 70;
    
    gradientMask.bounds =  bounds;
    gradientMask.position = CGPointMake(_activeProjectsCarousel.bounds.size.width/2, _activeProjectsCarousel.bounds.size.height/2);
    
    NSObject *transparent = (NSObject *)[[UIColor clearColor] CGColor];
    NSObject *opaque = (NSObject *)[[UIColor colorWithRed:29.0/255.0 green:32.0/255.0 blue:29.0/255.0 alpha:0.75] CGColor];
    
    gradientMask.startPoint = CGPointMake(0.0, CGRectGetMidY(_activeProjectsCarousel.frame));
    gradientMask.endPoint = CGPointMake(1.0, CGRectGetMidY(_activeProjectsCarousel.frame));
    CGFloat fadePoint = 180.0f/_activeProjectsCarousel.frame.size.width;
    [gradientMask setColors: [NSArray arrayWithObjects: transparent, opaque, opaque, transparent, nil]];
    [gradientMask setLocations: [NSArray arrayWithObjects:
                                 [NSNumber numberWithDouble: 0.0],
                                 [NSNumber numberWithDouble: fadePoint],
                                 [NSNumber numberWithDouble: 1 - fadePoint],
                                 [NSNumber numberWithDouble: 1.0],
                                 nil]];
    _activeProjectsCarousel.layer.mask = gradientMask;
}

-(IBAction)onSettings:(id)sender
{
    if(!mDashboardSettingsViewController)
        mDashboardSettingsViewController = [[DashboardSettingsViewController alloc] init];
    
    if(!popover)
        popover = [[UIPopoverController alloc]initWithContentViewController:mDashboardSettingsViewController];
    
    [popover setContentViewController:mDashboardSettingsViewController];
    [popover setPopoverContentSize:CGSizeMake(320, 135)];
    [popover setDelegate:self];
    
    [popover presentPopoverFromRect:self.btnSettings.bounds inView:self.btnSettings permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (IBAction)onRefreshData:(id)sender
{
    if(![mSingleton isConnectedToInternet])
    {
        UIAlertView *noNetworkAlert = [[UIAlertView alloc] initWithTitle:@"Connection error" message:@"Unable to connect.\n Check your internet connection and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [noNetworkAlert show];
        return;
    }

    [_loadingView setHidden:FALSE];
    [[mSingleton getWebServiceManager] fetchProjectsforUser];
}

#pragma mark - iCarousel datasource

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)aCarousel
{
    return (aCarousel == _activeProjectsCarousel)?_projectsArray.count:4;
}

- (UIView *)carousel:(iCarousel *)aCarousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView*)view
{
    if(aCarousel == _activeProjectsCarousel)
    {
        if (view == nil)
        {
            // content view
            ActiveProjectTileView *tileView = [[ActiveProjectTileView alloc] initWithFrame:CGRectMake(0, 0, 690, 480)];
            tileView.project = (Project*)[_projectsArray objectAtIndex:index];
            return tileView;
        }
        return view;
    }
    else
    {
        if (view == nil)
        {
            UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 94)];
            aView.backgroundColor = [UIColor clearColor];
            
            // 4 completed projects will be shown at a time
            for (int i=0; i<4; i++)
            {
                // content view
                CompletedProjectTileView *tileView = [[CompletedProjectTileView alloc] initWithFrame:CGRectMake(i*256, 0, 256, 154)];
                [aView addSubview:tileView];
            }
            return aView;
        }
        return view;
    }
}

#pragma mark - iCarousel delegate

-(void)carousel:(iCarousel *)aCarousel didSelectItemAtIndex:(NSInteger)index
{
    if(aCarousel == _activeProjectsCarousel && index == _activeProjectsCarousel.currentItemIndex)
    {
        ProjectViewController *projectVC = [[ProjectViewController alloc] initWithNibName:@"ProjectViewController" bundle:nil];
        Project *currentProject = (Project*)[_projectsArray objectAtIndex:index];
        [projectVC setCurrentProject:currentProject];
        [self.navigationController pushViewController:projectVC animated:NO];
        
        [UIView transitionFromView:self.view
                            toView:projectVC.view
                          duration:0.75
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        completion:^(BOOL finished){
                            /* do something on animation completion */
                        }];
    }
    else if(aCarousel == _completedProjectsCarousel && index == _completedProjectsCarousel.currentItemIndex)
    {
        if(!mPreviewReportViewController)
            mPreviewReportViewController = [[PreviewReportViewController alloc] initWithNibName:@"PreviewReportViewController" bundle:nil];
        Project *currentProject = (Project*)[_projectsArray objectAtIndex:index];
        [mPreviewReportViewController setCurrentProject:currentProject];
    
        [self.navigationController pushViewController:mPreviewReportViewController animated:NO];
        [UIView transitionFromView:self.view
                            toView:mPreviewReportViewController.view
                          duration:0.75
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        completion:^(BOOL finished){
                            /* do something on animation completion */
                        }];

        
    }
    else
    {
        
    }
}

#pragma mark-
#pragma mark TextFiled Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _searchField)
    {
        if(!mProjectListViewController)
            mProjectListViewController = [[ProjectListViewController alloc] initWithNibName:@"ProjectListViewController" bundle:nil];
        mProjectListViewController.listContent = [[mSingleton getPersistentStoreManager] getUserProjects];
        mProjectListViewController.delegate = self;
        [mProjectListViewController filterContentForSearchText:_searchField.text scope:nil];
        
        if(!popover)
            popover = [[UIPopoverController alloc]initWithContentViewController:mProjectListViewController];
        
        [popover setContentViewController:mProjectListViewController];
        [popover setPopoverContentSize:CGSizeMake(320, 180)];
        [popover setDelegate:self];
        
        [popover presentPopoverFromRect:_searchField.bounds inView:_searchField permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _searchField)
        [mProjectListViewController filterContentForSearchText:[textField.text stringByReplacingCharactersInRange:range withString:string] scope:nil];
    
    return YES;
}

#pragma mark-
#pragma mark TextFiled Delegate
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if([popoverController.contentViewController isMemberOfClass:[mProjectListViewController class]])
    {
        NSLog(@"mProjectListViewController");
        [_searchField resignFirstResponder];
    }
    else if([popoverController.contentViewController isMemberOfClass:[mDashboardSettingsViewController class]])
    {
        NSLog(@"mDashboardSettingsViewController");
    }
}

#pragma mark-
#pragma mark ProjectList Delegate
- (void)selectedProject:(Project*)proj
{
    [popover dismissPopoverAnimated:NO];
    if([proj.project_CompletedFlag boolValue])
    {
        if(!mPreviewReportViewController)
            mPreviewReportViewController = [[PreviewReportViewController alloc] initWithNibName:@"PreviewReportViewController" bundle:nil];
        [mPreviewReportViewController setCurrentProject:proj];
        
        [self.navigationController pushViewController:mPreviewReportViewController animated:NO];
        [UIView transitionFromView:self.view
                            toView:mPreviewReportViewController.view
                          duration:0.75
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        completion:^(BOOL finished){
                            /* do something on animation completion */
                        }];
    }
    else
    {
        ProjectViewController *projectVC = [[ProjectViewController alloc] initWithNibName:@"ProjectViewController" bundle:nil];
        [projectVC setCurrentProject:proj];
        [self.navigationController pushViewController:projectVC animated:NO];
        
        [UIView transitionFromView:self.view
                            toView:projectVC.view
                          duration:0.75
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        completion:^(BOOL finished){
                            /* do something on animation completion */
                        }];

    }
}

#pragma mark-
#pragma mark Notification Handler
- (void) localNotificationhandler:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:NOTIFICATION_LOGOUT_FAILED])
    {
        [popover dismissPopoverAnimated:YES];
    }
    else if ([[notification name] isEqualToString:NOTIFICATION_LOGOUT_SUCCESS])
    {
        [[mSingleton getSecurityManager] deleteValueForKey:LOGIN_ACCESSTOKEN];
        [[mSingleton getSecurityManager] deleteValueForKey:LOGIN_ACCESSTOKEN_TIME];
        [popover dismissPopoverAnimated:YES];
        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.25;
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromRight;
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController popViewControllerAnimated:NO];
    }
    else if ([[notification name] isEqualToString:NOTIFICATION_FETCH_PROJECT_FAILED])
    {
        [_loadingView setHidden:TRUE];
        UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to reload data.\n Check your internet connection or try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [failedAlert show];

    }
    else if ([[notification name] isEqualToString:NOTIFICATION_FETCH_PROJECT_SUCCESS])
    {
        [_projectsArray removeAllObjects];
        [_projectsArray addObjectsFromArray:[[mSingleton getPersistentStoreManager] getUserProjects]];
        _activeProjectsCarousel.alpha = 0.0f;
        _completedProjectsCarousel.alpha = 0.0f;
        [self loadCarousel];
        [_loadingView setHidden:TRUE];
    }
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

@end