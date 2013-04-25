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
@synthesize environmentURLs;

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

#pragma mark Global Methods

- (BOOL)isConnectedToInternet
{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
        return NO;
    
    return YES;
}

-(NSDate *)getCurrentDeviceTime
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE,MM-dd-yyyy HH:mm:ss"];
    [dateFormat setLocale:[NSLocale currentLocale]];
    NSString *dateString = [dateFormat stringFromDate:date];
    NSLog(@"CurrentData:%@",dateString);
    return date;
}

-(BOOL)isValidAccessToken
{
    NSString *accessToken = [[self getSecurityManager] getValueForKey:LOGIN_ACCESSTOKEN];
    if (!accessToken || [accessToken length] <= 0)
        return FALSE;
    
    NSDate *currentDate = [self getCurrentDeviceTime];
    
    NSString *str_prevDate = [[self getSecurityManager] getValueForKey:LOGIN_ACCESSTOKEN_TIME];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE,MM-dd-yyyy HH:mm:ss"];
    NSDate *prevDate = [[NSDate alloc] init];
    prevDate = [dateFormatter dateFromString:str_prevDate];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:kCFCalendarUnitHour fromDate:prevDate toDate:currentDate options:0];
    
    if(components.hour >= 12)
        return FALSE;
    
    return TRUE;
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

- (WebServiceManager *)getWebServiceManager
{
    if(!mWebServiceManager)
        mWebServiceManager = [[WebServiceManager alloc] init];
    
    [mWebServiceManager getEnvironment];

    return mWebServiceManager;
}

- (JSONParser *)getJSONParser
{
    if(!mJSONParser)
        mJSONParser = [[JSONParser alloc] init];
    return mJSONParser;
}

- (PersistentStoreManager *)getPersistentStoreManager
{
    if(!mPersistentStoreManager)
        mPersistentStoreManager = [[PersistentStoreManager alloc] init];
    return mPersistentStoreManager;
}

#pragma mark -
#pragma mark Private Methods

- (NSString *)getApplicationBundleIdentifier
{
    return [[NSBundle mainBundle] bundleIdentifier];
}

@end
