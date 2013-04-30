//
//  WebServiceManager.m
//  aires
//
//  Created by Gautham on 18/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "WebServiceManager.h"
#import "AFNetworking.h"
#import "Constants.h"
#import "AiresSingleton.h"
#import "ini.h"
#import "Reachability.h"

#define mSingleton 	((AiresSingleton *) [AiresSingleton getSingletonInstance])

@implementation WebServiceManager

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    if(!AiresServicePath)
        AiresServicePath = [[NSString alloc] init];
    AiresServicePath = [[NSBundle mainBundle] pathForResource:
                        @"AiresService" ofType:@"plist"];
    
    // Path to the plist (in the application bundle)
    
    // Build the array from the plist
    if(!AiresService)
        AiresService = [[NSMutableDictionary alloc] initWithContentsOfFile:AiresServicePath];
    
    
    // Show the string values
    
    return self;
}

-(void) getEnvironment
{
    if([mSingleton.environmentURLs count] > 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ENVIRONMENT_SUCCESS object:self];
        return;
    }
    NSString *rootURL = [AiresService objectForKey:@"Root URL"];
    NSURL *url = [NSURL URLWithString:rootURL];
    // NSData *data = [NSData dataWithContentsOfURL:url];
    NSError* error = nil;
    NSData* data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ENVIRONMENT_FAILED object:self];
        return;
    } else {
        NSLog(@"Data has loaded successfully.");
    }
    NSString* newStr = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    
    //save content to the documents directory
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"config.txt"];
    
    [newStr writeToFile:path
             atomically:NO
               encoding:NSStringEncodingConversionAllowLossy
                  error:nil];
    
    INIParser * parser;
    
    parser = [[INIParser alloc] init];
    
    const char *stringAsChar = [path cStringUsingEncoding:[NSString defaultCStringEncoding]];
    char *cpy = calloc([path length]+1, 1);
    strncpy(cpy, stringAsChar, [path length]);
    [parser parse: cpy];
    
    NSString * str;
    if(!mSingleton.environmentURLs)
        mSingleton.environmentURLs = [[NSMutableDictionary alloc] init];
    str = [parser get: @"url" section: @"production"];
    [mSingleton.environmentURLs setValue:str forKey:LOGIN_SETTINGS_PRODUCTION];
    
    str = [parser get: @"url" section: @"staging"];
    [mSingleton.environmentURLs setValue:str forKey:LOGIN_SETTINGS_STAGE];
    
    str = [parser get: @"url" section: @"development"];
    [mSingleton.environmentURLs setValue:str forKey:LOGIN_SETTINGS_DEVELOPMENT];
    
    str = [parser get: @"url" section: @"qa"];
    [mSingleton.environmentURLs setValue:str forKey:LOGIN_SETTINGS_QA];
    
    SecurityManager *mSecurityManager = [mSingleton getSecurityManager];
    NSString *envURL = [mSecurityManager getValueForKey:LOGIN_ENVIRONMENT_URL];
    if (!envURL)
    {
        NSString *env = [[mSingleton getSecurityManager] getValueForKey:LOGIN_ENVIRONMENT];
        if (!env)
            [[mSingleton getSecurityManager] setValue:LOGIN_SETTINGS_PRODUCTION forKey:LOGIN_ENVIRONMENT];
        env = [[mSingleton getSecurityManager] getValueForKey:LOGIN_ENVIRONMENT];
        [mSecurityManager setValue:[mSingleton.environmentURLs objectForKey:env] forKey:LOGIN_ENVIRONMENT_URL];
    }
}

-(void)loginWithUserName:(NSString *)username andpassword:(NSString *)password
{
    NSString *URLString = [[mSingleton getSecurityManager] getValueForKey:LOGIN_ENVIRONMENT_URL];
    if (!URLString)
        return;
    
    NSURL *url = [NSURL URLWithString:URLString];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    [httpClient setDefaultHeader:@"username" value:username];
    [httpClient setDefaultHeader:@"password" value:password];
    
    NSDictionary *path = [AiresService objectForKey:@"Service Path"];
    NSString *repativeURL = [path objectForKey:@"Login"];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:repativeURL parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         // Print the response body in text
         [[mSingleton getJSONParser] performSelectorOnMainThread:@selector(parseLoginDetails:) withObject:responseObject waitUntilDone:YES];
         [self fetchProjectsforUser];
         
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN_FAILED object:self];
     }];
    
    ;
    [operation start];
}

