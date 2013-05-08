//
//  PersistentStoreManager.m
//  aires
//
//  Created by Gautham on 22/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "PersistentStoreManager.h"

@interface PersistentStoreManager (Private)

- (NSString *) documentsDirectory;

-(BOOL)isDuplicateProject:(NSDictionary *)dict;
-(BOOL)isduplicateUser:(NSDictionary *)dict;

@end


@implementation PersistentStoreManager
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;
@synthesize mainContext;
@synthesize modelName;

#pragma mark -
#pragma mark Filesystem hooks
- (NSString *) modelName
{
    return @"Model";
}

- (NSString *)pathToModel
{
    NSLog(@"modelName :%@",[self modelName]);
    NSString *path;
    path = [[NSBundle mainBundle] pathForResource:[self modelName] ofType:@"momd"];
    if (path == nil)
        path = [[NSBundle mainBundle] pathForResource:[self modelName] ofType:@"mom"];
    return path;
}

- (NSString *)storeFileName
{
    return [[self modelName] stringByAppendingPathExtension:@"sqlite"];
}

- (NSString *)pathToLocalStore
{
    NSString *storeName = [self storeFileName];
    return [[self documentsDirectory] stringByAppendingPathComponent:storeName];
}

- (NSString *)pathToDefaultStore
{
    return [[NSBundle mainBundle] pathForResource:[self storeFileName] ofType:nil];
}

#pragma mark -
#pragma mark Core Data boilerplate
- (NSManagedObjectContext *)mainContext
{
    if (mainContext == nil)
    {
        mainContext = [[NSManagedObjectContext alloc] init];
        
        //Undo Support
        NSUndoManager *anUndoManager = [[NSUndoManager alloc] init];
        [mainContext setUndoManager:anUndoManager];
        
        [mainContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
    }
    
    if (fixingCoreDataUpdate == TRUE)
    {
        [self resetCoreData];
        mainContext = [self mainContext];
    }
    return mainContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel == nil)
    {
        NSLog(@"pathToModel :%@",[self pathToModel]);
        managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSURL *storeURL = [NSURL fileURLWithPath:[self pathToModel]];
        managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:storeURL];
    }
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator == nil)
    {
        // Verify the DB exists in the Documents directory, and copy it from the app bundle if not
        NSURL *storeURL = [NSURL fileURLWithPath:[self pathToLocalStore]];
        
        NSPersistentStoreCoordinator *psc;
        psc = [[NSPersistentStoreCoordinator alloc]
               initWithManagedObjectModel:[self managedObjectModel]];
        
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES],
                                 NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES],
                                 NSInferMappingModelAutomaticallyOption,
                                 nil];
        
        NSError *error = nil;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:options
                                       error:&error])
        {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:NSUnderlyingErrorKey];
            
            NSException *exc = nil;
            NSString *reason = @"Could not create persistent store.";
            
            if ((([error code] == 134100) || ([error code] == 134130)) && (fixingCoreDataUpdate == FALSE))
            {
                fixingCoreDataUpdate = TRUE;
                return nil;
            } else {
                
                exc = [NSException exceptionWithName:NSInternalInconsistencyException
                                              reason:reason
                                            userInfo:userInfo];
                
                @throw exc;
            }
        }
        fixingCoreDataUpdate = FALSE;
        persistentStoreCoordinator = psc;
    }
    
    return persistentStoreCoordinator;
}

- (NSString *)documentsDirectory
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    if (![[NSFileManager defaultManager] fileExistsAtPath:docDir])
    {
        NSError *error = nil;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:docDir
                                       withIntermediateDirectories:YES
                                                        attributes:nil
                                                             error:&error])
        {
            NSString *errorMsg = @"Could not find or create a Documents directory.";
            NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:error forKey:NSUnderlyingErrorKey];
            NSException *directoryException = [NSException exceptionWithName:NSInternalInconsistencyException
                                                                      reason:errorMsg
                                                                    userInfo:errorInfo];
            
            @throw directoryException;
        }
    }
    return docDir;
}

- (void) resetCoreData
{
    // Release CoreData chain
    mainContext = nil;
    managedObjectModel = nil;
    persistentStoreCoordinator = nil;
    
    // Delete the sqlite file
    NSError *deleteError = nil;
    NSURL *storeURL = [NSURL fileURLWithPath:[self pathToLocalStore]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:storeURL.path])
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&deleteError];
    
    // create a new persistent store
    [self persistentStoreCoordinator];
}

