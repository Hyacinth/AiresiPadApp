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
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"Login" parameters:nil];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            // Print the response body in text
            NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
            
            [[mSingleton getJSONParser] performSelectorOnMainThread:@selector(parseLoginDetails:) withObject:jsonData waitUntilDone:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
        ;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN_SUCCESS object:self];
        [operation start];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN_FAILED object:self];
    }
    
}
@end