-(void)fetchProjectsforUser
{
    NSString *URLString = [[mSingleton getSecurityManager] getValueForKey:LOGIN_ENVIRONMENT_URL];
    if (!URLString)
        return;
    
    NSURL *url = [NSURL URLWithString:URLString];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    [httpClient setDefaultHeader:@"access_token" value:[[mSingleton getSecurityManager] getValueForKey:LOGIN_ACCESSTOKEN]];
    
    NSDictionary *path = [AiresService objectForKey:@"Service Path"];
    NSString *repativeURL = [path objectForKey:@"Project"];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:repativeURL parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         // Print the response body in text
         NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
         
         [[mSingleton getJSONParser] performSelectorOnMainThread:@selector(parseUserProjectData:) withObject:responseObject waitUntilDone:YES];
        
//         [self performSelectorOnMainThread:@selector(getChemicalsList) withObject:nil waitUntilDone:YES];
//         [self performSelectorOnMainThread:@selector(getDeviceTypesList) withObject:nil waitUntilDone:YES];
//         [self performSelectorOnMainThread:@selector(getProtectionEquipmentsList) withObject:nil waitUntilDone:YES];
              }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN_FAILED object:self];
     }];
    
    ;
    [operation start];
    
}

-(void)logout
{
    NSString *URLString = [[mSingleton getSecurityManager] getValueForKey:LOGIN_ENVIRONMENT_URL];
    if (!URLString)
        return;
    
    NSURL *url = [NSURL URLWithString:URLString];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    [httpClient setDefaultHeader:@"access_token" value:[[mSingleton getSecurityManager] getValueForKey:LOGIN_ACCESSTOKEN]];
    
    NSDictionary *path = [AiresService objectForKey:@"Service Path"];
    NSString *repativeURL = [path objectForKey:@"Logout"];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:repativeURL parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         // Print the response body in text
         NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGOUT_SUCCESS object:self];
         
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGOUT_FAILED object:self];
         
     }];
    
    ;
    [operation start];
    
}

-(void)getChemicalsList
{
    NSString *URLString = [AiresService objectForKey:@"Data Service URL"];
    if (!URLString)
        return;
    
    NSURL *url = [NSURL URLWithString:URLString];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    [httpClient setDefaultHeader:@"access_token" value:[[mSingleton getSecurityManager] getValueForKey:LOGIN_ACCESSTOKEN]];
    
    NSDictionary *path = [AiresService objectForKey:@"Data Service Path"];
    NSString *repativeURL = [path objectForKey:@"Chemicals"];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:repativeURL parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         // Print the response body in text
         NSLog(@"Chemicals: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
         //[[mSingleton getJSONParser] performSelectorOnMainThread:@selector(parseChemicalList:) withObject:responseObject waitUntilDone:YES];
         [[mSingleton getJSONParser] parseChemicalList:responseObject];
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         
     }];
    
    ;
    [operation start];
}

-(void)getDeviceTypesList
{
    NSString *URLString = [AiresService objectForKey:@"Data Service URL"];
    if (!URLString)
        return;
    
    NSURL *url = [NSURL URLWithString:URLString];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    [httpClient setDefaultHeader:@"access_token" value:[[mSingleton getSecurityManager] getValueForKey:LOGIN_ACCESSTOKEN]];
    
    NSDictionary *path = [AiresService objectForKey:@"Data Service Path"];
    NSString *repativeURL = [path objectForKey:@"Device Types"];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:repativeURL parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         // Print the response body in text
         NSLog(@"DeviceTypes: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
         //[[mSingleton getJSONParser] performSelectorOnMainThread:@selector(parseDeviceTypeList:) withObject:responseObject waitUntilDone:YES];
         [[mSingleton getJSONParser] parseDeviceTypeList:responseObject];
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         
     }];
    
    ;
    [operation start];
}

-(void)getProtectionEquipmentsList
{
    NSString *URLString = [AiresService objectForKey:@"Data Service URL"];
    if (!URLString)
        return;
    
    NSURL *url = [NSURL URLWithString:URLString];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    [httpClient setDefaultHeader:@"access_token" value:[[mSingleton getSecurityManager] getValueForKey:LOGIN_ACCESSTOKEN]];
    
    NSDictionary *path = [AiresService objectForKey:@"Data Service Path"];
    NSString *repativeURL = [path objectForKey:@"Protection Equipments"];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:repativeURL parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         // Print the response body in text
         NSLog(@"ProtectionEquipment: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
         //[[mSingleton getJSONParser] performSelectorOnMainThread:@selector(parseProtectionEquipmentList:) withObject:responseObject waitUntilDone:YES];
         [[mSingleton getJSONParser] parseProtectionEquipmentList:responseObject];
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         
     }];
    
    ;
    [operation start];
}

@end