#pragma mark -
#pragma mark User DataModel methods

-(void)storeAiresUser:(NSDictionary *)dict
{
    if ([self isduplicateUser:dict])
        return;
    
    User *mUser = [NSEntityDescription
                   insertNewObjectForEntityForName:@"User"
                   inManagedObjectContext:[self mainContext]];
    
    if (![[dict valueForKey:@"CertificationId"] isKindOfClass:[NSNull class]])
        mUser.user_CertificationId = [dict valueForKey:@"CertificationId"];
    if (![[dict valueForKey:@"FirstName"] isKindOfClass:[NSNull class]])
        mUser.user_FirstName = [dict valueForKey:@"FirstName"];
    if (![[dict valueForKey:@"UserId"] isKindOfClass:[NSNull class]])
        mUser.user_Id = [dict valueForKey:@"UserId"];
    if (![[dict valueForKey:@"iOSDeviceId"] isKindOfClass:[NSNull class]])
        mUser.user_iOSDeviceId = [dict valueForKey:@"iOSDeviceId"];
    if (![[dict valueForKey:@"LastName"] isKindOfClass:[NSNull class]])
        mUser.user_LastName = [dict valueForKey:@"LastName"];
    if (![[dict valueForKey:@"LoginName"] isKindOfClass:[NSNull class]])
        mUser.user_LoginName = [dict valueForKey:@"LoginName"];
    
    [[self mainContext] save:nil];
}

-(BOOL)isduplicateUser:(NSDictionary *)dict
{
    NSNumber *userID = [dict valueForKey:@"UserId"];
    User *mUser = [self getAiresUser];
    if (!userID || (mUser && [userID isEqualToNumber:mUser.user_Id]))
        return YES;
    return NO;
}

-(User *)getAiresUser
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:[self mainContext]]];
    NSArray *results = [[self mainContext] executeFetchRequest:request error:nil];
    
    if([results count] > 0)
    {
        User *mUser = (User *)[results objectAtIndex:0];
        return mUser;
    }
    
    return nil;
}

