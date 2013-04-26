//
//  LoginViewController.h
//  aires
//
//  Created by Gautham on 10/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginSettingsViewController.h"
#import "DashboardViewController.h"
#import "LoginFieldsView.h"

@interface LoginViewController : UIViewController<UIPopoverControllerDelegate, LoginFieldsDelegate>
{
    IBOutlet UIImageView *airesLogoImageView;
    IBOutlet UILabel *welcomeLabel;
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *forgotPasswordButton;
    IBOutlet UIButton *settingsButton;
    IBOutlet LoginFieldsView *loginFieldsView;
    
    NSMutableArray *loginCredentials;
    
    UIPopoverController *popover;
    LoginSettingsViewController *mLoginSettingsViewController;
        
    DashboardViewController *mDashboardViewController;
}

@property(nonatomic) BOOL isLoggingIn;

-(IBAction)onLogin;
-(IBAction)onForgotPassword;
-(IBAction)onSettings;

@end
