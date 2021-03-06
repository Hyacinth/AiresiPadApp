//
//  PersistentStoreManager.m
//  aires
//
//  Created by Gautham on 22/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "PersistentStoreManager.h"
#import "Constants.h"

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

-(void)removeAiresUser
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:[self mainContext]]];
    NSArray *results = [[self mainContext] executeFetchRequest:request error:nil];
    for (User *mUser in results)
        [[self mainContext] deleteObject:mUser];
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
                mProject.project_DateOnsite = [dict objectForKey:@"DateOnsite"];
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
                mProject.clientID = (NSNumber *)[dict objectForKey:@"ClientId"] ;
            if (![[dict valueForKey:@"LabId"] isKindOfClass:[NSNull class]])
                mProject.labID = (NSNumber *)[dict objectForKey:@"LabId"] ;
            if (![[dict valueForKey:@"QCPerson"] isKindOfClass:[NSNull class]])
                mProject.project_QCPerson = [dict objectForKey:@"QCPerson"];
            if (![[dict valueForKey:@"ContactId"] isKindOfClass:[NSNull class]])
                mProject.contactID = (NSNumber *)[dict objectForKey:@"ContactId"] ;
            if (![[dict valueForKey:@"CreatedBy"] isKindOfClass:[NSNull class]])
                mProject.project_CreatedBy = [dict objectForKey:@"CreatedBy"];
            if (![[dict valueForKey:@"CreatedOn"] isKindOfClass:[NSNull class]])
                mProject.project_createdOn = [dict objectForKey:@"CreatedOn"] ;
            if (![[dict valueForKey:@"TurnaroundTimeId"] isKindOfClass:[NSNull class]])
                mProject.project_TurnAroundTimeId = [dict objectForKey:@"TurnaroundTimeId"] ;
            if (![[dict valueForKey:@"ConsultantId"] isKindOfClass:[NSNull class]])
                mProject.consultantId = [dict objectForKey:@"ConsultantId"] ;
            
            mProject.userProjects = @"";
            
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


-(NSArray *)getCompletedUserProjects
{
    NSArray *projects = [self getUserProjects];
    NSMutableArray *FinalArray = [NSMutableArray arrayWithArray:projects];
    for (Project *mProject in projects)
    {
        if (mProject && ![mProject.project_CompletedFlag boolValue])
            [FinalArray removeObject:mProject];
    }
    return FinalArray;
}