#pragma mark -
#pragma mark Project DataModel methods
-(void)storeProjectDetails:(NSArray *)projects
{
    for (NSDictionary *dict in projects)
    {
        if (![self isDuplicateProject:dict])
        {
            Project *mProject = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"Project"
                                 inManagedObjectContext:[self mainContext]];
            
            NSDictionary *client = [dict objectForKey:@"Client"];
            NSDictionary *contact = [dict objectForKey:@"Contact"];
            NSDictionary *lab = [dict objectForKey:@"Lab"];
            
            if (![[dict valueForKey:@"ClientName"] isKindOfClass:[NSNull class]])
                mProject.project_ClientName = [client objectForKey:@"ClientName"];
            if (![[dict valueForKey:@"CompletedFlag"] isKindOfClass:[NSNull class]])
                mProject.project_CompletedFlag = [dict objectForKey:@"CompletedFlag"];
            if (![[contact valueForKey:@"FirstName"] isKindOfClass:[NSNull class]])
                mProject.project_ContactFirstName = [contact objectForKey:@"FirstName"];
            if (![[contact valueForKey:@"LastName"] isKindOfClass:[NSNull class]])
                mProject.project_ContactLastName = [contact objectForKey:@"LastName"];
            if (![[contact valueForKey:@"PhoneNumber"] isKindOfClass:[NSNull class]])
                mProject.project_ContactPhoneNumber = [contact objectForKey:@"PhoneNumber"];
            if (![[contact valueForKey:@"Email"] isKindOfClass:[NSNull class]])
                mProject.project_ContactEmail = [contact objectForKey:@"Email"];
            if (![[dict valueForKey:@"DateOnsite"] isKindOfClass:[NSNull class]])
                mProject.project_DateOnsite = [contact objectForKey:@"DateOnsite"];
            if (![[lab valueForKey:@"LabEmail"] isKindOfClass:[NSNull class]])
                mProject.project_LabEmail = [lab objectForKey:@"LabEmail"];
            if (![[lab valueForKey:@"LabName"] isKindOfClass:[NSNull class]])
                mProject.project_LabName = [lab objectForKey:@"LabName"];
            if (![[dict valueForKey:@"LocationAddress"] isKindOfClass:[NSNull class]])
                mProject.project_LocationAddress = [dict objectForKey:@"LocationAddress"];
            if (![[dict valueForKey:@"LocationAddress2"] isKindOfClass:[NSNull class]])
                mProject.project_LocationAddress2 = [dict objectForKey:@"LocationAddress2"];
            if (![[dict valueForKey:@"LocationCity"] isKindOfClass:[NSNull class]])
                mProject.project_LocationCity = [dict objectForKey:@"LocationCity"];
            if (![[dict valueForKey:@"LocationPostalCode"] isKindOfClass:[NSNull class]])
                mProject.project_LocationPostalCode = [dict objectForKey:@"LocationPostalCode"];
            if (![[dict valueForKey:@"LocationState"] isKindOfClass:[NSNull class]])
                mProject.project_LocationState = [dict objectForKey:@"LocationState"];
            if (![[dict valueForKey:@"ProjectDescription"] isKindOfClass:[NSNull class]])
                mProject.project_ProjectDescription = [dict objectForKey:@"ProjectDescription"];
            if (![[dict valueForKey:@"ProjectNumber"] isKindOfClass:[NSNull class]])
                mProject.project_ProjectNumber = [dict objectForKey:@"ProjectNumber"];
            if (![[dict valueForKey:@"TurnaroundTime"] isKindOfClass:[NSNull class]])
                mProject.project_TurnAroundTime = [dict objectForKey:@"TurnaroundTime"];
            if (![[dict valueForKey:@"ProjectId"] isKindOfClass:[NSNull class]])
                mProject.projectID = (NSNumber *)[dict objectForKey:@"ProjectId"] ;
            if (![[dict valueForKey:@"ClientId"] isKindOfClass:[NSNull class]])
                mProject.projectID = (NSNumber *)[dict objectForKey:@"ClientId"] ;
            if (![[dict valueForKey:@"LabId"] isKindOfClass:[NSNull class]])
                mProject.projectID = (NSNumber *)[dict objectForKey:@"LabId"] ;
            if (![[dict valueForKey:@"QCPerson"] isKindOfClass:[NSNull class]])
                mProject.project_QCPerson = [dict objectForKey:@"QCPerson"];
            if (![[dict valueForKey:@"ContactId"] isKindOfClass:[NSNull class]])
                mProject.projectID = (NSNumber *)[dict objectForKey:@"ContactId"] ;
            if (![[dict valueForKey:@"CreatedBy"] isKindOfClass:[NSNull class]])
                mProject.project_CreatedBy = [dict objectForKey:@"CreatedBy"];
            if (![[dict valueForKey:@"CreatedOn"] isKindOfClass:[NSNull class]])
                mProject.project_createdOn = [dict objectForKey:@"CreatedOn"] ;

            [[self getAiresUser] addAiresProjectObject:mProject];
            [[self mainContext] save:nil];
            
            //Save Contact details
            Contact *mContact = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"Contact"
                                 inManagedObjectContext:[self mainContext]];
            
            if (![[contact valueForKey:@"FirstName"] isKindOfClass:[NSNull class]])
                mContact.contact_Firstname = [contact objectForKey:@"FirstName"];
            if (![[contact valueForKey:@"LastName"] isKindOfClass:[NSNull class]])
                mContact.contact_LastName = [contact objectForKey:@"LastName"];
            if (![[contact valueForKey:@"PhoneNumber"] isKindOfClass:[NSNull class]])
                mContact.contact_PhoneNumber = [contact objectForKey:@"PhoneNumber"];
            if (![[contact valueForKey:@"Email"] isKindOfClass:[NSNull class]])
                mContact.contact_Email = [contact objectForKey:@"Email"];
            if (![[contact valueForKey:@"CreatedOn"] isKindOfClass:[NSNull class]])
                mContact.contact_CreatedOn = [contact objectForKey:@"CreatedOn"];
            if (![[contact valueForKey:@"MobileNumber"] isKindOfClass:[NSNull class]])
                mContact.contact_MobileNumber = [contact objectForKey:@"MobileNumber"];
            if (![[contact valueForKey:@"ContactId"] isKindOfClass:[NSNull class]])
                mContact.contactID = [contact objectForKey:@"ContactId"];
            if (![[contact valueForKey:@"ClientId"] isKindOfClass:[NSNull class]])
                mContact.contact_ClientId = [contact objectForKey:@"ClientId"];
           
            mProject.airesContact = mContact;
            [[self mainContext] save:nil];

            //Save Client details
            Client *mClient = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"Client"
                                 inManagedObjectContext:[self mainContext]];
            
            if (![[client valueForKey:@"ClientCity"] isKindOfClass:[NSNull class]])
                mClient.client_City = [client objectForKey:@"ClientCity"];
            if (![[client valueForKey:@"ClientId"] isKindOfClass:[NSNull class]])
                mClient.clientID = [client objectForKey:@"ClientId"];
            if (![[client valueForKey:@"ClientName"] isKindOfClass:[NSNull class]])
                mClient.client_Name = [client objectForKey:@"ClientName"];
            if (![[client valueForKey:@"ClientState"] isKindOfClass:[NSNull class]])
                mClient.client_State = [client objectForKey:@"ClientState"];
            if (![[client valueForKey:@"CreatedOn"] isKindOfClass:[NSNull class]])
                mClient.client_CreateOn = [client objectForKey:@"CreatedOn"];
            
            mProject.airesClient = mClient;
            [[self mainContext] save:nil];

            //Save Lab details
            Lab *mLab = [NSEntityDescription
                               insertNewObjectForEntityForName:@"Lab"
                               inManagedObjectContext:[self mainContext]];
            
            if (![[lab valueForKey:@"LabEmail"] isKindOfClass:[NSNull class]])
                mLab.lab_labEmail = [lab objectForKey:@"LabEmail"];
            if (![[lab valueForKey:@"CreatedOn"] isKindOfClass:[NSNull class]])
                mLab.lab_CreatedOn = [lab objectForKey:@"CreatedOn"];
            if (![[lab valueForKey:@"LabId"] isKindOfClass:[NSNull class]])
                mLab.labID = (NSNumber *)[lab objectForKey:@"LabId"];
            if (![[lab valueForKey:@"LabName"] isKindOfClass:[NSNull class]])
                mLab.lab_LabName = [lab objectForKey:@"LabName"];

            mProject.airesLab = mLab;
            [[self mainContext] save:nil];

            NSArray *Samples = [dict objectForKey:@"Samples"];
            [self storeSampleDetails:Samples forProject:mProject];
        }
    }
}

