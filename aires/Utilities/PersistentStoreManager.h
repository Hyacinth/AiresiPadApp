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
#import "Sample.h"
#import "SampleChemical.h"
#import "SampleMeasurement.h"
#import "SampleTotalMeasurement.h"

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

//For Project
-(void)storeProjectDetails:(NSArray *)projects;
-(NSArray *)getUserProjects;

//For Sample
-(void)storeSampleDetails:(NSArray *)sample forProject:(Project *)project;
-(NSArray *)getSampleforProject:(Project *)project;

//For SampleChemical
-(void)storeSampleChemicalDetails:(NSArray *)sampleChemical forSample:(Sample *)sample;
-(NSArray *)getSampleChemicalforSample:(Sample *)sample;

//For SampleTotalMeasurement
-(void)storeSampleTotalMeasurementDetails:(NSArray *)sampleTotalMeaseurement forSample:(Sample *)sample;
-(NSArray *)getSampleTotalMeasurementforSample:(Sample *)sample;

//For SampleMeasurement
-(void)storeSampleMeasurementDetails:(NSArray *)sampleMeaseurement forSample:(Sample *)sample;
-(NSArray *)getSampleMeasurementforSample:(Sample *)sample;


@end
