//
//  DeviceType.h
//  aires
//
//  Created by Gautham on 30/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DeviceType : NSManagedObject

@property (nonatomic, retain) NSNumber *deviceType_DeviceTypeID;
@property (nonatomic, retain) NSString *deviceType_DeviceTypeName;
@property (nonatomic, retain) NSNumber *deviceTypeID;
@property (nonatomic, retain) NSString *contentType;

@end