-(BOOL)isDuplicateProject:(NSDictionary *)dict
{
    NSNumber *projectID = (NSNumber *)[dict valueForKey:@"ProjectId"];
    NSArray *projects = [self getUserProjects];
    for (Project *mProject in projects) {
        if (!projectID || (mProject && [mProject.projectID isEqualToNumber:projectID]))
            return YES ;
    }
    return NO;
}

-(NSArray *)getUserProjects
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Project" inManagedObjectContext:[self mainContext]]];
    NSArray *results = [[self mainContext] executeFetchRequest:request error:nil];
    
    return results;
}

#pragma mark -
#pragma mark Sample DataModel methods
-(void)storeSampleDetails:(NSArray *)sample forProject:(Project *)project
{
    for (NSDictionary *dict in sample)
    {
        Sample *mSample = [NSEntityDescription
                           insertNewObjectForEntityForName:@"Sample"
                           inManagedObjectContext:[self mainContext]];
        
        
        if (![[dict valueForKey:@"Comments"] isKindOfClass:[NSNull class]])
            mSample.sample_Comments = [dict objectForKey:@"Comments"];
        if (![[dict valueForKey:@"DeviceType"] isKindOfClass:[NSNull class]])
            mSample.sample_DeviceTypeName = [dict objectForKey:@"DeviceType"];
        if (![[dict valueForKey:@"EmployeeJob"] isKindOfClass:[NSNull class]])
            mSample.sample_EmployeeJob = [dict objectForKey:@"EmployeeJob"];
        if (![[dict valueForKey:@"EmployeeName"] isKindOfClass:[NSNull class]])
            mSample.sample_EmployeeName = [dict objectForKey:@"EmployeeName"];
        if (![[dict valueForKey:@"Notes"] isKindOfClass:[NSNull class]])
            mSample.sample_Notes = [dict objectForKey:@"Notes"];
        if (![[dict valueForKey:@"OperationArea"] isKindOfClass:[NSNull class]])
            mSample.sample_OperationArea = [dict objectForKey:@"OperationArea"];
        if (![[dict valueForKey:@"SampleId"] isKindOfClass:[NSNull class]])
            mSample.sample_SampleId = [dict objectForKey:@"SampleId"];
        if (![[dict valueForKey:@"SampleNumber"] isKindOfClass:[NSNull class]])
            mSample.sample_SampleNumber = [dict objectForKey:@"SampleNumber"];
        if (![[dict valueForKey:@"CreatedOn"] isKindOfClass:[NSNull class]])
            mSample.createdOn = [dict objectForKey:@"CreatedOn"];
        if (![[dict valueForKey:@"DeviceType"] isKindOfClass:[NSNull class]])
            mSample.deviceType = [dict objectForKey:@"DeviceType"];
        if (![[dict valueForKey:@"Volume"] isKindOfClass:[NSNull class]])
            mSample.volume = [dict objectForKey:@"Volume"];
        if (![[dict valueForKey:@"Minutes"] isKindOfClass:[NSNull class]])
            mSample.minutes = [dict objectForKey:@"Minutes"];
        if (![[dict valueForKey:@"Area"] isKindOfClass:[NSNull class]])
            mSample.area = [dict objectForKey:@"Area"];
        if (![[dict valueForKey:@"DeviceTypeId"] isKindOfClass:[NSNull class]])
            mSample.deviceTypeId = [dict objectForKey:@"DeviceTypeId"];
        if (![[dict valueForKey:@"PPEId"] isKindOfClass:[NSNull class]])
            mSample.ppeID = [dict objectForKey:@"PPEId"];
        if (![[dict valueForKey:@"ProjectId"] isKindOfClass:[NSNull class]])
            mSample.projectId = [dict objectForKey:@"SampleId"];

                
        [project addAiresSampleObject:mSample];
        [[self mainContext] save:nil];
        
        NSDictionary *sampleType = [dict objectForKey:@"SampleType"];
        
        SampleType *mSampleType = [NSEntityDescription
                                   insertNewObjectForEntityForName:@"SampleType"
                                   inManagedObjectContext:[self mainContext]];
        
        if (![[sampleType valueForKey:@"SampleTypeId"] isKindOfClass:[NSNull class]])
            mSampleType.sampleTypeID = [sampleType objectForKey:@"SampleTypeId"];
        if (![[sampleType valueForKey:@"SampleTypeName"] isKindOfClass:[NSNull class]])
            mSampleType.sampleTypeName = [sampleType objectForKey:@"SampleTypeName"];
        
        mSample.airesSampleType = mSampleType;
        [[self mainContext] save:nil];

        NSArray *SampleChemicals = [dict objectForKey:@"SampleChemicals"];
        [self storeSampleChemicalDetails:SampleChemicals forSample:mSample];
        
        NSArray *Measurements = [dict objectForKey:@"Measurements"];
        [self storeSampleMeasurementDetails:Measurements forSample:mSample];
        
        [self storeSampleChemicalDetails:SampleChemicals forSample:mSample];
        
        NSArray *PPE = [dict objectForKey:@"SamplePPEs"];
        [self storeSampleProtectionEquipmentDetails:PPE forSample:mSample];
    }
}

