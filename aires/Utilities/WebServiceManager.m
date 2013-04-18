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

#define mSingleton 	((AiresSingleton *) [AiresSingleton getSingletonInstance])

@implementation WebServiceManager

- (void)loginWithUserName:(NSString *)username password:(NSString *)password andAccessToken:(NSString *)accessToken
{
    BOOL doLogin = FALSE;
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.6.18/AiresStaging/AiresDataService.svc/Login?$expand=User"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json;odata=verbose"];
    
    if (accessToken || [accessToken length] > 0)
    {
        [httpClient setDefaultHeader:@"access_token" value:accessToken];
        doLogin = TRUE;
    }
    else
    {
        [httpClient setDefaultHeader:@"username" value:username];
        [httpClient setDefaultHeader:@"password" value:password];
        doLogin = TRUE;
    }
    if (doLogin) {
        
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:nil parameters:nil];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                             {
                                                 NSLog(@"Success");
                                                 NSError *error;
                                                 NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:&error];
                                                 
                                                 [[mSingleton getJSONParser] performSelectorOnMainThread:@selector(parseLoginDetails:) withObject:jsonData waitUntilDone:NO];                                                 [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN_SUCCESS object:self];
                                                 
                                                 
                                             }
                                                                                            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                             {
                                                 NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
                                                 NSLog(@"Failure");
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN_FAILED object:self];
                                                 
                                             }];
        
        [operation start];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN_FAILED object:self];
    }
    
}

-(void)tryLogin
{
    NSURL *url = [NSURL URLWithString:@"http://192.168.6.18/AiresStaging/AiresDataService.svc/Login?$expand=User"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json;odata=verbose"];
    [httpClient setDefaultHeader:@"username" value:@"gbtpa\\dcreggett"];
    [httpClient setDefaultHeader:@"password" value:@"password123"];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:nil parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             NSLog(@"Success");
                                             NSError *error;
                                             NSData *jsonData = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:&error];
                                             
                                             [[mSingleton getJSONParser] performSelectorOnMainThread:@selector(parseLoginDetails:) withObject:jsonData waitUntilDone:YES];
                                             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN_SUCCESS object:self];
                                             
                                             
                                         }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                         {
                                             NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
                                             NSLog(@"Failure");
                                             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN_FAILED object:self];
                                             
                                         }];
    
    [operation start];
    
}

@end