-(NSArray *)getLiveUserProjects
{
    NSArray *projects = [self getUserProjects];
    NSMutableArray *FinalArray = [NSMutableArray arrayWithArray:projects];
    for (Project *mProject in projects)
    {
        if (mProject && [mProject.project_CompletedFlag boolValue])
            [FinalArray removeObject:mProject];
    }
    return FinalArray;
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
            mSample.totalVolume = [dict objectForKey:@"Volume"];
        if (![[dict valueForKey:@"Minutes"] isKindOfClass:[NSNull class]])
            mSample.totalMinutes = [dict objectForKey:@"Minutes"];
        if (![[dict valueForKey:@"Area"] isKindOfClass:[NSNull class]])
            mSample.totalArea = [dict objectForKey:@"Area"];
        if (![[dict valueForKey:@"DeviceTypeId"] isKindOfClass:[NSNull class]])
            mSample.deviceTypeId = [dict objectForKey:@"DeviceTypeId"];
        if (![[dict valueForKey:@"PPEId"] isKindOfClass:[NSNull class]])
            mSample.ppeID = [dict objectForKey:@"PPEId"];
        if (![[dict valueForKey:@"ProjectId"] isKindOfClass:[NSNull class]])
            mSample.projectId = [dict objectForKey:@"ProjectId"];
        if (![[dict valueForKey:@"SampleId"] isKindOfClass:[NSNull class]])
            mSample.sampleID = [dict objectForKey:@"SampleId"];
        
        
        [project addAiresSampleObject:mSample];
        [[self mainContext] save:nil];
        
        SampleType *mSampleType = [NSEntityDescription
                                   insertNewObjectForEntityForName:@"SampleType"
                                   inManagedObjectContext:[self mainContext]];
        
        if (![[dict valueForKey:@"SampleTypeId"] isKindOfClass:[NSNull class]])
            mSampleType.sampleTypeID = [dict objectForKey:@"SampleTypeId"];
        if (![[dict valueForKey:@"SampleType"] isKindOfClass:[NSNull class]])
            mSampleType.sampleTypeName = [dict objectForKey:@"SampleType"];
        
        DeviceType *mDeviceType = [NSEntityDescription
                                   insertNewObjectForEntityForName:@"DeviceType"
                                   inManagedObjectContext:[self mainContext]];
        
        if(![[dict objectForKey:@"DeviceTypeId"] isKindOfClass:[NSNull class]])
            mDeviceType.deviceTypeID = [dict objectForKey:@"DeviceTypeId"];
        if(![[dict objectForKey:@"DeviceTypeId"] isKindOfClass:[NSNull class]])
            mDeviceType.deviceType_DeviceTypeID = [dict objectForKey:@"DeviceTypeId"];
        if(![[dict objectForKey:@"DeviceType"] isKindOfClass:[NSNull class]])
            mDeviceType.deviceType_DeviceTypeName = [dict objectForKey:@"DeviceType"];
        
        mSample.airesSampleType = mSampleType;
        [[self mainContext] save:nil];
        
        NSArray *SampleChemicals = [dict objectForKey:@"SampleChemicals"];
        [self storeSampleChemicalDetails:SampleChemicals forSample:mSample];
        
        NSArray *Measurements = [dict objectForKey:@"Measurements"];
        [self storeSampleMeasurementDetails:Measurements forSample:mSample];
        
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

-(void)updateSample:(Sample *)sample inProject:(Project *)proj forField:(NSString *)field withValue:(id)value
{
    NSArray *samplesArray = [self getSampleforProject:proj];
    Sample *toUpdate;
    for (Sample *mSample in samplesArray)
    {
        if ([mSample.sampleID isEqualToNumber:sample.sampleID])
        {
            toUpdate = mSample;
            break;
        }
    }
    if ([field isEqualToString:FIELD_SAMPLE_DEVICETYPE])
    {
        DeviceType *mDeviceType = (DeviceType *)value;
        toUpdate.sample_DeviceTypeName = mDeviceType.deviceType_DeviceTypeName;
        toUpdate.deviceTypeId = mDeviceType.deviceTypeID;
    }
    else if ([field isEqualToString:FIELD_SAMPLE_NOTES])
    {
        toUpdate.sample_Notes = (NSString *)value;
    }
    else if ([field isEqualToString:FIELD_SAMPLE_EMPLOYEE_NAME])
    {
        toUpdate.sample_EmployeeName = (NSString *)value;
    }
    else if ([field isEqualToString:FIELD_SAMPLE_EMPLOYEE_JOB])
    {
        toUpdate.sample_EmployeeJob = (NSString *)value;
    }
    else if ([field isEqualToString:FIELD_SAMPLE_OPERATIONAL_AREA])
    {
        toUpdate.sample_OperationArea = (NSString *)value;
    }
    else if ([field isEqualToString:FIELD_SAMPLE_COMMENTS])
    {
        toUpdate.sample_Comments = (NSString *)value;
    }
    if ([field isEqualToString:FIELD_SAMPLE_SAMPLETYPE])
    {
        SampleType *mSampleType = (SampleType *)value;
        toUpdate.airesSampleType.sampleTypeName = mSampleType.sampleTypeName;
        toUpdate.airesSampleType.sampleTypeID = mSampleType.sampleTypeID;
    }
    [[self mainContext] save:nil];
}

#pragma mark -
#pragma mark SampleChemical DataModel methods
-(void)storeSampleChemicalDetails:(NSArray *)sampleChemical forSample:(Sample *)sample
{
    for (NSDictionary *dict in sampleChemical)
    {
        if (![self isDuplicateSampleChemical:dict forSample:sample])
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
            if (![[dict valueForKey:@"SampleChemicalId"] isKindOfClass:[NSNull class]])
                mSampleChemical.sampleChemicalID = [dict objectForKey:@"SampleChemicalId"];
            if (![[dict valueForKey:@"SampleId"] isKindOfClass:[NSNull class]])
                mSampleChemical.sampleID = [dict objectForKey:@"SampleId"];
            if (![[dict valueForKey:@"Deleted"] isKindOfClass:[NSNull class]])
                mSampleChemical.deleted = [dict objectForKey:@"Deleted"];
            if (![[dict valueForKey:@"ChemicalId"] isKindOfClass:[NSNull class]])
                mSampleChemical.chemicalID = [dict objectForKey:@"ChemicalId"];
            
            [sample addAiresSampleChemicalObject:mSampleChemical];
            [[self mainContext] save:nil];
        }
        else
        {
            if (![[dict valueForKey:@"SampleChemicalId"] isKindOfClass:[NSNull class]])
            {
                NSArray *sampleChemicalArray = [self getAllSampleChemicalforSample:sample];
                for (SampleChemical *chem in sampleChemicalArray)
                {
                    if ([chem.sampleChemicalID isEqualToNumber:[dict valueForKey:@"SampleChemicalId"]]) 
                        [self updateSampleChemical:chem inSample:sample forField:FIELD_SAMPLECHEMICAL_DELETE withValue:[NSNumber numberWithBool:FALSE]];
                }
            }
        }
    }
}

