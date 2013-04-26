//
//  PersistentStoreManager.h
//  aires
//
//  Created by Gautham on 22/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User.h"
#import "Project.h"

@interface PersistentStoreManager : NSObject
{
    NSManagedObjectContext * mainContext;
    NSPersistentStoreCoordinator * persistentStoreCoordinator;
    NSManagedObjectModel * managedObjectModel;
    
    BOOL fixingCoreDataUpdate;
    
    NSString *modelName;

}

@property (nonatomic, strong, readonly) NSManagedObjectContext * mainContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator * persistentStoreCoordinator;
@property (nonatomic, strong, readonly) NSManagedObjectModel * managedObjectModel;
@property (nonatomic, strong) NSString *modelName;

- (void) resetCoreData;

//For User
-(void)storeAiresUser:(NSDictionary *)dict;
-(User *)getAiresUser;

-(void)storeProjectDetails:(NSArray *)projects;

@end
