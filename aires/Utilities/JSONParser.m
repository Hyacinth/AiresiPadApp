//
//  JSONParser.m
//  aires
//
//  Created by Gautham on 18/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "JSONParser.h"
#import "CJSONDataSerializer.h"
#import "CJSONDeserializer.h"
#import "AiresSingleton.h"

#define mSingleton 	((AiresSingleton *) [AiresSingleton getSingletonInstance])

@implementation JSONParser

-(void)parseLoginDetails:(NSData *)jsonData
{
    NSError *error;
    NSDictionary * config = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
	NSArray *loginDetails = [config objectForKey:@"d"];
    NSLog(@"Login Data:%@",loginDetails);
    //Save required data
    for (NSDictionary *loginData in loginDetails)
    {
        NSLog(@"Class Types");
        NSLog(@"AccessToken %@",[[loginData valueForKey:@"AccessToken"] class]);
        NSLog(@"LoginDateTime %@",[[loginData valueForKey:@"LoginDateTime"] class]);
        NSLog(@"User %@",[[loginData valueForKey:@"User"] class]);
        NSLog(@"UserId %@",[[loginData valueForKey:@"UserId"] class]);
        NSLog(@"UserName %@",[[loginData valueForKey:@"UserName"] class]);
        NSLog(@"__metadata %@",[[loginData valueForKey:@"__metadata"] class]);

        
        NSArray *UserDetails = [loginData objectForKey:@"User"];
        for (NSDictionary *UserData in UserDetails)
        {
            NSLog(@"Class Types");

        }
        
        NSString *accessToken = [loginData valueForKey:@"AccessToken"];
        NSDate *currentDate = [mSingleton  getCurrentDeviceTime];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE,MM-dd-yyyy HH:mm:ss"];
        NSString *accessTokenTime = [dateFormatter stringFromDate:currentDate];

        [[mSingleton getSecurityManager] setValue:accessToken forKey:LOGIN_ACCESSTOKEN];
        [[mSingleton getSecurityManager] setValue:accessTokenTime forKey:LOGIN_ACCESSTOKEN_TIME];
    }
}

@end
