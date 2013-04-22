//
//  User.h
//  aires
//
//  Created by Gautham on 22/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project;

@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * user_CertificationId;
@property (nonatomic, retain) NSString * user_FirstName;
@property (nonatomic, retain) NSNumber * user_Id;
@property (nonatomic, retain) NSData * user_Image;
@property (nonatomic, retain) NSNumber * user_iOSDeviceId;
@property (nonatomic, retain) NSString * user_LastName;
@property (nonatomic, retain) NSString * user_LoginName;
@property (nonatomic, retain) NSSet *airesProject;
@end

@interface User (CoreDataGeneratedAccessors)

//- (void)addAiresProjectObject:(Project *)value;
//- (void)removeAiresProjectObject:(Project *)value;
//- (void)addAiresProject:(NSSet *)values;
//- (void)removeAiresProject:(NSSet *)values;

@end
