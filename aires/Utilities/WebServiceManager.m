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
@end