-(BOOL)isDuplicateSampleChemical:(NSDictionary *)dict forSample:(Sample *)sample
{
    NSArray *SCarray = [self getAllSampleChemicalforSample:sample];
    for (SampleChemical *sc in SCarray)
    {
        if (![[dict valueForKey:@"ChemicalId"] isKindOfClass:[NSNull class]])
            if([[dict objectForKey:@"ChemicalId"] isEqualToNumber:sc.chemicalID])
                return YES;
    }
    return NO;
}

//Give all sample chemical for corresponding sample including deleted field
-(NSArray *)getAllSampleChemicalforSample:(Sample *)sample
{
    if(!sample.sampleID)
        return nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"SampleChemical" inManagedObjectContext:[self mainContext]]];
    NSArray *results = [[self mainContext] executeFetchRequest:request error:nil];
    NSMutableArray *finalResult = [NSMutableArray arrayWithArray:results];
    for (SampleChemical *mSampleChemical in results) {
        if (![mSampleChemical.fromSample.sampleID isEqualToNumber:sample.sampleID]) {
            [finalResult removeObject:mSampleChemical];
        }
    }
    return finalResult;
}

-(NSArray *)getSampleChemicalforSample:(Sample *)sample
{
    if(!sample.sampleID)
        return nil;
    
    NSArray *results = [self getAllSampleChemicalforSample:sample];
    NSMutableArray *finalResult = [NSMutableArray arrayWithArray:results];
    for (SampleChemical *mSampleChemical in results) {
        if ([mSampleChemical.deleted boolValue]) {
            [finalResult removeObject:mSampleChemical];
        }
    }
    return finalResult;
}

