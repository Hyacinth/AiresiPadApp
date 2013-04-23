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

-(void)getEnvironment;
-(void)loginWithUserName:(NSString *)username andpassword:(NSString *)password;
-(void)fetchProjectsforUser;

@end
