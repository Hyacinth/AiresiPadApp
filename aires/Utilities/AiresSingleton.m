//
//  AiresSingleton.m
//  aires
//
//  Created by Gautham on 10/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "AiresSingleton.h"
#import "Reachability.h"

static AiresSingleton* instance;

#pragma mark -
@interface AiresSingleton (private)

- (NSString *)getApplicationBundleIdentifier;

@end

#pragma mark -
@implementation AiresSingleton

#pragma mark -

+ (AiresSingleton *) getSingletonInstance
{
	@synchronized([AiresSingleton class])
    {
		if ( instance == nil )
        {
			instance = [[AiresSingleton alloc] init];
		}
	}
	return instance;
}

- (BOOL)isConnectedToInternet
{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
        return NO;

    return YES;
}

#pragma mark -
#pragma mark Manager Instance

- (AppDelegate *)getAppDelegateInstance
{
    return ((AppDelegate *) [UIApplication sharedApplication].delegate);
}

- (SecurityManager *)getSecurityManager;
{
    if(!mSecurityManager)
    {
        NSString *mAppBundleID = [self getApplicationBundleIdentifier];
        mSecurityManager = [[SecurityManager alloc] initWithServiceName:mAppBundleID];
    }
    return mSecurityManager;
}

#pragma mark -
#pragma mark Private Methods

- (NSString *)getApplicationBundleIdentifier
{
    return [[NSBundle mainBundle] bundleIdentifier];
}

@end