-(NSArray *)getSampleforProject:(Project *)project
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Sample" inManagedObjectContext:[self mainContext]]];
    NSArray *results = [[self mainContext] executeFetchRequest:request error:nil];
    NSMutableArray *finalResult = [NSMutableArray arrayWithArray:results];
    for (Sample *mSample in results) {
        if (![mSample.fromProject.project_ProjectNumber isEqualToString:project.project_ProjectNumber]) {
            [finalResult removeObject:mSample];
        }
    }
    return finalResult;
}

#pragma mark -
#pragma mark SampleChemical DataModel methods
-(void)storeSampleChemicalDetails:(NSArray *)sampleChemical forSample:(Sample *)sample
{
    for (NSDictionary *dict in sampleChemical)
    {
        SampleChemical *mSampleChemical = [NSEntityDescription
                                           insertNewObjectForEntityForName:@"SampleChemical"
                                           inManagedObjectContext:[self mainContext]];
        
        if (![[dict valueForKey:@"Chemical"] isKindOfClass:[NSNull class]])
            mSampleChemical.sampleChemical_Name = [dict objectForKey:@"Chemical"];
        if (![[dict valueForKey:@"PELCFlag"] isKindOfClass:[NSNull class]])
            mSampleChemical.sampleChemical_PELCFlag = [dict objectForKey:@"PELCFlag"];
        if (![[dict valueForKey:@"PELSTELFlag"] isKindOfClass:[NSNull class]])
            mSampleChemical.sampleChemical_PELSTELFlag = [dict objectForKey:@"PELSTELFlag"];
        if (![[dict valueForKey:@"PELTWAFlag"] isKindOfClass:[NSNull class]])
            mSampleChemical.sampleChemical_PELTWAFlag = [dict objectForKey:@"PELTWAFlag"];
        if (![[dict valueForKey:@"TLVCFlag"] isKindOfClass:[NSNull class]])
            mSampleChemical.sampleChemical_TLVCFlag = [dict objectForKey:@"TLVCFlag"];
        if (![[dict valueForKey:@"TLVSTELFlag"] isKindOfClass:[NSNull class]])
            mSampleChemical.sampleChemical_TLVSTELFlag = [dict objectForKey:@"TLVSTELFlag"];
        if (![[dict valueForKey:@"TLVTWAFlag"] isKindOfClass:[NSNull class]])
            mSampleChemical.sampleChemical_TLVTWAFlag = [dict objectForKey:@"TLVTWAFlag"];
        if (![[dict valueForKey:@"ChemicalId"] isKindOfClass:[NSNull class]])
            mSampleChemical.sampleChemicalID = [dict objectForKey:@"ChemicalId"];
        if (![[dict valueForKey:@"SampleId"] isKindOfClass:[NSNull class]])
            mSampleChemical.sampleID = [dict objectForKey:@"SampleId"];
        if (![[dict valueForKey:@"Deleted"] isKindOfClass:[NSNull class]])
            mSampleChemical.deleted = [dict objectForKey:@"Deleted"];

        [sample addAiresSampleChemicalObject:mSampleChemical];
        [[self mainContext] save:nil];
    }
}

