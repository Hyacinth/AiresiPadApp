//
//  ViewController.h
//  AiresConsulting
//
//  Created by Manigandan Parthasarathi on 24/03/13.
//  Copyright (c) 2013 Manigandan Parthasarathi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "DashboardSettingsViewController.h"
#import "ChemicalsListViewController.h"
#import "PPEListViewController.h"

@interface DashboardViewController : UIViewController<iCarouselDataSource, iCarouselDelegate, iCarouselDeprecated, UIPopoverControllerDelegate>
{
    UIPopoverController *popover;
    DashboardSettingsViewController *mDashboardSettingsViewController;
    ChemicalsListViewController *mChemicalsListViewController;
    PPEListViewController *mPPEListViewController;
}

@property(nonatomic,retain) IBOutlet iCarousel *activeProjectsCarousel;
@property (retain, nonatomic) IBOutlet iCarousel *completedProjectsCarousel;
@property (retain, nonatomic) IBOutlet UILabel *completedProjectsLabel;
@property (retain, nonatomic) IBOutlet UIButton *seeAllButton;
@property (retain, nonatomic) IBOutlet UILabel *liveProjectsLabel;
@property (retain, nonatomic) IBOutlet UIImageView *profileImageView;
@property (retain, nonatomic) IBOutlet UILabel *usernameLabel;
@property (retain, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (retain, nonatomic) IBOutlet UILabel *airesLabel;
@property (retain, nonatomic) IBOutlet UIView *searchView;
@property (retain, nonatomic) IBOutlet UITextField *searchField;
@property (retain, nonatomic) IBOutlet UIButton *btnSettings;
@property (retain, nonatomic) IBOutlet UIButton *btnRefresh;

@property (retain, nonatomic) NSMutableArray *projectsArray;

-(IBAction)onSettings:(id)sender;

@end