-(void)updateSampleChemical:(SampleChemical *)sampleChemical inSample:(Sample *)sample forField:(NSString *)field withValue:(id)value
{
    NSArray *sampleChemicalArray = [self getAllSampleChemicalforSample:sample];
    SampleChemical *toUpdate = nil;
    for (SampleChemical *mSampleChemical in sampleChemicalArray)
    {
        if (!sampleChemical)
        {
            if ([field isEqualToString:FIELD_SAMPLECHEMICAL_DELETE])
            {
                mSampleChemical.deleted = (NSNumber *)value;
            }
            else if ([field isEqualToString:FIELD_SAMPLECHEMICAL_CFlag])
            {
                mSampleChemical.sampleChemical_PELCFlag = (NSNumber *)value;
                mSampleChemical.sampleChemical_TLVCFlag = (NSNumber *)value;
            }
            else if ([field isEqualToString:FIELD_SAMPLECHEMICAL_TWAFlag])
            {
                mSampleChemical.sampleChemical_PELTWAFlag = (NSNumber *)value;
                mSampleChemical.sampleChemical_TLVTWAFlag = (NSNumber *)value;
            }
            else if ([field isEqualToString:FIELD_SAMPLECHEMICAL_STELFlag])
            {
                mSampleChemical.sampleChemical_PELSTELFlag = (NSNumber *)value;
                mSampleChemical.sampleChemical_TLVSTELFlag = (NSNumber *)value;
            }
            [[self mainContext] save:nil];
            
        }
        else if ([mSampleChemical.sampleChemicalID isEqualToNumber:sampleChemical.sampleChemicalID])
        {
            toUpdate = mSampleChemical;
            break;
        }
    }
    if(toUpdate)
    {
        if ([field isEqualToString:FIELD_SAMPLECHEMICAL_DELETE])
        {
            toUpdate.deleted = (NSNumber *)value;
        }
        else if ([field isEqualToString:FIELD_SAMPLECHEMICAL_CFlag])
        {
            toUpdate.sampleChemical_PELCFlag = (NSNumber *)value;
            toUpdate.sampleChemical_TLVCFlag = (NSNumber *)value;
        }
        else if ([field isEqualToString:FIELD_SAMPLECHEMICAL_TWAFlag])
        {
            toUpdate.sampleChemical_PELTWAFlag = (NSNumber *)value;
            toUpdate.sampleChemical_TLVTWAFlag = (NSNumber *)value;
        }
        else if ([field isEqualToString:FIELD_SAMPLECHEMICAL_STELFlag])
        {
            toUpdate.sampleChemical_PELSTELFlag = (NSNumber *)value;
            toUpdate.sampleChemical_TLVSTELFlag = (NSNumber *)value;
        }
        [[self mainContext] save:nil];
    }
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
            mSampleMeasurement.sampleMeasurement_Area = [dict objectForKey:@"Area"];
        if (![[dict valueForKey:@"Minutes"] isKindOfClass:[NSNull class]])
            mSampleMeasurement.sampleMeasurement_Minutes = [dict objectForKey:@"Minutes"];
        if (![[dict valueForKey:@"Volume"] isKindOfClass:[NSNull class]])
            mSampleMeasurement.sampleMeasurement_Volume = [dict objectForKey:@"Volume"];
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

-(NSArray *)getAllSampleMeasurementforSample:(Sample *)sample
{
    if(!sample.sampleID)
        return nil;
    
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

-(NSArray *)getSampleMeasurementforSample:(Sample *)sample
{
    if(!sample.sampleID)
        return nil;
    
    NSArray *results = [self getAllSampleMeasurementforSample:sample];
    NSMutableArray *finalResult = [NSMutableArray arrayWithArray:results];
    for (SampleMeasurement *mSampleMeasurement in results) {
        if ([mSampleMeasurement.deleted boolValue]) {
            [finalResult removeObject:mSampleMeasurement];
        }
    }
    return finalResult;
}

-(void)updateSampleMeasurement:(SampleMeasurement *)sampleMeasurement inSample:(Sample *)sample forField:(NSString *)field withValue:(id)value
{
    NSArray *sampleMeasurementArray = [self getAllSampleMeasurementforSample:sample];
    SampleMeasurement *toUpdate;
    for (SampleMeasurement *mSampleMeasurement in sampleMeasurementArray)
    {
        if ([mSampleMeasurement.sampleMesurementID isEqualToNumber:sampleMeasurement.sampleMesurementID])
        {
            toUpdate = mSampleMeasurement;
            break;
        }
    }
    
    if ([field isEqualToString:FIELD_SAMPLEMEASUREMENT_DELETE])
    {
        toUpdate.deleted = (NSNumber *)value;
    }
    else if ([field isEqualToString:FIELD_SAMPLEMEASUREMENT_OffFlowRate])
    {
        toUpdate.sampleMeasurement_OffFlowRate = (NSNumber *)value;
    }
    else if ([field isEqualToString:FIELD_SAMPLEMEASUREMENT_OffTime])
    {
        toUpdate.sampleMeasurement_OffTime = (NSString *)value;
    }
    else if ([field isEqualToString:FIELD_SAMPLEMEASUREMENT_OnFlowRate])
    {
        toUpdate.sampleMeasurement_OnFlowRate = (NSNumber *)value;
    }
    else if ([field isEqualToString:FIELD_SAMPLEMEASUREMENT_OnTime])
    {
        toUpdate.sampleMeasurement_OnTime = (NSString *)value;
    }
    else if ([field isEqualToString:FIELD_SAMPLEMEASUREMENT_TotalArea])
    {
        toUpdate.sampleMeasurement_Area = (NSNumber *)value;
    }
    else if ([field isEqualToString:FIELD_SAMPLEMEASUREMENT_TotalMinutes])
    {
        toUpdate.sampleMeasurement_Minutes = (NSNumber *)value;
    }
    else if ([field isEqualToString:FIELD_SAMPLEMEASUREMENT_TotalVolume])
    {
        toUpdate.sampleMeasurement_Volume = (NSNumber *)value;
    }
}

#pragma mark -
#pragma mark SampleProtectionEquipment DataModel methods
-(void)storeSampleProtectionEquipmentDetails:(NSArray *)sampleProtectionEquipment forSample:(Sample *)sample
{
    for (NSDictionary *dict in sampleProtectionEquipment)
    {
        if (![self isDuplicateSampleProtectionEquipment:dict forSample:sample])
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
            if (![[dict valueForKey:@"SamplesId"] isKindOfClass:[NSNull class]])
                mSampleProtectionEquipment.sampleID = [dict valueForKey:@"SamplesId"];
            if (![[dict valueForKey:@"SamplePPEId"] isKindOfClass:[NSNull class]])
                mSampleProtectionEquipment.SamplePPEId = [dict valueForKey:@"SamplePPEId"];
            
            [sample addAiresSampleProtectionEquipmentObject:mSampleProtectionEquipment];
            [[self mainContext] save:nil];
        }
        else
        {
            if (![[dict valueForKey:@"SamplePPEId"] isKindOfClass:[NSNull class]])
            {
                NSArray *samplePPEArray = [self getAllSampleProtectionEquipmentforSample:sample];
                for (SampleProtectionEquipment *ppem in samplePPEArray)
                {
                    if ([ppem.samplePPEId isEqualToNumber:[dict valueForKey:@"SamplePPEId"]])
                        [self updateSampleProtectionEquipment:ppem inSample:sample forField:FIELD_SAMPLEPROTECTIONEQUIPMENT_DELETE withValue:[NSNumber numberWithBool:FALSE]];
                }
            }

        }
    }
}


-(BOOL)isDuplicateSampleProtectionEquipment:(NSDictionary *)dict forSample:(Sample *)sample
{
    NSArray *SPEarray = [self getAllSampleProtectionEquipmentforSample:sample];
    for (SampleProtectionEquipment *spe in SPEarray)
    {
        if (![[dict valueForKey:@"SamplePPEId"] isKindOfClass:[NSNull class]])
            if([[dict objectForKey:@"SamplePPEId"] isEqualToNumber:spe.samplePPEId])
                return YES;
    }
    return NO;
}

-(NSArray *)getAllSampleProtectionEquipmentforSample:(Sample *)sample
{
    if(!sample.sampleID)
        return nil;
    
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

-(NSArray *)getSampleProtectionEquipmentforSample:(Sample *)sample
{
    if(!sample.sampleID)
        return nil;
    
    NSArray *results = [self getAllSampleProtectionEquipmentforSample:sample];
    NSMutableArray *finalResult = [NSMutableArray arrayWithArray:results];
    for (SampleProtectionEquipment *mSampleProtectionEquipment in results) {
        if ([mSampleProtectionEquipment.deleted boolValue]) {
            [finalResult removeObject:mSampleProtectionEquipment];
        }
    }
    return finalResult;
}

-(void)updateSampleProtectionEquipment:(SampleProtectionEquipment *)sampleProtectionEquipment inSample:(Sample *)sample forField:(NSString *)field withValue:(id)value
{
    NSArray *sampleProtectionEquipmentArray = [self getAllSampleProtectionEquipmentforSample:sample];
    SampleProtectionEquipment *toUpdate;
    for (SampleProtectionEquipment *mSampleProtectionEquipment in sampleProtectionEquipmentArray)
    {
        if ([mSampleProtectionEquipment.samplePPEId isEqualToNumber:sampleProtectionEquipment.samplePPEId])
        {
            toUpdate = mSampleProtectionEquipment;
            break;
        }
    }
    
    if ([field isEqualToString:FIELD_SAMPLEPROTECTIONEQUIPMENT_NAME])
    {
        toUpdate.sampleProtectionEquipment_Name = (NSString *)value;
    }
    if ([field isEqualToString:FIELD_SAMPLEPROTECTIONEQUIPMENT_DELETE])
    {
        toUpdate.deleted = (NSNumber *)value;
    }
    if ([field isEqualToString:FIELD_SAMPLEPROTECTIONEQUIPMENT_ID])
    {
        toUpdate.sampleProtectionEquipmentID = (NSNumber *)value;
    }
    [[self mainContext] save:nil];
}

-(void)removeAllProjectDetails
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"SampleProtectionEquipment" inManagedObjectContext:[self mainContext]]];
    NSMutableArray *results = [NSMutableArray arrayWithArray:[[self mainContext] executeFetchRequest:request error:nil]];
    for (SampleProtectionEquipment *mSampleProtectionEquipment in results)
        [[self mainContext] deleteObject:mSampleProtectionEquipment];
    [results removeAllObjects];
    
    [request setEntity:[NSEntityDescription entityForName:@"SampleMeasurement" inManagedObjectContext:[self mainContext]]];
    results = [NSMutableArray arrayWithArray:[[self mainContext] executeFetchRequest:request error:nil]];
    for (SampleMeasurement *mSampleMeasurement in results)
        [[self mainContext] deleteObject:mSampleMeasurement];
    [results removeAllObjects];
    
    [request setEntity:[NSEntityDescription entityForName:@"SampleChemical" inManagedObjectContext:[self mainContext]]];
    results = [NSMutableArray arrayWithArray:[[self mainContext] executeFetchRequest:request error:nil]];
    for (SampleChemical *mSampleChemical in results)
        [[self mainContext] deleteObject:mSampleChemical];
    [results removeAllObjects];
    
    [request setEntity:[NSEntityDescription entityForName:@"DeviceType" inManagedObjectContext:[self mainContext]]];
    results = [NSMutableArray arrayWithArray:[[self mainContext] executeFetchRequest:request error:nil]];
    for (DeviceType *mDeviceType in results)
        [[self mainContext] deleteObject:mDeviceType];
    [results removeAllObjects];
    
    [request setEntity:[NSEntityDescription entityForName:@"SampleType" inManagedObjectContext:[self mainContext]]];
    results = [NSMutableArray arrayWithArray:[[self mainContext] executeFetchRequest:request error:nil]];
    for (SampleType *mSampleType in results)
        [[self mainContext] deleteObject:mSampleType];
    [results removeAllObjects];
    
    [request setEntity:[NSEntityDescription entityForName:@"Sample" inManagedObjectContext:[self mainContext]]];
    results = [NSMutableArray arrayWithArray:[[self mainContext] executeFetchRequest:request error:nil]];
    for (Sample *mSample in results)
        [[self mainContext] deleteObject:mSample];
    [results removeAllObjects];
    
    [request setEntity:[NSEntityDescription entityForName:@"Project" inManagedObjectContext:[self mainContext]]];
    results = [NSMutableArray arrayWithArray:[[self mainContext] executeFetchRequest:request error:nil]];
    for (Project *mProject in results)
        [[self mainContext] deleteObject:mProject];
    [results removeAllObjects];
    
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
        
        if (![[dict valueForKey:@"ChemicalName"] isKindOfClass:[NSNull class]])
            mSampleChemical.sampleChemical_Name = [dict objectForKey:@"ChemicalName"];
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
            mSampleChemical.chemicalID = [dict objectForKey:@"ChemicalId"];
        
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

