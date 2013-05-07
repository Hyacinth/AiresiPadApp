//
//  SampleMeasurement.h
//  aires
//
//  Created by Gautham on 26/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Sample;

@interface SampleMeasurement : NSManagedObject

@property (nonatomic, retain) NSNumber * sampleMeasurement_OffFlowRate;
@property (nonatomic, retain) NSString * sampleMeasurement_OffTime;
@property (nonatomic, retain) NSNumber * sampleMeasurement_OnFlowRate;
@property (nonatomic, retain) NSString * sampleMeasurement_OnTime;
@property (nonatomic, retain) NSNumber * sampleMesurementID;
@property (nonatomic, retain) NSNumber * sampleMeasurement_TotalArea;
@property (nonatomic, retain) NSNumber * sampleMeasurement_TotalMinutes;
@property (nonatomic, retain) NSNumber * sampleMeasurement_TotalVolume;
@property (nonatomic, retain) Sample *fromSample;
@property (nonatomic, retain) NSNumber *deleted;

@end
