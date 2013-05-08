//
//  SampleType.h
//  aires
//
//  Created by Gautham on 08/05/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Sample;

@interface SampleType : NSManagedObject

@property (nonatomic, retain) NSNumber * sampleTypeID;
@property (nonatomic, retain) NSString * sampleTypeName;
@property (nonatomic, retain) Sample *fromSample;

@end
