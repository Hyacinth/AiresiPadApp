//
//  MeasurementFields.h
//  aires
//
//  Created by Mani on 5/16/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeasurementFields : NSObject

@property (nonatomic, retain) NSNumber * sampleMeasurement_OffFlowRate;
@property (nonatomic, retain) NSString * sampleMeasurement_OffTime;
@property (nonatomic, retain) NSNumber * sampleMeasurement_OnFlowRate;
@property (nonatomic, retain) NSString * sampleMeasurement_OnTime;
@property (nonatomic, retain) NSNumber * sampleMeasurement_Area;
@property (nonatomic, retain) NSNumber * sampleMeasurement_Mintes;
@property (nonatomic, retain) NSNumber * sampleMeasurement_Volume;

@end
