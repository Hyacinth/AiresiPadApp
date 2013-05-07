//
//  JSONParser.h
//  aires
//
//  Created by Gautham on 18/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Project.h"

@interface JSONParser : NSObject
{
    
}

-(void)parseLoginDetails:(NSData *)jsonData;
-(void)parseUserProjectData:(NSData *)jsonData;

-(void)parseProtectionEquipmentList:(NSData *)jsonData;
-(void)parseDeviceTypeList:(NSData *)jsonData;
-(void)parseChemicalList:(NSData *)jsonData;

-(void)createJsonforProject:(Project *)proj;
@end
