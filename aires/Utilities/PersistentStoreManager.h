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
#import "SampleProtectionEquipment.h"
#import "DeviceType.h"
#import "Client.h"
#import "Contact.h"
#import "Lab.h"
#import "SampleType.h"

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
-(void)removeAiresUser;

//For Project
-(void)storeProjectDetails:(NSArray *)projects;
-(NSArray *)getUserProjects;
-(void)removeAllProjectDetails;

-(NSArray *)getCompletedUserProjects;
-(NSArray *)getLiveUserProjects;

//For Sample
-(void)storeSampleDetails:(NSArray *)sample forProject:(Project *)project;
-(NSArray *)getSampleforProject:(Project *)project;
-(void)updateSample:(Sample *)sample inProject:(Project *)proj forField:(NSString *)field withValue:(id)value;

//For SampleChemical
-(void)storeSampleChemicalDetails:(NSArray *)sampleChemical forSample:(Sample *)sample;
-(NSArray *)getSampleChemicalforSample:(Sample *)sample;
-(void)updateSampleChemical:(SampleChemical *)sampleChemical inSample:(Sample *)sample forField:(NSString *)field withValue:(id)value;

//For SampleMeasurement
-(void)storeSampleMeasurementDetails:(NSArray *)sampleMeaseurement forSample:(Sample *)sample;
-(NSArray *)getSampleMeasurementforSample:(Sample *)sample;
-(void)updateSampleMeasurement:(SampleMeasurement *)sampleMeasurement inSample:(Sample *)sample forField:(NSString *)field withValue:(id)value;

//For SampleProtectionEquipment
-(void)storeSampleProtectionEquipmentDetails:(NSArray *)sampleProtectionEquipment forSample:(Sample *)sample;
-(NSArray *)getSampleProtectionEquipmentforSample:(Sample *)sample;
-(void)updateSampleProtectionEquipment:(SampleProtectionEquipment *)sampleProtectionEquipment inSample:(Sample *)sample forField:(NSString *)field withValue:(id)value;

//Default list methods
-(void)saveChemicalList:(NSArray *)chemicalArray;
-(NSArray *)getChemicalList;

-(void)saveDeviceTypeList:(NSArray *)deviceArray;
-(NSArray *)getDeviceTypeList;

-(void)saveProtectionEquipmentList:(NSArray *)equipmentArray;
-(NSArray *)getProtectionEquipmentList;

-(void)saveSampleTypeList:(NSArray *)sampletypeArray;
-(NSArray *)getSampleyTypeList;

-(NSNumber *)generateIDforNewSample;
-(NSNumber *)generateIDforNewSampleChemical;
-(NSNumber *)generateIDforNewSampleMeasurement;
-(NSNumber *)generateIDforNewSampleProtectionEquipment;
-(NSString *)generateNumberforNewSample;

@end
