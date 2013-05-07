//
//  JSONParser.m
//  aires
//
//  Created by Gautham on 18/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "JSONParser.h"
#import "CJSONDataSerializer.h"
#import "CJSONDeserializer.h"
#import "AiresSingleton.h"
#import "User.h"
#import "CJSONSerializer.h"

#define mSingleton 	((AiresSingleton *) [AiresSingleton getSingletonInstance])

@implementation JSONParser

-(void)parseLoginDetails:(NSData *)jsonData
{
    NSError *error;
    NSDictionary * config = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
	NSDictionary *loginDetails = [config objectForKey:@"response"];
    NSLog(@"Login Data:%@ %@",[loginDetails class ],loginDetails);
    //Save required data
    NSString *accessToken = [loginDetails valueForKey:@"AccessToken"];
    NSDate *currentDate = [mSingleton  getCurrentDeviceTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE,MM-dd-yyyy HH:mm:ss"];
    NSString *accessTokenTime = [dateFormatter stringFromDate:currentDate];
    
    [[mSingleton getSecurityManager] setValue:accessToken forKey:LOGIN_ACCESSTOKEN];
    [[mSingleton getSecurityManager] setValue:accessTokenTime forKey:LOGIN_ACCESSTOKEN_TIME];
    
    NSDictionary *userData = [loginDetails objectForKey:@"User"];
    [[mSingleton getPersistentStoreManager] storeAiresUser:userData];
}

-(void)parseUserProjectData:(NSData *)jsonData
{
    NSError *error;
    NSDictionary * config = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
	NSArray *projectDetails = [config objectForKey:@"response"];
    NSLog(@"projectDetails Data:%@ %@",[projectDetails class ],projectDetails);
    [[mSingleton getPersistentStoreManager] storeProjectDetails:projectDetails ];
    
    [[mSingleton getWebServiceManager] getChemicalsList];
    [[mSingleton getWebServiceManager] getDeviceTypesList];
    [[mSingleton getWebServiceManager] getProtectionEquipmentsList];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN_SUCCESS object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FETCH_PROJECT_SUCCESS object:self];
    
}

-(void)parseChemicalList:(NSData *)jsonData
{
    NSError *error;
    NSDictionary * config = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
	NSArray *chemicalDetails = [config objectForKey:@"value"];
    NSLog(@"Chemical Data:%@ %@",[chemicalDetails class ],chemicalDetails);
    [[mSingleton getPersistentStoreManager] saveChemicalList:chemicalDetails];
}

-(void)parseDeviceTypeList:(NSData *)jsonData
{
    NSError *error;
    NSDictionary * config = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
	NSArray *deviceDetails = [config objectForKey:@"value"];
    NSLog(@"Device Type Data:%@ %@",[deviceDetails class ],deviceDetails);
    [[mSingleton getPersistentStoreManager] saveDeviceTypeList:deviceDetails];
}

-(void)parseProtectionEquipmentList:(NSData *)jsonData
{
    NSError *error;
    NSDictionary * config = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
	NSArray *equipmentDetails = [config objectForKey:@"value"];
    NSLog(@"Equipment Data:%@ %@",[equipmentDetails class ],equipmentDetails);
    [[mSingleton getPersistentStoreManager] saveProtectionEquipmentList:equipmentDetails];
    
    [[mSingleton getPersistentStoreManager] getChemicalList];
    [[mSingleton getPersistentStoreManager] getDeviceTypeList];
    [[mSingleton getPersistentStoreManager] getProtectionEquipmentList];
}

