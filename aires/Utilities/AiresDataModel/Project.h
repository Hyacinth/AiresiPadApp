//
//  Project.h
//  aires
//
//  Created by Gautham on 25/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Sample, User;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSString * project_ClientName;
@property (nonatomic, retain) NSNumber * project_CompletedFlag;
@property (nonatomic, retain) NSString * project_ContactFirstName;
@property (nonatomic, retain) NSString * project_ContactLastName;
@property (nonatomic, retain) NSString * project_ContactPhoneNumber;
@property (nonatomic, retain) NSDate *   project_DateOnsite;
@property (nonatomic, retain) NSString * project_LabEmail;
@property (nonatomic, retain) NSString * project_LabName;
@property (nonatomic, retain) NSString * project_LocationAddress;
@property (nonatomic, retain) NSString * project_LocationAddress2;
@property (nonatomic, retain) NSString * project_LocationCity;
@property (nonatomic, retain) NSString * project_LocationPostalCode;
@property (nonatomic, retain) NSString * project_LocationState;
@property (nonatomic, retain) NSString * project_ProjectDescription;
@property (nonatomic, retain) NSNumber * project_ProjectNumber;
@property (nonatomic, retain) NSDate *   project_TurnAroundTime;
@property (nonatomic, retain) NSNumber * projectID;
@property (nonatomic, retain) NSSet *airesSample;
@property (nonatomic, retain) User *fromUser;
@end

@interface Project (CoreDataGeneratedAccessors)

//- (void)addAiresSampleObject:(Sample *)value;
//- (void)removeAiresSampleObject:(Sample *)value;
//- (void)addAiresSample:(NSSet *)values;
//- (void)removeAiresSample:(NSSet *)values;

@end
