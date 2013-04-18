//
//  AppDelegate.h
//  aires
//
//  Created by Gautham on 04/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController  *navigationController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController  *navigationController;

@property (strong, nonatomic) LoginViewController *mLoginViewController;


@end
