//
//  SampleChemical.h
//  aires
//
//  Created by Gautham on 26/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Sample;

@interface SampleChemical : NSManagedObject

@property (nonatomic, retain) NSString * sampleChemical_Name;
@property (nonatomic, retain) NSNumber * sampleChemicalID;
@property (nonatomic, retain) NSNumber * sampleChemical_PELCFlag;
@property (nonatomic, retain) NSNumber * sampleChemical_TLVTWAFlag;
@property (nonatomic, retain) NSNumber * sampleChemical_TLVSTELFlag;
@property (nonatomic, retain) NSNumber * sampleChemical_TLVCFlag;
@property (nonatomic, retain) NSNumber * sampleChemical_PELTWAFlag;
@property (nonatomic, retain) NSNumber * sampleChemical_PELSTELFlag;
@property (nonatomic, retain) Sample *fromSample;
@property (nonatomic, retain) NSString * contentType;

@end
