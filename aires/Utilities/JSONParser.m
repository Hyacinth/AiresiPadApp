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

-(NSData *)JsonToPostProject:(Project *)proj
{
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *ProjectDetailsDict = [[NSMutableDictionary alloc] init];
    
    if(proj.projectID)
        [ProjectDetailsDict setValue:proj.projectID forKey:@"ProjectId"];
    //else
//        [ProjectDetailsDict setValue:@"" forKey:@"ProjectId"];
    
    if(proj.clientID)
        [ProjectDetailsDict setValue:proj.clientID forKey:@"ClientId"];
    //else
//        [ProjectDetailsDict setValue:@"" forKey:@"ClientId"];
    
    if(proj.contactID)
        [ProjectDetailsDict setValue:proj.contactID forKey:@"ContactId"];
    //else
//        [ProjectDetailsDict setValue:@"" forKey:@"ContactId"];
    
    if(proj.project_ProjectNumber)
        [ProjectDetailsDict setValue:proj.project_ProjectNumber forKey:@"ProjectNumber"];
    //else
//        [ProjectDetailsDict setValue:@"" forKey:@"ProjectNumber"];
    
    if(proj.project_ProjectDescription)
        [ProjectDetailsDict setValue:proj.project_ProjectDescription forKey:@"ProjectDescription"];
    //else
//        [ProjectDetailsDict setValue:@"" forKey:@"ProjectDescription"];
    
    if(proj.project_DateOnsite)
        [ProjectDetailsDict setValue:proj.project_DateOnsite forKey:@"DateOnsite"];
    //else
//        [ProjectDetailsDict setValue:@"" forKey:@"DateOnsite"];
    
    if(proj.project_LocationAddress)
        [ProjectDetailsDict setValue:proj.project_LocationAddress forKey:@"LocationAddress"];
    //else
//        [ProjectDetailsDict setValue:@"" forKey:@"LocationAddress"];
    
    if(proj.project_LocationAddress2)
        [ProjectDetailsDict setValue:proj.project_LocationAddress2 forKey:@"LocationAddress2"];
    //else
//        [ProjectDetailsDict setValue:@"" forKey:@"LocationAddress2"];
    
    if(proj.project_LocationCity)
        [ProjectDetailsDict setValue:proj.project_LocationCity forKey:@"LocationCity"];
    //else
//        [ProjectDetailsDict setValue:@"" forKey:@"LocationCity"];
    
    if(proj.project_LocationState)
        [ProjectDetailsDict setValue:proj.project_LocationState forKey:@"LocationState"];
    //else
//        [ProjectDetailsDict setValue:@"" forKey:@"LocationState"];
    
    if(proj.project_LocationPostalCode)
        [ProjectDetailsDict setValue:proj.project_LocationPostalCode forKey:@"LocationPostalCode"];
    //else
//        [ProjectDetailsDict setValue:@"" forKey:@"LocationPostalCode"];
    
    if(proj.consultantId)
        [ProjectDetailsDict setValue:proj.consultantId forKey:@"ConsultantId"];
    //else
//        [ProjectDetailsDict setValue:@"" forKey:@"ConsultantId"];
    
    if(proj.labID)
        [ProjectDetailsDict setValue:proj.labID forKey:@"LabId"];
    //else
//        [ProjectDetailsDict setValue:@"" forKey:@"LabId"];
    
    if(proj.project_QCPerson)
        [ProjectDetailsDict setValue:proj.project_QCPerson forKey:@"QCPerson"];
    //else
//        [ProjectDetailsDict setValue:@"" forKey:@"QCPerson"];
    
    if(proj.project_TurnAroundTimeId)
        [ProjectDetailsDict setValue:proj.project_TurnAroundTimeId forKey:@"TurnaroundTimeId"];
    //else
//        [ProjectDetailsDict setValue:@"" forKey:@"TurnaroundTimeId"];
   
//    [ProjectDetailsDict setValue:@"" forKey:@"UserProjects"];


    [ProjectDetailsDict setValue:@"TRUE" forKey:@"CompletedFlag"];
    
    if(proj.project_createdOn)
        [ProjectDetailsDict setValue:proj.project_createdOn forKey:@"CreatedOn"];
    //else
//        [ProjectDetailsDict setValue:@"" forKey:@"CreatedOn"];
    
    if(proj.project_CreatedBy)
        [ProjectDetailsDict setValue:proj.project_CreatedBy forKey:@"CreatedBy"];
    //else
//        [ProjectDetailsDict setValue:@"" forKey:@"CreatedBy"];
    
    
    NSMutableDictionary *ClientDict = [[NSMutableDictionary alloc] init];
    if(proj.clientID)
        [ClientDict setValue:proj.clientID forKey:@"ClientId"];
    //else
//        [ClientDict setValue:@"" forKey:@"ClientId"];
    if(proj.project_ClientName)
        [ClientDict setValue:proj.project_ClientName forKey:@"ClientName"];
    //else
//        [ClientDict setValue:@"" forKey:@"ClientName"];
    if(proj.airesClient.client_City)
        [ClientDict setValue:proj.airesClient.client_City forKey:@"ClientCity"];
    //else
//        [ClientDict setValue:@"" forKey:@"ClientCity"];
    if(proj.airesClient.client_State)
        [ClientDict setValue:proj.airesClient.client_State forKey:@"ClientState"];
    //else
//        [ClientDict setValue:@"" forKey:@"ClientState"];
    if(proj.airesClient.client_CreateOn)
        [ClientDict setValue:proj.airesClient.client_CreateOn forKey:@"CreatedOn"];
    //else
//        [ClientDict setValue:@"" forKey:@"CreatedOn"];
//    [ClientDict setValue:@"" forKey:@"Contacts"];
//    [ClientDict setValue:@"" forKey:@"Projects"];
    [ProjectDetailsDict setValue:ClientDict forKey:@"Client"];//Dictionary
    
    NSMutableDictionary *ContacttDict = [[NSMutableDictionary alloc] init];
    if(proj.airesContact.contactID)
        [ContacttDict setValue:proj.airesContact.contactID forKey:@"ContactId"];
    //else
//        [ContacttDict setValue:@"" forKey:@"ContactId"];
    
    if(proj.airesContact.contact_ClientId)
        [ContacttDict setValue:proj.airesContact.contact_ClientId forKey:@"ClientId"];
    //else
//        [ContacttDict setValue:@"" forKey:@"ClientId"];
    
    if(proj.airesContact.contact_Firstname)
        [ContacttDict setValue:proj.airesContact.contact_Firstname forKey:@"FirstName"];
    //else
//        [ContacttDict setValue:@"" forKey:@"FirstName"];
    
    if(proj.airesContact.contact_LastName)
        [ContacttDict setValue:proj.airesContact.contact_LastName forKey:@"LastName"];
    //else
//        [ContacttDict setValue:@"" forKey:@"LastName"];
    
    if(proj.airesContact.contact_PhoneNumber)
        [ContacttDict setValue:proj.airesContact.contact_PhoneNumber forKey:@"PhoneNumber"];
    //else
//        [ContacttDict setValue:@"" forKey:@"PhoneNumber"];
    
    if(proj.airesContact.contact_MobileNumber)
        [ContacttDict setValue:proj.airesContact.contact_MobileNumber forKey:@"MobileNumber"];
    //else
//        [ContacttDict setValue:@"" forKey:@"MobileNumber"];
    
    if(proj.airesContact.contact_Email)
        [ContacttDict setValue:proj.airesContact.contact_Email forKey:@"Email"];
    //else
//        [ContacttDict setValue:@"" forKey:@"Email"];
    
    if(proj.airesContact.contact_CreatedOn)
        [ContacttDict setValue:proj.airesContact.contact_CreatedOn forKey:@"CreatedOn"];
    //else
//        [ContacttDict setValue:@"" forKey:@"CreatedOn"];
    
    if(proj.airesContact.contact_Client)
        [ContacttDict setValue:proj.airesContact.contact_Client forKey:@"Client"];
    //else
//        [ContacttDict setValue:@"" forKey:@"Client"];
    
//    [ContacttDict setValue:@"" forKey:@"Projects"];
    [ProjectDetailsDict setValue:ContacttDict forKey:@"Contact"];//Dictionary
    
    NSMutableDictionary *LabDict = [[NSMutableDictionary alloc] init];
    if(proj.airesLab.labID)
        [LabDict setValue:proj.airesLab.labID forKey:@"LabId"];
    //else
//        [LabDict setValue:@"" forKey:@"LabId"];
    
    if(proj.airesLab.lab_LabName)
        [LabDict setValue:proj.airesLab.lab_LabName forKey:@"LabName"];
    //else
//        [LabDict setValue:@"" forKey:@"LabName"];
    
    if(proj.airesLab.lab_labEmail)
        [LabDict setValue:proj.airesLab.lab_labEmail forKey:@"LabEmail"];
    //else
//        [LabDict setValue:@"" forKey:@"LabEmail"];
    
    if(proj.airesLab.lab_CreatedOn)
        [LabDict setValue:proj.airesLab.lab_CreatedOn forKey:@"CreatedOn"];
    //else
//        [LabDict setValue:@"" forKey:@"CreatedOn"];
    
//    [LabDict setValue:@"" forKey:@"Projects"];
    [ProjectDetailsDict setValue:LabDict forKey:@"Lab"];//Dictionary
    
//    if(proj.project_TurnAroundTime)
//        [ProjectDetailsDict setValue:proj.project_TurnAroundTime forKey:@"TurnaroundTime"];
    //else
//        [ProjectDetailsDict setValue:@"" forKey:@"TurnaroundTime"];
    
//    [ProjectDetailsDict setValue:@"" forKey:@"User"];
    
    NSMutableArray *samplesArray = [[NSMutableArray alloc] init];
    NSArray *projSamples = [[mSingleton getPersistentStoreManager] getSampleforProject:proj];
    for (Sample *samp in projSamples)
    {
        NSMutableDictionary *SamplesDict = [[NSMutableDictionary alloc] init];
        if(samp.sampleID)
            [SamplesDict setValue:samp.sampleID forKey:@"SampleId"];
        //else
//            [SamplesDict setValue:@"" forKey:@"SampleId"];
        
        if(samp.projectId)
            [SamplesDict setValue:samp.projectId forKey:@"ProjectId"];
        //else
//            [SamplesDict setValue:@"" forKey:@"ProjectId"];
        
        if(samp.sample_SampleNumber)
            [SamplesDict setValue:samp.sample_SampleNumber forKey:@"SampleNumber"];
        //else
//            [SamplesDict setValue:@"" forKey:@"SampleNumber"];
        
        if(samp.sample_SampleId)
            [SamplesDict setValue:samp.sample_SampleId forKey:@"SampleTypeId"];
        //else
//            [SamplesDict setValue:@"" forKey:@"SampleTypeId"];
        
        if(samp.ppeID)
            [SamplesDict setValue:samp.ppeID forKey:@"PPEId"];
        //else
//            [SamplesDict setValue:@"" forKey:@"PPEId"];
        
        if(samp.sample_Comments)
            [SamplesDict setValue:samp.sample_Comments forKey:@"Comments"];
        //else
//            [SamplesDict setValue:@"" forKey:@"Comments"];
        
        if(samp.sample_Notes)
            [SamplesDict setValue:samp.sample_Notes forKey:@"Notes"];
        //else
//            [SamplesDict setValue:@"" forKey:@"Notes"];
        
        if(samp.deviceTypeId)
            [SamplesDict setValue:samp.deviceTypeId forKey:@"DeviceTypeId"];
        //else
//            [SamplesDict setValue:@"" forKey:@"DeviceTypeId"];
        
        if(samp.area)
            [SamplesDict setValue:samp.area forKey:@"Area"];
        //else
//            [SamplesDict setValue:@"" forKey:@"Area"];
        
        if(samp.minutes)
            [SamplesDict setValue:samp.minutes forKey:@"Minutes"];
        //else
//            [SamplesDict setValue:@"" forKey:@"Minutes"];
        
        if(samp.volume)
            [SamplesDict setValue:samp.volume forKey:@"Volume"];
        //else
//            [SamplesDict setValue:@"" forKey:@"Volume"];
        
        if(samp.sample_EmployeeName)
            [SamplesDict setValue:samp.sample_EmployeeName forKey:@"EmployeeName"];
        //else
//            [SamplesDict setValue:@"" forKey:@"EmployeeName"];
        
        if(samp.sample_EmployeeJob)
            [SamplesDict setValue:samp.sample_EmployeeJob forKey:@"EmployeeJob"];
        //else
//            [SamplesDict setValue:@"" forKey:@"EmployeeJob"];
        
        if(samp.sample_OperationArea)
            [SamplesDict setValue:samp.sample_OperationArea forKey:@"OperationArea"];
        //else
//            [SamplesDict setValue:@"" forKey:@"OperationArea"];
        
        if(samp.createdOn)
            [SamplesDict setValue:samp.createdOn forKey:@"CreatedOn"];
        //else
//            [SamplesDict setValue:@"" forKey:@"CreatedOn"];
        
        if(samp.deviceType)
            [SamplesDict setValue:samp.deviceType forKey:@"DeviceType"];
        //else
//            [SamplesDict setValue:@"" forKey:@"DeviceType"];
//        
//        [SamplesDict setValue:@"" forKey:@"Project"];
//        [SamplesDict setValue:@"" forKey:@"Results"];
        
        NSMutableArray *measurementArray = [[NSMutableArray alloc] init];
        NSArray *sampleMeasurement = [[mSingleton getPersistentStoreManager] getSampleMeasurementforSample:samp];
        for (SampleMeasurement *sampMeas in sampleMeasurement)
        {
            NSMutableDictionary *MeasurementDict = [[NSMutableDictionary alloc] init];
            if(sampMeas.sampleMesurementID)
                [MeasurementDict setValue:sampMeas.sampleMesurementID forKey:@"MeasurementId"];
            //else
//                [MeasurementDict setValue:@"" forKey:@"MeasurementId"];
            
            if(sampMeas.sampleMesurementID)
                [MeasurementDict setValue:sampMeas.sampleID forKey:@"SampleId"];
            //else
//                [MeasurementDict setValue:@"" forKey:@"MeasurementId"];
            
            if(sampMeas.sampleMesurementID)
                [MeasurementDict setValue:sampMeas.sampleMeasurement_OnTime forKey:@"OnTime"];
            //else
//                [MeasurementDict setValue:@"" forKey:@"MeasurementId"];
            
            if(sampMeas.sampleMesurementID)
                [MeasurementDict setValue:sampMeas.sampleMeasurement_OffTime forKey:@"OffTime"];
            //else
//                [MeasurementDict setValue:@"" forKey:@"OffTime"];
            
            if(sampMeas.sampleMeasurement_OnFlowRate)
                [MeasurementDict setValue:sampMeas.sampleMeasurement_OnFlowRate forKey:@"OnFlowRate"];
            //else
//                [MeasurementDict setValue:@"" forKey:@"OnFlowRate"];
            
            if(sampMeas.sampleMeasurement_OffFlowRate)
                [MeasurementDict setValue:sampMeas.sampleMeasurement_OffFlowRate forKey:@"OffFlowRate"];
            //else
//                [MeasurementDict setValue:@"" forKey:@"OffFlowRate"];
            
            if(sampMeas.sampleMeasurement_TotalArea)
                [MeasurementDict setValue:sampMeas.sampleMeasurement_TotalArea forKey:@"Area"];
            //else
//                [MeasurementDict setValue:@"" forKey:@"Area"];
            
            if(sampMeas.sampleMeasurement_TotalMinutes)
                [MeasurementDict setValue:sampMeas.sampleMeasurement_TotalMinutes forKey:@"Minutes"];
            //else
//                [MeasurementDict setValue:@"" forKey:@"Minutes"];
            
            if(sampMeas.sampleMeasurement_TotalVolume)
                [MeasurementDict setValue:sampMeas.sampleMeasurement_TotalVolume forKey:@"Volume"];
            //else
//                [MeasurementDict setValue:@"" forKey:@"Volume"];
            
            if(sampMeas.deleted)
                [MeasurementDict setValue:[sampMeas.deleted boolValue] ? @"TRUE" : @"FALSE" forKey:@"Deleted"];
            //else
//                [MeasurementDict setValue:@"FALSE" forKey:@"Deleted"];
            
//            [MeasurementDict setValue:@"" forKey:@"Sample"];
            [measurementArray addObject:MeasurementDict];
        }
        if([measurementArray count] > 0)
            [SamplesDict setValue:measurementArray forKey:@"Measurements"];//Dict Array
        //else
//            [SamplesDict setValue:@"" forKey:@"Measurements"];//Dict Array
        
        NSMutableArray *sampleChemicalArray = [[NSMutableArray alloc] init];
        NSArray *sampleChemicals = [[mSingleton getPersistentStoreManager] getSampleChemicalforSample:samp];
        for (SampleChemical *sampChe in sampleChemicals)
        {
            NSMutableDictionary *SampleChemicalDict = [[NSMutableDictionary alloc] init];
            if(sampChe.sampleChemicalID)
                [SampleChemicalDict setValue:sampChe.sampleChemicalID forKey:@"SampleChemicalId"];
            //else
//                [SampleChemicalDict setValue:@"" forKey:@"SampleChemicalId"];
            
            if(sampChe.sampleID)
                [SampleChemicalDict setValue:sampChe.sampleID forKey:@"SampleId"];
            //else
//                [SampleChemicalDict setValue:@"" forKey:@"SampleId"];
            
            if(sampChe.chemicalID)
                [SampleChemicalDict setValue:sampChe.chemicalID forKey:@"ChemicalId"];
            //else
//                [SampleChemicalDict setValue:@"" forKey:@"ChemicalId"];
            
            if(sampChe.sampleChemical_PELTWAFlag)
                [SampleChemicalDict setValue:[sampChe.sampleChemical_PELTWAFlag boolValue] ? @"TRUE" : @"FALSE" forKey:@"PELTWAFlag"];
            //else
//                [SampleChemicalDict setValue:@"FALSE" forKey:@"PELTWAFlag"];
            
            if(sampChe.sampleChemical_PELSTELFlag)
                [SampleChemicalDict setValue:[sampChe.sampleChemical_PELSTELFlag boolValue] ? @"TRUE" : @"FALSE" forKey:@"PELSTELFlag"];
            //else
//                [SampleChemicalDict setValue:@"FALSE" forKey:@"PELSTELFlag"];
            
            if(sampChe.sampleChemical_PELCFlag)
                [SampleChemicalDict setValue:[sampChe.sampleChemical_PELCFlag boolValue] ? @"TRUE" : @"FALSE" forKey:@"PELCFlag"];
            //else
//                [SampleChemicalDict setValue:@"FALSE" forKey:@"PELCFlag"];
            
            if(sampChe.sampleChemical_TLVTWAFlag)
                [SampleChemicalDict setValue:[sampChe.sampleChemical_TLVTWAFlag boolValue] ? @"TRUE" : @"FALSE" forKey:@"TLVTWAFlag"];
            //else
//                [SampleChemicalDict setValue:@"FALSE" forKey:@"TLVTWAFlag"];
            
            if(sampChe.sampleChemical_TLVSTELFlag)
                [SampleChemicalDict setValue:[sampChe.sampleChemical_TLVSTELFlag boolValue] ? @"TRUE" : @"FALSE" forKey:@"TLVSTELFlag"];
            //else
//                [SampleChemicalDict setValue:@"FALSE" forKey:@"TLVSTELFlag"];
            
            if(sampChe.sampleChemical_TLVCFlag)
                [SampleChemicalDict setValue:[sampChe.sampleChemical_TLVCFlag boolValue] ? @"TRUE" : @"FALSE" forKey:@"TLVCFlag"];
            //else
//                [SampleChemicalDict setValue:@"FALSE" forKey:@"TLVCFlag"];
            
            if(sampChe.deleted)
                [SampleChemicalDict setValue:[sampChe.deleted boolValue] ? @"TRUE" : @"FALSE" forKey:@"Deleted"];
            //else
//                [SampleChemicalDict setValue:@"FALSE" forKey:@"Deleted"];
            
//            if(sampChe.sampleChemical_Name)
//                [SampleChemicalDict setValue:sampChe.sampleChemical_Name forKey:@"Chemical"];
            //else
//                [SampleChemicalDict setValue:@"" forKey:@"Chemical"];
            
//            [SampleChemicalDict setValue:@"" forKey:@"Results"];
//            [SampleChemicalDict setValue:@"" forKey:@"Sample"];
            [sampleChemicalArray addObject:SampleChemicalDict];
        }
        if([sampleChemicalArray count] > 0)
            [SamplesDict setValue:sampleChemicalArray forKey:@"SampleChemicals"];//Dict Array
        //else
//            [SamplesDict setValue:@"" forKey:@"SampleChemicals"];//Dict Array
        
        NSMutableArray *samplePPEArray = [[NSMutableArray alloc] init];
        NSArray *samplePPE = [[mSingleton getPersistentStoreManager] getSampleProtectionEquipmentforSample:samp];
        for (SampleProtectionEquipment *sampPPE in samplePPE)
        {
            NSMutableDictionary *SamplePPEDict = [[NSMutableDictionary alloc] init];
            if(sampPPE.sampleProtectionEquipmentID)
                [SamplePPEDict setValue:sampPPE.sampleProtectionEquipmentID forKey:@"PPEId"];
            //else
//                [SamplePPEDict setValue:@"" forKey:@"PPEId"];
            
            if(sampPPE.sampleID)
                [SamplePPEDict setValue:sampPPE.sampleID forKey:@"SamplesId"];
            //else
//                [SamplePPEDict setValue:@"" forKey:@"SamplesId"];
            
            if(sampPPE.sampleProtectionEquipmentID)
                [SamplePPEDict setValue:sampPPE.sampleProtectionEquipmentID forKey:@"PPEId"];
            //else
//                [SamplePPEDict setValue:@"" forKey:@"PPEId"];
            
            if(sampPPE.deleted)
                [SamplePPEDict setValue:[sampPPE.deleted boolValue] ? @"TRUE" : @"FALSE" forKey:@"Deleted"];
            //else
//                [SamplePPEDict setValue:@"FALSE" forKey:@"Deleted"];
            
//            if(sampPPE.sampleProtectionEquipment_Name)
//                [SamplePPEDict setValue:sampPPE.sampleProtectionEquipment_Name forKey:@"PPE"];
            //else
//                [SamplePPEDict setValue:@"" forKey:@"PPE"];
            
            if(sampPPE.samplePPEId)
                [SamplePPEDict setValue:sampPPE.samplePPEId forKey:@"SamplePPEId"];
            //else
//                [SamplePPEDict setValue:@"" forKey:@"SamplePPEId"];
            
//            [SamplePPEDict setValue:@"" forKey:@"Sample"];
            [samplePPEArray addObject:SamplePPEDict];
        }
        if([samplePPEArray count] >0 )
            [SamplesDict setValue:samplePPEArray forKey:@"SamplePPEs"];//Dict Array
        //else
//            [SamplesDict setValue:@"" forKey:@"SamplePPEs"];//Dict Array
        
        SampleType *sampType = samp.airesSampleType;
        NSMutableDictionary *SampleTypeDict = [[NSMutableDictionary alloc] init];
        if(sampType.sampleTypeID)
            [SampleTypeDict setValue:sampType.sampleTypeID forKey:@"SampleTypeId"];
        //else
//            [SampleTypeDict setValue:@"" forKey:@"SampleTypeId"];
        
        if(sampType.sampleTypeName)
            [SampleTypeDict setValue:sampType.sampleTypeName forKey:@"SampleTypeName"];
        //else
//            [SampleTypeDict setValue:@"" forKey:@"SampleTypeName"];
        
//        [SampleTypeDict setValue:@"" forKey:@"Samples"];
        if(sampType.sampleTypeID)
            [SamplesDict setValue:SampleTypeDict forKey:@"SampleType"];//Dictionary
        [samplesArray addObject:SamplesDict];
    }
    if([samplesArray count] > 0)
        [ProjectDetailsDict setValue:samplesArray forKey:@"Samples"];//Dict Array
    //else
//        [ProjectDetailsDict setValue:@"" forKey:@"Samples"];//Dict Array
    
    [jsonDict setValue:ProjectDetailsDict forKey:@"ProjectDetails"];
    NSLog(@"%@",[[CJSONSerializer serializer] serializeDictionary:jsonDict]);
    NSData *jsonData = [[CJSONDataSerializer serializer] serializeDictionary:jsonDict];
    return jsonData;
}

