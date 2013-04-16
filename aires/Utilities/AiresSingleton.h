//
//  AiresSingleton.h
//  aires
//
//  Created by Gautham on 10/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "SecurityManager.h"
#import "Constants.h"

@interface AiresSingleton : NSObject
{
    SecurityManager *mSecurityManager;
}

+ (AiresSingleton *) getSingletonInstance;
- (BOOL)isConnectedToInternet;

//Manager Instances
- (AppDelegate *)getAppDelegateInstance;
- (SecurityManager *)getSecurityManager;

@end
