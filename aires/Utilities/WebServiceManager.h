//
//  WebServiceManager.h
//  aires
//
//  Created by Gautham on 18/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Project.h"

@interface WebServiceManager : NSObject
{
    NSMutableDictionary *AiresService;
    NSString *AiresServicePath;
}

-(void)getEnvironment;
-(void)loginWithUserName:(NSString *)username andpassword:(NSString *)password;
-(void)fetchProjectsforUser;
-(void)postProject:(Project *)proj;
-(void)unlockProject:(Project *)proj;
-(void)logout;

-(void)getChemicalsList;
-(void)getDeviceTypesList;
-(void)getProtectionEquipmentsList;

@end