-(void)saveSampleTypeList:(NSArray *)sampletypeArray
{
    for (NSDictionary *dict in sampletypeArray)
    {
        SampleType *mSampleType = [NSEntityDescription
                                   insertNewObjectForEntityForName:@"SampleType"
                                   inManagedObjectContext:[self mainContext]];
        
        if (![[dict valueForKey:@"SampleTypeName"] isKindOfClass:[NSNull class]])
            mSampleType.sampleTypeName = [dict valueForKey:@"SampleTypeName"];
        if (![[dict valueForKey:@"SampleTypeId"] isKindOfClass:[NSNull class]])
            mSampleType.sampleTypeID = [dict valueForKey:@"SampleTypeId"];
        
        mSampleType.contentType = @"ListData";
        [[self mainContext] save:nil];
    }
    
}

-(NSArray *)getSampleyTypeList
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"SampleType" inManagedObjectContext:[self mainContext]]];
    NSArray *results = [[self mainContext] executeFetchRequest:request error:nil];
    NSMutableArray *finalResult = [NSMutableArray arrayWithArray:results];
    for (SampleType *mSampleType in results) {
        if (![mSampleType.contentType isEqualToString:@"ListData"]) {
            [finalResult removeObject:mSampleType];
        }
    }
    return finalResult;
    
}


