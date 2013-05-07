//
//  Contact.h
//  aires
//
//  Created by Gautham on 07/05/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project;

@interface Contact : NSManagedObject

@property (nonatomic, retain) NSNumber * contactID;
@property (nonatomic, retain) NSNumber * contact_ClientId;
@property (nonatomic, retain) NSDate * contact_CreatedOn;
@property (nonatomic, retain) NSString * contact_Client;
@property (nonatomic, retain) NSString * contact_PhoneNumber;
@property (nonatomic, retain) NSString * contact_MobileNumber;
@property (nonatomic, retain) NSString * contact_LastName;
@property (nonatomic, retain) NSString * contact_Email;
@property (nonatomic, retain) NSString * contact_Firstname;
@property (nonatomic, retain) Project *fromProject;

@end
