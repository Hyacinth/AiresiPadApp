//
//  WebServiceManager.h
//  aires
//
//  Created by Gautham on 18/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServiceManager : NSObject
{
    
}

-(void)loginWithUserName:(NSString *)username password:(NSString *)password andAccessToken:(NSString *)accessToken;
-(void)tryLogin;

@end
