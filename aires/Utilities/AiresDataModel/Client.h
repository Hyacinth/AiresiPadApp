//
//  Client.h
//  aires
//
//  Created by Gautham on 07/05/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project;

@interface Client : NSManagedObject

@property (nonatomic, retain) NSString * client_City;
@property (nonatomic, retain) NSNumber * clientID;
@property (nonatomic, retain) NSString * client_CreateOn;
@property (nonatomic, retain) NSString * client_State;
@property (nonatomic, retain) NSString * client_Name;
@property (nonatomic, retain) Project *fromProject;

@end