-(void)createJsonforProject:(Project *)proj
{
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *ProjectDetailsDict = [[NSMutableDictionary alloc] init];
    [ProjectDetailsDict setValue:proj.projectID forKey:@"ProjectId"];
    [ProjectDetailsDict setValue:proj.clientID forKey:@"ClientId"];
    [ProjectDetailsDict setValue:proj.contactID forKey:@"ContactId"];
    [ProjectDetailsDict setValue:proj.project_ProjectNumber forKey:@"ProjectNumber"];
    [ProjectDetailsDict setValue:proj.project_ProjectDescription forKey:@"ProjectDescription"];
    [ProjectDetailsDict setValue:proj.project_DateOnsite forKey:@"DateOnsite"];
    [ProjectDetailsDict setValue:proj.project_LocationAddress forKey:@"LocationAddress"];
    [ProjectDetailsDict setValue:proj.project_LocationAddress2 forKey:@"LocationAddress2"];
    [ProjectDetailsDict setValue:proj.project_LocationCity forKey:@"LocationCity"];
    [ProjectDetailsDict setValue:proj.project_LocationState forKey:@"LocationState"];
    [ProjectDetailsDict setValue:proj.project_LocationPostalCode forKey:@"LocationPostalCode"];
    [ProjectDetailsDict setValue:proj.consultantId forKey:@"ConsultantId"];
    [ProjectDetailsDict setValue:proj.labID forKey:@"LabId"];
    [ProjectDetailsDict setValue:proj.project_QCPerson forKey:@"QCPerson"];
    [ProjectDetailsDict setValue:proj.project_TurnAroundTime forKey:@"TurnaroundTimeId"];
    [ProjectDetailsDict setValue:proj.project_CompletedFlag forKey:@"CompletedFlag"];
    [ProjectDetailsDict setValue:proj.project_createdOn forKey:@"CreatedOn"];
    [ProjectDetailsDict setValue:proj.project_CreatedBy forKey:@"CreatedBy"];
    
    NSMutableDictionary *ClientDict = [[NSMutableDictionary alloc] init];
    [ClientDict setValue:proj.clientID forKey:@"ClientId"];
    [ClientDict setValue:proj.project_ClientName forKey:@"ClientName"];
    [ClientDict setValue:proj.airesClient.client_City forKey:@"ClientCity"];
    [ClientDict setValue:proj.airesClient.client_State forKey:@"ClientState"];
    [ClientDict setValue:proj.airesClient.client_CreateOn forKey:@"CreatedOn"];
    [ClientDict setValue:nil forKey:@"Contacts"];
    [ClientDict setValue:nil forKey:@"Projects"];
    [ProjectDetailsDict setValue:ClientDict forKey:@"Client"];//Dictionary
    
    NSMutableDictionary *ContacttDict = [[NSMutableDictionary alloc] init];
    [ContacttDict setValue:proj.airesContact.contactID forKey:@"ContactId"];
    [ContacttDict setValue:proj.airesContact.contact_ClientId forKey:@"ClientId"];
    [ContacttDict setValue:proj.airesContact.contact_Firstname forKey:@"FirstName"];
    [ContacttDict setValue:proj.airesContact.contact_LastName forKey:@"LastName"];
    [ContacttDict setValue:proj.airesContact.contact_PhoneNumber forKey:@"PhoneNumber"];
    [ContacttDict setValue:proj.airesContact.contact_MobileNumber forKey:@"MobileNumber"];
    [ContacttDict setValue:proj.airesContact.contact_Email forKey:@"Email"];
    [ContacttDict setValue:proj.airesContact.contact_CreatedOn forKey:@"CreatedOn"];
    [ContacttDict setValue:proj.airesContact.contact_Client forKey:@"Client"];
    [ContacttDict setValue:nil forKey:@"Projects"];
    [ProjectDetailsDict setValue:ContacttDict forKey:@"Contact"];//Dictionary
    
    NSMutableDictionary *LabDict = [[NSMutableDictionary alloc] init];
    [LabDict setValue:proj.airesLab.labID forKey:@"LabId"];
    [LabDict setValue:proj.airesLab.lab_LabName forKey:@"LabName"];
    [LabDict setValue:proj.airesLab.lab_labEmail forKey:@"LabEmail"];
    [LabDict setValue:proj.airesLab.lab_CreatedOn forKey:@"CreatedOn"];
    [LabDict setValue:nil forKey:@"Projects"];
    [ProjectDetailsDict setValue:LabDict forKey:@"Lab"];//Dictionary
    
    [ProjectDetailsDict setValue:proj.project_TurnAroundTime forKey:@"TurnaroundTime"];
    [ProjectDetailsDict setValue:nil forKey:@"User"];
    
    NSMutableArray *samplesArray = [[NSMutableArray alloc] init];
    NSArray *projSamples = [[mSingleton getPersistentStoreManager] getSampleforProject:proj];
    for (Sample *samp in projSamples)
    {
        NSMutableDictionary *SamplesDict = [[NSMutableDictionary alloc] init];
        [SamplesDict setValue:samp.sampleID forKey:@"SampleId"];
        [SamplesDict setValue:nil forKey:@"ProjectId"];
        [SamplesDict setValue:samp.sample_SampleNumber forKey:@"SampleNumber"];
        [SamplesDict setValue:samp.sample_SampleId forKey:@"SampleTypeId"];
        [SamplesDict setValue:nil forKey:@"PPEId"];
        [SamplesDict setValue:samp.sample_Comments forKey:@"Comments"];
        [SamplesDict setValue:samp.sample_Notes forKey:@"Notes"];
        [SamplesDict setValue:nil forKey:@"DeviceTypeId"];
        [SamplesDict setValue:nil forKey:@"Area"];
        [SamplesDict setValue:nil forKey:@"Minutes"];
        [SamplesDict setValue:nil forKey:@"Volume"];
        [SamplesDict setValue:samp.sample_EmployeeName forKey:@"EmployeeName"];
        [SamplesDict setValue:samp.sample_EmployeeJob forKey:@"EmployeeJob"];
        [SamplesDict setValue:samp.sample_OperationArea forKey:@"OperationArea"];
        [SamplesDict setValue:nil forKey:@"CreatedOn"];
        [SamplesDict setValue:nil forKey:@"DeviceType"];
        [SamplesDict setValue:nil forKey:@"Project"];
        [SamplesDict setValue:nil forKey:@"Results"];
        
        NSMutableArray *measurementArray = [[NSMutableArray alloc] init];
        NSArray *sampleMeasurement = [[mSingleton getPersistentStoreManager] getSampleMeasurementforSample:samp];
        for (SampleMeasurement *sampMeas in sampleMeasurement)
        {
            NSMutableDictionary *MeasurementDict = [[NSMutableDictionary alloc] init];
            [MeasurementDict setValue:nil forKey:@"MeasurementId"];
            [MeasurementDict setValue:nil forKey:@"SampleId"];
            [MeasurementDict setValue:sampMeas.sampleMeasurement_OnTime forKey:@"OnTime"];
            [MeasurementDict setValue:sampMeas.sampleMeasurement_OffTime forKey:@"OffTime"];
            [MeasurementDict setValue:sampMeas.sampleMeasurement_OnFlowRate forKey:@"OnFlowRate"];
            [MeasurementDict setValue:sampMeas.sampleMeasurement_OffFlowRate forKey:@"OffFlowRate"];
            [MeasurementDict setValue:sampMeas.sampleMeasurement_TotalArea forKey:@"Area"];
            [MeasurementDict setValue:sampMeas.sampleMeasurement_TotalMinutes forKey:@"Minutes"];
            [MeasurementDict setValue:sampMeas.sampleMeasurement_TotalVolume forKey:@"Volume"];
            [MeasurementDict setValue:sampMeas.deleted forKey:@"Deleted"];
            [MeasurementDict setValue:nil forKey:@"Sample"];
            [measurementArray addObject:MeasurementDict];
        }
        [SamplesDict setValue:measurementArray forKey:@"Measurements"];//Dict Array
        
        NSMutableArray *sampleChemicalArray = [[NSMutableArray alloc] init];
        NSArray *sampleChemicals = [[mSingleton getPersistentStoreManager] getSampleChemicalforSample:samp];
        for (SampleChemical *sampChe in sampleChemicals)
        {
            NSMutableDictionary *SampleChemicalDict = [[NSMutableDictionary alloc] init];
            [SampleChemicalDict setValue:nil forKey:@"SampleChemicalId"];
            [SampleChemicalDict setValue:nil forKey:@"SampleId"];
            [SampleChemicalDict setValue:sampChe.sampleChemicalID forKey:@"ChemicalId"];
            [SampleChemicalDict setValue:sampChe.sampleChemical_PELTWAFlag forKey:@"PELTWAFlag"];
            [SampleChemicalDict setValue:sampChe.sampleChemical_PELSTELFlag forKey:@"PELSTELFlag"];
            [SampleChemicalDict setValue:sampChe.sampleChemical_PELCFlag forKey:@"PELCFlag"];
            [SampleChemicalDict setValue:sampChe.sampleChemical_TLVTWAFlag forKey:@"TLVTWAFlag"];
            [SampleChemicalDict setValue:sampChe.sampleChemical_TLVSTELFlag forKey:@"TLVSTELFlag"];
            [SampleChemicalDict setValue:sampChe.sampleChemical_TLVCFlag forKey:@"TLVCFlag"];
            [SampleChemicalDict setValue:sampChe.deleted forKey:@"Deleted"];
            [SampleChemicalDict setValue:sampChe.sampleChemical_Name forKey:@"Chemical"];
            [SampleChemicalDict setValue:nil forKey:@"Results"];
            [SampleChemicalDict setValue:nil forKey:@"Sample"];
            [sampleChemicalArray addObject:SampleChemicalDict];
        }
        [SamplesDict setValue:sampleChemicalArray forKey:@"SampleChemicals"];//Dict Array
        
        NSMutableArray *samplePPEArray = [[NSMutableArray alloc] init];
        NSArray *samplePPE = [[mSingleton getPersistentStoreManager] getSampleProtectionEquipmentforSample:samp];
        for (SampleProtectionEquipment *sampPPE in samplePPE)
        {
            NSMutableDictionary *SamplePPEDict = [[NSMutableDictionary alloc] init];
            [SamplePPEDict setValue:sampPPE.sampleProtectionEquipmentID forKey:@"SamplePPEId"];
            [SamplePPEDict setValue:nil forKey:@"SamplesId"];
            [SamplePPEDict setValue:sampPPE.sampleProtectionEquipmentID forKey:@"PPEId"];
            [SamplePPEDict setValue:sampPPE.deleted forKey:@"Deleted"];
            [SamplePPEDict setValue:sampPPE.sampleProtectionEquipment_Name forKey:@"PPE"];
            [SamplePPEDict setValue:nil forKey:@"Sample"];
            [samplePPEArray addObject:SamplePPEDict];
        }
        [SamplesDict setValue:samplePPEArray forKey:@"SamplePPEs"];//Dict Array
        
        NSMutableDictionary *SampleTypeDict = [[NSMutableDictionary alloc] init];
        [SampleTypeDict setValue:nil forKey:@"SampleTypeId"];
        [SampleTypeDict setValue:nil forKey:@"SampleTypeName"];
        [SampleTypeDict setValue:nil forKey:@"Samples"];
        [SamplesDict setValue:SampleTypeDict forKey:@"SampleType"];//Dictionary
        [samplesArray addObject:SamplesDict];
    }
    [ProjectDetailsDict setValue:samplesArray forKey:@"Samples"];//Dict Array
    
    NSString *jsonString = [[CJSONSerializer serializer] serializeDictionary:ProjectDetailsDict];
}

@end