-(NSArray *)getSampleChemicalforSample:(Sample *)sample
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"SampleChemical" inManagedObjectContext:[self mainContext]]];
    NSArray *results = [[self mainContext] executeFetchRequest:request error:nil];
    NSMutableArray *finalResult = [NSMutableArray arrayWithArray:results];
    for (SampleChemical *mSampleChemical in results) {
        if (![mSampleChemical.fromSample.sample_SampleId isEqualToNumber:sample.sample_SampleId]) {
            [finalResult removeObject:mSampleChemical];
        }
    }
    return finalResult;
}

#pragma mark -
#pragma mark SampleMeasurement DataModel methods
-(void)storeSampleMeasurementDetails:(NSArray *)sampleMeaseurement forSample:(Sample *)sample
{
    for (NSDictionary *dict in sampleMeaseurement)
    {
        SampleMeasurement *mSampleMeasurement = [NSEntityDescription
                                                 insertNewObjectForEntityForName:@"SampleMeasurement"
                                                 inManagedObjectContext:[self mainContext]];
        if (![[dict valueForKey:@"OffFlowRate"] isKindOfClass:[NSNull class]])
            mSampleMeasurement.sampleMeasurement_OffFlowRate = [dict objectForKey:@"OffFlowRate"];
        if (![[dict valueForKey:@"OffTime"] isKindOfClass:[NSNull class]])
            mSampleMeasurement.sampleMeasurement_OffTime = [dict objectForKey:@"OffTime"];
        if (![[dict valueForKey:@"OnFlowRate"] isKindOfClass:[NSNull class]])
            mSampleMeasurement.sampleMeasurement_OnFlowRate = [dict objectForKey:@"OnFlowRate"];
        if (![[dict valueForKey:@"OnTime"] isKindOfClass:[NSNull class]])
            mSampleMeasurement.sampleMeasurement_OnTime = [dict objectForKey:@"OnTime"];
        if (![[dict valueForKey:@"Area"] isKindOfClass:[NSNull class]])
            mSampleMeasurement.sampleMeasurement_TotalArea = [dict objectForKey:@"Area"];
        if (![[dict valueForKey:@"Minutes"] isKindOfClass:[NSNull class]])
            mSampleMeasurement.sampleMeasurement_TotalMinutes = [dict objectForKey:@"Minutes"];
        if (![[dict valueForKey:@"Volume"] isKindOfClass:[NSNull class]])
            mSampleMeasurement.sampleMeasurement_TotalVolume = [dict objectForKey:@"Volume"];
        if (![[dict valueForKey:@"MeasurementId"] isKindOfClass:[NSNull class]])
            mSampleMeasurement.sampleMesurementID = [dict objectForKey:@"MeasurementId"];
        if (![[dict valueForKey:@"SampleId"] isKindOfClass:[NSNull class]])
            mSampleMeasurement.sampleID = [dict objectForKey:@"SampleId"];
        if (![[dict valueForKey:@"Deleted"] isKindOfClass:[NSNull class]])
            mSampleMeasurement.deleted = [dict objectForKey:@"Deleted"];

        [sample addAiresSampleMeasurementObject:mSampleMeasurement];
        [[self mainContext] save:nil];
    }
    
}

