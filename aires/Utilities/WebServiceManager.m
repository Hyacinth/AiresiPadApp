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

#define mSingleton 	((AiresSingleton *) [AiresSingleton getSingletonInstance])

@implementation WebServiceManager


-(void)getEnvironment
{
    NSURL *url = [NSURL URLWithString:@"http://192.168.6.18/AiresStaging/config.txt"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSString* newStr = [[NSString alloc] initWithData:data
                                              encoding:NSUTF8StringEncoding];

    //save content to the documents directory
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"config.txt"];

//    [newStr writeToFile:path
//              atomically:NO
//                encoding:NSStringEncodingConversionAllowLossy
//                   error:nil];

    INIParser * parser;
    
    parser = [[INIParser alloc] init];

    int err;
    
    const char *stringAsChar = [path cStringUsingEncoding:[NSString defaultCStringEncoding]];
    err = [parser parse: stringAsChar];

    NSString * str;
    
    str = [parser get: @"url" section: @"production"];       // For generic strings
   }

-(void)loginWithUserName:(NSString *)username andpassword:(NSString *)password
{
    NSURL *url = [NSURL URLWithString:@"http://192.168.6.18/AiresStaging/BusinessServices/AiresRESTService.svc/"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [httpClient setDefaultHeader:@"Accept" value:@"application/json;odata=verbose"];
    [httpClient setDefaultHeader:@"username" value:username];
    [httpClient setDefaultHeader:@"password" value:password];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"Login" parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        // Print the response body in text
        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
        [[mSingleton getJSONParser] performSelectorOnMainThread:@selector(parseLoginDetails:) withObject:responseObject waitUntilDone:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN_SUCCESS object:self];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"Error: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN_FAILED object:self];
    }];
    
    ;
    [operation start];
}

-(void)fetchProjectsforUser
{
    NSURL *url = [NSURL URLWithString:@"http://192.168.6.18/AiresStaging/BusinessServices/AiresRESTService.svc/"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json;odata=verbose"];
    [httpClient setDefaultHeader:@"access_token" value:[[mSingleton getSecurityManager] getValueForKey:LOGIN_ACCESSTOKEN]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"ProjectDetails" parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         // Print the response body in text
         NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
         
         //[[mSingleton getJSONParser] performSelectorOnMainThread:@selector(parseLoginDetails:) withObject:responseObject waitUntilDone:YES];
         
     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
    
    ;
    [operation start];

}

@end
