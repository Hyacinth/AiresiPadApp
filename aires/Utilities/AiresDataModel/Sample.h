//
//  Sample.h
//  aires
//
//  Created by Gautham on 26/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project, SampleChemical, SampleMeasurement, SampleProtectionEquipment, SampleTotalMeasurement;

@interface Sample : NSManagedObject

@property (nonatomic, retain) NSString * sample_Comments;
@property (nonatomic, retain) NSString * sample_DeviceTypeName;
@property (nonatomic, retain) NSString * sample_EmployeeJob;
@property (nonatomic, retain) NSString * sample_EmployeeName;
@property (nonatomic, retain) NSString * sample_Notes;
@property (nonatomic, retain) NSString * sample_OperationArea;
@property (nonatomic, retain) NSNumber * sample_SampleId;
@property (nonatomic, retain) NSString * sample_SampleNumber;
@property (nonatomic, retain) NSNumber * sampleID;
@property (nonatomic, retain) NSSet *    airesSampleChemical;
@property (nonatomic, retain) NSSet *    airesSampleMeasurement;
@property (nonatomic, retain) NSSet *    airesSampleProtectionEquipment;
@property (nonatomic, retain) SampleTotalMeasurement *airesSampleTotalMeasurement;
@property (nonatomic, retain) Project *fromProject;
@end

@interface Sample (CoreDataGeneratedAccessors)

- (void)addAiresSampleChemicalObject:(SampleChemical *)value;
- (void)removeAiresSampleChemicalObject:(SampleChemical *)value;
- (void)addAiresSampleChemical:(NSSet *)values;
- (void)removeAiresSampleChemical:(NSSet *)values;

- (void)addAiresSampleMeasurementObject:(SampleMeasurement *)value;
- (void)removeAiresSampleMeasurementObject:(SampleMeasurement *)value;
- (void)addAiresSampleMeasurement:(NSSet *)values;
- (void)removeAiresSampleMeasurement:(NSSet *)values;

//- (void)addAiresSampleProtectionEquipmentObject:(SampleProtectionEquipment *)value;
//- (void)removeAiresSampleProtectionEquipmentObject:(SampleProtectionEquipment *)value;
//- (void)addAiresSampleProtectionEquipment:(NSSet *)values;
//- (void)removeAiresSampleProtectionEquipment:(NSSet *)values;

- (void)addAiresSampleTotalMeasurementObject:(SampleTotalMeasurement *)value;
- (void)removeAiresSampleTotalMeasurementObject:(SampleTotalMeasurement *)value;
- (void)addAiresSampleTotalMeasurement:(NSSet *)values;
- (void)removeAiresSampleTotalMeasurement:(NSSet *)values;

@end
