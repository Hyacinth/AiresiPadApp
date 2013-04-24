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
#import "WebServiceManager.h"
#import "JSONParser.h"
#import "PersistentStoreManager.h"
#import "Constants.h"

@interface AiresSingleton : NSObject
{
    SecurityManager *mSecurityManager;
    WebServiceManager *mWebServiceManager;
    JSONParser *mJSONParser;
    PersistentStoreManager *mPersistentStoreManager;
    
    NSMutableDictionary *environmentURLs;
}

@property(nonatomic, strong) NSMutableDictionary *environmentURLs;

+ (AiresSingleton *) getSingletonInstance;
- (BOOL)isConnectedToInternet;
- (NSDate *)getCurrentDeviceTime;
- (BOOL)isValidAccessToken;

//Manager Instances
- (AppDelegate *)getAppDelegateInstance;
- (SecurityManager *)getSecurityManager;
- (WebServiceManager *)getWebServiceManager;
- (JSONParser *)getJSONParser;
- (PersistentStoreManager *)getPersistentStoreManager;

@end