-(NSData *)JsonToUnlockProject:(Project *)proj
{
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];
    if(proj.projectID)
        [jsonDict setValue:proj.projectID forKey:@"ProjectId"];
    else
        [jsonDict setValue:@"" forKey:@"ProjectId"];
    
    if(proj.clientID)
        [jsonDict setValue:proj.clientID forKey:@"ClientId"];
    else
        [jsonDict setValue:@"" forKey:@"ClientId"];
    
    if(proj.contactID)
        [jsonDict setValue:proj.contactID forKey:@"ContactId"];
    else
        [jsonDict setValue:@"" forKey:@"ContactId"];
    
    if(proj.project_ProjectNumber)
        [jsonDict setValue:proj.project_ProjectNumber forKey:@"ProjectNumber"];
    else
        [jsonDict setValue:@"" forKey:@"ProjectNumber"];
    
    if(proj.project_ProjectDescription)
        [jsonDict setValue:proj.project_ProjectDescription forKey:@"ProjectDescription"];
    else
        [jsonDict setValue:@"" forKey:@"ProjectDescription"];
    
    if(proj.project_DateOnsite)
        [jsonDict setValue:proj.project_DateOnsite forKey:@"DateOnsite"];
    else
        [jsonDict setValue:@"" forKey:@"DateOnsite"];
    
    if(proj.project_LocationAddress)
        [jsonDict setValue:proj.project_LocationAddress forKey:@"LocationAddress"];
    else
        [jsonDict setValue:@"" forKey:@"LocationAddress"];
    
    if(proj.project_LocationAddress2)
        [jsonDict setValue:proj.project_LocationAddress2 forKey:@"LocationAddress2"];
    else
        [jsonDict setValue:@"" forKey:@"LocationAddress2"];
    
    if(proj.project_LocationCity)
        [jsonDict setValue:proj.project_LocationCity forKey:@"LocationCity"];
    else
        [jsonDict setValue:@"" forKey:@"LocationCity"];
    
    if(proj.project_LocationState)
        [jsonDict setValue:proj.project_LocationState forKey:@"LocationState"];
    else
        [jsonDict setValue:@"" forKey:@"LocationState"];
    
    if(proj.project_LocationPostalCode)
        [jsonDict setValue:proj.project_LocationPostalCode forKey:@"LocationPostalCode"];
    else
        [jsonDict setValue:@"" forKey:@"LocationPostalCode"];
    
    if(proj.consultantId)
        [jsonDict setValue:proj.consultantId forKey:@"ConsultantId"];
    else
        [jsonDict setValue:@"" forKey:@"ConsultantId"];
    
    if(proj.labID)
        [jsonDict setValue:proj.labID forKey:@"LabId"];
    else
        [jsonDict setValue:@"" forKey:@"LabId"];
    
    if(proj.project_QCPerson)
        [jsonDict setValue:proj.project_QCPerson forKey:@"QCPerson"];
    else
        [jsonDict setValue:@"" forKey:@"QCPerson"];
    
    if(proj.project_TurnAroundTimeId)
        [jsonDict setValue:proj.project_TurnAroundTimeId forKey:@"TurnaroundTimeId"];
    else
        [jsonDict setValue:@"" forKey:@"TurnaroundTimeId"];
    
    [jsonDict setValue:@"FALSE" forKey:@"CompletedFlag"];
    
    if(proj.project_createdOn)
        [jsonDict setValue:proj.project_createdOn forKey:@"CreatedOn"];
    else
        [jsonDict setValue:@"" forKey:@"CreatedOn"];
    
    if(proj.project_CreatedBy)
        [jsonDict setValue:proj.project_CreatedBy forKey:@"CreatedBy"];
    else
        [jsonDict setValue:@"" forKey:@"CreatedBy"];
    
    NSLog(@"%@",[[CJSONSerializer serializer] serializeDictionary:jsonDict]);
    NSData *jsonString = [[CJSONDataSerializer serializer] serializeDictionary:jsonDict];
    return jsonString;
}

@end