-(NSArray *)getSampleMeasurementforSample:(Sample *)sample
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"SampleMeasurement" inManagedObjectContext:[self mainContext]]];
    NSArray *results = [[self mainContext] executeFetchRequest:request error:nil];
    NSMutableArray *finalResult = [NSMutableArray arrayWithArray:results];
    for (SampleMeasurement *mSampleMeasurement in results) {
        if (![mSampleMeasurement.fromSample.sample_SampleId isEqualToNumber:sample.sample_SampleId]) {
            [finalResult removeObject:mSampleMeasurement];
        }
    }
    return finalResult;
}

#pragma mark -
#pragma mark SampleProtectionEquipment DataModel methods
-(void)storeSampleProtectionEquipmentDetails:(NSArray *)sampleProtectionEquipment forSample:(Sample *)sample
{
    for (NSDictionary *dict in sampleProtectionEquipment)
    {
        SampleProtectionEquipment *mSampleProtectionEquipment = [NSEntityDescription
                                                                 insertNewObjectForEntityForName:@"SampleProtectionEquipment"
                                                                 inManagedObjectContext:[self mainContext]];
        
        if (![[dict valueForKey:@"PPE"] isKindOfClass:[NSNull class]])
            mSampleProtectionEquipment.sampleProtectionEquipment_Name = [dict valueForKey:@"PPE"];
        if (![[dict valueForKey:@"PPEId"] isKindOfClass:[NSNull class]])
            mSampleProtectionEquipment.sampleProtectionEquipmentID = [dict valueForKey:@"PPEId"];
        if (![[dict valueForKey:@"Deleted"] isKindOfClass:[NSNull class]])
            mSampleProtectionEquipment.deleted = [dict objectForKey:@"Deleted"];
        if (![[dict valueForKey:@"SampleId"] isKindOfClass:[NSNull class]])
            mSampleProtectionEquipment.sampleID = [dict valueForKey:@"SampleId"];

        [sample addAiresSampleProtectionEquipmentObject:mSampleProtectionEquipment];
        [[self mainContext] save:nil];
    }
}

-(NSArray *)getSampleProtectionEquipmentforSample:(Sample *)sample
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"SampleProtectionEquipment" inManagedObjectContext:[self mainContext]]];
    NSArray *results = [[self mainContext] executeFetchRequest:request error:nil];
    NSMutableArray *finalResult = [NSMutableArray arrayWithArray:results];
    for (SampleProtectionEquipment *mSampleProtectionEquipment in results) {
        if (![mSampleProtectionEquipment.fromSample.sample_SampleId isEqualToNumber:sample.sample_SampleId]) {
            [finalResult removeObject:mSampleProtectionEquipment];
        }
    }
    return finalResult;
}

#pragma mark -
#pragma mark List DataModel methods
-(void)saveChemicalList:(NSArray *)chemicalArray
{
    for (NSDictionary *dict in chemicalArray)
    {
        SampleChemical *mSampleChemical = [NSEntityDescription
                                           insertNewObjectForEntityForName:@"SampleChemical"
                                           inManagedObjectContext:[self mainContext]];
        
        if (![[dict valueForKey:@"Chemical"] isKindOfClass:[NSNull class]])
            mSampleChemical.sampleChemical_Name = [dict objectForKey:@"Chemical"];
        if (![[dict valueForKey:@"PELCFlag"] isKindOfClass:[NSNull class]])
            mSampleChemical.sampleChemical_PELCFlag = [dict objectForKey:@"PELCFlag"];
        if (![[dict valueForKey:@"PELSTELFlag"] isKindOfClass:[NSNull class]])
            mSampleChemical.sampleChemical_PELSTELFlag = [dict objectForKey:@"PELSTELFlag"];
        if (![[dict valueForKey:@"PELTWAFlag"] isKindOfClass:[NSNull class]])
            mSampleChemical.sampleChemical_PELTWAFlag = [dict objectForKey:@"PELTWAFlag"];
        if (![[dict valueForKey:@"TLVCFlag"] isKindOfClass:[NSNull class]])
            mSampleChemical.sampleChemical_TLVCFlag = [dict objectForKey:@"TLVCFlag"];
        if (![[dict valueForKey:@"TLVSTELFlag"] isKindOfClass:[NSNull class]])
            mSampleChemical.sampleChemical_TLVSTELFlag = [dict objectForKey:@"TLVSTELFlag"];
        if (![[dict valueForKey:@"TLVTWAFlag"] isKindOfClass:[NSNull class]])
            mSampleChemical.sampleChemical_TLVTWAFlag = [dict objectForKey:@"TLVTWAFlag"];
        if (![[dict valueForKey:@"ChemicalId"] isKindOfClass:[NSNull class]])
            mSampleChemical.sampleChemicalID = [dict objectForKey:@"ChemicalId"];
        
        mSampleChemical.contentType = @"ListData";
        [[self mainContext] save:nil];
    }
    
}

