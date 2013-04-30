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
#import "User.h"

#define mSingleton 	((AiresSingleton *) [AiresSingleton getSingletonInstance])

@implementation JSONParser

-(void)parseLoginDetails:(NSData *)jsonData
{
    NSError *error;
    NSDictionary * config = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
	NSDictionary *loginDetails = [config objectForKey:@"response"];
    NSLog(@"Login Data:%@ %@",[loginDetails class ],loginDetails);
    //Save required data
    NSString *accessToken = [loginDetails valueForKey:@"AccessToken"];
    NSDate *currentDate = [mSingleton  getCurrentDeviceTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE,MM-dd-yyyy HH:mm:ss"];
    NSString *accessTokenTime = [dateFormatter stringFromDate:currentDate];
    
    [[mSingleton getSecurityManager] setValue:accessToken forKey:LOGIN_ACCESSTOKEN];
    [[mSingleton getSecurityManager] setValue:accessTokenTime forKey:LOGIN_ACCESSTOKEN_TIME];
    
    NSDictionary *userData = [loginDetails objectForKey:@"User"];
    [[mSingleton getPersistentStoreManager] storeAiresUser:userData];
}

-(void)parseUserProjectData:(NSData *)jsonData
{
    NSError *error;
    NSDictionary * config = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
	NSArray *projectDetails = [config objectForKey:@"response"];
    NSLog(@"projectDetails Data:%@ %@",[projectDetails class ],projectDetails);
    [[mSingleton getPersistentStoreManager] storeProjectDetails:projectDetails ];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN_SUCCESS object:self];
}

@end
