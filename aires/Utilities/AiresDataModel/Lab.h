//
//  Lab.h
//  aires
//
//  Created by Gautham on 07/05/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project;

@interface Lab : NSManagedObject

@property (nonatomic, retain) NSNumber * labID;
@property (nonatomic, retain) NSString * lab_labEmail;
@property (nonatomic, retain) NSDate * lab_CreatedOn;
@property (nonatomic, retain) NSString * lab_LabName;
@property (nonatomic, retain) Project *fromProject;

@end
