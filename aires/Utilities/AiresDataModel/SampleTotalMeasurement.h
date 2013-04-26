//
//  SampleTotalMeasurement.h
//  aires
//
//  Created by Gautham on 26/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Sample;

@interface SampleTotalMeasurement : NSManagedObject

@property (nonatomic, retain) NSNumber * sampleTotalMeasurement_TotalArea;
@property (nonatomic, retain) NSNumber * sampleTotalMeasurement_TotalMinutes;
@property (nonatomic, retain) NSNumber * sampleTotalMeasurement_TotalVolume;
@property (nonatomic, retain) NSNumber * sampleTotalMeasurementID;
@property (nonatomic, retain) Sample *fromSample;

@end