-(NSArray *)getChemicalList
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"SampleChemical" inManagedObjectContext:[self mainContext]]];
    NSArray *results = [[self mainContext] executeFetchRequest:request error:nil];
    NSMutableArray *finalResult = [NSMutableArray arrayWithArray:results];
    for (SampleChemical *mSampleChemical in results) {
        if (![mSampleChemical.contentType isEqualToString:@"ListData"]) {
            [finalResult removeObject:mSampleChemical];
        }
    }
    return finalResult;
}

-(void)saveDeviceTypeList:(NSArray *)deviceArray
{
    for (NSDictionary *dict in deviceArray)
    {
        DeviceType *mDeviceType = [NSEntityDescription
                                   insertNewObjectForEntityForName:@"DeviceType"
                                   inManagedObjectContext:[self mainContext]];
        
        if (![[dict valueForKey:@"TypeName"] isKindOfClass:[NSNull class]])
            mDeviceType.deviceType_DeviceTypeName = [dict valueForKey:@"TypeName"];
        if (![[dict valueForKey:@"DeviceTypeId"] isKindOfClass:[NSNull class]])
            mDeviceType.deviceType_DeviceTypeID = [dict valueForKey:@"DeviceTypeId"];
        if (![[dict valueForKey:@"DeviceTypeId"] isKindOfClass:[NSNull class]])
            mDeviceType.deviceTypeID = [dict valueForKey:@"DeviceTypeId"];
        
        mDeviceType.contentType = @"ListData";
        [[self mainContext] save:nil];
    }
    
}

-(NSArray *)getDeviceTypeList
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"DeviceType" inManagedObjectContext:[self mainContext]]];
    NSArray *results = [[self mainContext] executeFetchRequest:request error:nil];
    NSMutableArray *finalResult = [NSMutableArray arrayWithArray:results];
    for (DeviceType *mDeviceType in results) {
        if (![mDeviceType.contentType isEqualToString:@"ListData"]) {
            [finalResult removeObject:mDeviceType];
        }
    }
    return finalResult;
    
}

-(void)saveProtectionEquipmentList:(NSArray *)equipmentArray
{
    for (NSDictionary *dict in equipmentArray)
    {
        SampleProtectionEquipment *mSampleProtectionEquipment = [NSEntityDescription
                                                                 insertNewObjectForEntityForName:@"SampleProtectionEquipment"
                                                                 inManagedObjectContext:[self mainContext]];
        
        if (![[dict valueForKey:@"ProtectionEquipmentName"] isKindOfClass:[NSNull class]])
            mSampleProtectionEquipment.sampleProtectionEquipment_Name = [dict valueForKey:@"ProtectionEquipmentName"];
        if (![[dict valueForKey:@"PPEId"] isKindOfClass:[NSNull class]])
            mSampleProtectionEquipment.sampleProtectionEquipmentID = [dict valueForKey:@"PPEId"];
        
        mSampleProtectionEquipment.contentType = @"ListData";
        [[self mainContext] save:nil];
    }
    
}
-(NSArray *)getProtectionEquipmentList
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"SampleProtectionEquipment" inManagedObjectContext:[self mainContext]]];
    NSArray *results = [[self mainContext] executeFetchRequest:request error:nil];
    NSMutableArray *finalResult = [NSMutableArray arrayWithArray:results];
    for (SampleProtectionEquipment *mSampleProtectionEquipment in results) {
        if (![mSampleProtectionEquipment.contentType isEqualToString:@"ListData"]) {
            [finalResult removeObject:mSampleProtectionEquipment];
        }
    }
    return finalResult;
}

@end
