//
//  Project.h
//  aires
//
//  Created by Gautham on 25/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Sample, User, Contact, Lab, Client;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSString * project_ClientName;
@property (nonatomic, retain) NSNumber * project_CompletedFlag;
@property (nonatomic, retain) NSString * project_ContactFirstName;
@property (nonatomic, retain) NSString * project_ContactLastName;
@property (nonatomic, retain) NSString * project_ContactPhoneNumber;
@property (nonatomic, retain) NSString * project_ContactEmail;
@property (nonatomic, retain) NSString * project_DateOnsite;
@property (nonatomic, retain) NSString * project_LabEmail;
@property (nonatomic, retain) NSString * project_LabName;
@property (nonatomic, retain) NSString * project_LocationAddress;
@property (nonatomic, retain) NSString * project_LocationAddress2;
@property (nonatomic, retain) NSString * project_LocationCity;
@property (nonatomic, retain) NSString * project_LocationPostalCode;
@property (nonatomic, retain) NSString * project_LocationState;
@property (nonatomic, retain) NSString * project_ProjectDescription;
@property (nonatomic, retain) NSString * project_ProjectNumber;
@property (nonatomic, retain) NSString * project_QCPerson;
@property (nonatomic, retain) NSString *   project_TurnAroundTime;
@property (nonatomic, retain) NSNumber * projectID;
@property (nonatomic, retain) NSNumber * clientID;
@property (nonatomic, retain) NSNumber * labID;
@property (nonatomic, retain) NSString * project_CreatedBy;
@property (nonatomic, retain) NSNumber * contactID;
@property (nonatomic, retain) NSString * project_createdOn;
@property (nonatomic, retain) NSNumber * consultantId;
@property (nonatomic, retain) NSNumber * project_TurnAroundTimeId;
@property (nonatomic, retain) NSString * userProjects;

@property (nonatomic, retain) NSSet *airesSample;
@property (nonatomic, retain) User *fromUser;
@property (nonatomic, retain) Contact *airesContact;
@property (nonatomic, retain) Lab *airesLab;
@property (nonatomic, retain) Client *airesClient;

@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addAiresSampleObject:(Sample *)value;
- (void)removeAiresSampleObject:(Sample *)value;
- (void)addAiresSample:(NSSet *)values;
- (void)removeAiresSample:(NSSet *)values;

- (void)addAiresContactObject:(Contact *)value;
- (void)removeAiresContactObject:(Contact *)value;

- (void)addAiresLabObject:(Lab *)value;
- (void)removeAiresLabObject:(Lab *)value;

- (void)addAiresClientObject:(Client *)value;
- (void)removeAiresClientObject:(Client *)value;

@end