-(NSNumber *)generateIDforNewSample
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Sample" inManagedObjectContext:[self mainContext]]];
    NSArray *results = [[self mainContext] executeFetchRequest:request error:nil];
    NSInteger lowestNumber = 0;
    for (Sample *theSample in results)
    {
        if ([theSample.sampleID integerValue] < lowestNumber) {
            lowestNumber = [theSample.sampleID integerValue];
        }
    }
    return [NSNumber numberWithInt:lowestNumber-1];
}

-(NSNumber *)generateIDforNewSampleChemical
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"SampleChemical" inManagedObjectContext:[self mainContext]]];
    NSArray *results = [[self mainContext] executeFetchRequest:request error:nil];
    NSInteger lowestNumber = 0;
    for (SampleChemical *theSampleChe in results)
    {
        if ([theSampleChe.sampleChemicalID integerValue] < lowestNumber) {
            lowestNumber = [theSampleChe.sampleChemicalID integerValue];
        }
    }
    return [NSNumber numberWithInt:lowestNumber-1];
}

-(NSNumber *)generateIDforNewSampleMeasurement
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"SampleMeasurement" inManagedObjectContext:[self mainContext]]];
    NSArray *results = [[self mainContext] executeFetchRequest:request error:nil];
    NSInteger lowestNumber = 0;
    for (SampleMeasurement *theSampleMeasure in results)
    {
        if ([theSampleMeasure.sampleMesurementID integerValue] < lowestNumber) {
            lowestNumber = [theSampleMeasure.sampleMesurementID integerValue];
        }
    }
    return [NSNumber numberWithInt:lowestNumber-1];
}

-(NSNumber *)generateIDforNewSampleProtectionEquipment
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"SampleProtectionEquipment" inManagedObjectContext:[self mainContext]]];
    NSArray *results = [[self mainContext] executeFetchRequest:request error:nil];
    NSInteger lowestNumber = 0;
    for (SampleProtectionEquipment *theSampleEquip in results)
    {
        if ([theSampleEquip.sampleProtectionEquipmentID integerValue] < lowestNumber) {
            lowestNumber = [theSampleEquip.sampleProtectionEquipmentID integerValue];
        }
    }
    return [NSNumber numberWithInt:lowestNumber-1];
}


-(NSString *) generateNumberforNewSample
{
    NSString *letters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: 6];
    for (int i=0; i<6; i++)
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Sample" inManagedObjectContext:[self mainContext]]];
    NSArray *results = [[self mainContext] executeFetchRequest:request error:nil];
    
    for (Sample *mSample in results)
    {
        if([mSample.sample_SampleNumber isEqualToString:randomString])
        {
            randomString = [NSString stringWithString:[self generateNumberforNewSample]];
            break;
        }
    }
    
    return randomString;
}
@end