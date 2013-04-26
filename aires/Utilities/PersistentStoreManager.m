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
    
    mUser.user_CertificationId = [dict valueForKey:@"CertificationId"];
    mUser.user_FirstName = [dict valueForKey:@"FirstName"];
    mUser.user_Id = [dict valueForKey:@"UserId"];
    //mUser.user_Image = [dict valueForKey:@"FirstName"];
    //mUser.user_iOSDeviceId = [dict valueForKey:@"iOSDeviceId"];
    mUser.user_LastName = [dict valueForKey:@"LastName"];
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
    NSLog(@"Number of Projects :%d",[projects count]);
    
    for (NSDictionary *dict in projects)
    {
        if (![self isDuplicateProject:dict])
        {
            Project *mProject = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"Project"
                                 inManagedObjectContext:[self mainContext]];
            
            NSDictionary *client = [dict objectForKey:@"Client"];
            NSDictionary *contact = [dict objectForKey:@"Contacts"];
            NSDictionary *lab = [dict objectForKey:@"Lab"];

            mProject.project_ClientName = [client objectForKey:@"ClientName"];
            mProject.project_CompletedFlag = [dict objectForKey:@"CompletedFlag"];
            mProject.project_ContactFirstName = [contact objectForKey:@"FirstName"];
            mProject.project_ContactLastName = [contact objectForKey:@"LastName"];
            mProject.project_ContactPhoneNumber = [contact objectForKey:@"LastName"];
            mProject.project_DateOnsite = [contact objectForKey:@"PhoneNumber"];
            //mProject.project_LabEmail = [lab objectForKey:@"LabEmail"];
            mProject.project_LabName = [lab objectForKey:@"LabName"];
            mProject.project_LocationAddress = [dict objectForKey:@"LocationAddress"];
            //mProject.project_LocationAddress2 = [dict objectForKey:@"LocationAddress2"];
            mProject.project_LocationCity = [dict objectForKey:@"LocationCity"];
            mProject.project_LocationPostalCode = [dict objectForKey:@"LocationPostalCode"];
            mProject.project_LocationState = [dict objectForKey:@"LocationState"];
            mProject.project_ProjectDescription = [dict objectForKey:@"ProjectDescription"];
            mProject.project_ProjectNumber = [dict objectForKey:@"ProjectNumber"];
            //mProject.project_TurnAroundTime = [dict objectForKey:@"TurnaroundTime"];
            mProject.projectID = (NSNumber *)[dict objectForKey:@"ProjectId"] ;
            
            [[self getAiresUser] addAiresProjectObject:mProject];
            [[self mainContext] save:nil];
            
            NSArray *Samples = [dict objectForKey:@"Samples"];
            [self storeSampleDetails:Samples forProject:mProject];
            NSLog(@"sample count:%d",[[self getSampleforProject:mProject] count]);
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
    NSLog(@"Number of Sample :%d",[sample count]);
    
    for (NSDictionary *dict in sample)
    {
        Sample *mSample = [NSEntityDescription
                             insertNewObjectForEntityForName:@"Sample"
                             inManagedObjectContext:[self mainContext]];
        
        mSample.sample_Comments = [dict objectForKey:@"Comments"];
        //mSample.sample_DeviceTypeName = [dict objectForKey:@"DeviceType"];
        mSample.sample_EmployeeJob = [dict objectForKey:@"EmployeeJob"];
        mSample.sample_EmployeeName = [dict objectForKey:@"EmployeeName"];
        //mSample.sample_Notes = [dict objectForKey:@"Notes"];
        mSample.sample_OperationArea = [dict objectForKey:@"OperationArea"];
        mSample.sample_SampleId = [dict objectForKey:@"SampleId"];
        mSample.sample_SampleNumber = [dict objectForKey:@"SampleNumber"];
        mSample.sampleID = [dict objectForKey:@"SampleId"];
        
        [project addAiresSampleObject:mSample];
        [[self mainContext] save:nil];
        
        NSArray *SampleChemicals = [dict objectForKey:@"SampleChemicals"];
        [self storeSampleChemicalDetails:SampleChemicals forSample:mSample];
        NSLog(@"getSampleChemicalforSample count:%d",[[self getSampleChemicalforSample:mSample] count]);

        NSArray *Measurements = [dict objectForKey:@"Measurements"];
        [self storeSampleTotalMeasurementDetails:Measurements forSample:mSample];
        NSLog(@"getSampleTotalMeasurementforSample count:%d",[[self getSampleTotalMeasurementforSample:mSample] count]);

        [self storeSampleChemicalDetails:SampleChemicals forSample:mSample];
        NSLog(@"getSampleMeasurementforSample count:%d",[[self getSampleMeasurementforSample:mSample] count]);

    }
}

-(NSArray *)getSampleforProject:(Project *)project
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Sample" inManagedObjectContext:[self mainContext]]];
    NSArray *results = [[self mainContext] executeFetchRequest:request error:nil];
    NSMutableArray *finalResult = [NSMutableArray arrayWithArray:results];
    for (Sample *mSample in results) {
        if ([mSample.fromProject.project_ProjectNumber isEqualToString:project.project_ProjectNumber]) {
            [finalResult removeObject:mSample];
        }
    }
    return finalResult;
}

#pragma mark -
#pragma mark SampleChemical DataModel methods
-(void)storeSampleChemicalDetails:(NSArray *)sampleChemical forSample:(Sample *)sample
{
    NSLog(@"Number of SampleChemical :%d",[sampleChemical count]);
    for (NSDictionary *dict in sampleChemical)
    {
        SampleChemical *mSampleChemical = [NSEntityDescription
                           insertNewObjectForEntityForName:@"SampleChemical"
                           inManagedObjectContext:[self mainContext]];
        
//        mSampleChemical.sampleChemical_Name = [dict objectForKey:@"Chemical"];
//        mSampleChemical.sampleChemical_PELCFlag = [dict objectForKey:@"PELCFlag"];
//        mSampleChemical.sampleChemical_PELSTELFlag = [dict objectForKey:@"PELSTELFlag"];
//        mSampleChemical.sampleChemical_PELTWAFlag = [dict objectForKey:@"PELTWAFlag"];
//        mSampleChemical.sampleChemical_TLVCFlag = [dict objectForKey:@"TLVCFlag"];
//        mSampleChemical.sampleChemical_TLVSTELFlag = [dict objectForKey:@"TLVSTELFlag"];
//        mSampleChemical.sampleChemical_TLVTWAFlag = [dict objectForKey:@"TLVTWAFlag"];
        mSampleChemical.sampleChemicalID = [dict objectForKey:@"ChemicalId"];

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
        if ([mSampleChemical.fromSample.sample_SampleId isEqualToNumber:sample.sample_SampleId]) {
            [finalResult removeObject:mSampleChemical];
        }
    }
    return finalResult;
}

-(void)storeSampleTotalMeasurementDetails:(NSArray *)sampleTotalMeaseurement forSample:(Sample *)sample
{
    NSLog(@"Number of sampleTotalMeaseurement :%d",[sampleTotalMeaseurement count]);
    for (NSDictionary *dict in sampleTotalMeaseurement)
    {
        SampleTotalMeasurement *mSampleTotalMeasurement = [NSEntityDescription
                                           insertNewObjectForEntityForName:@"SampleTotalMeasurement"
                                           inManagedObjectContext:[self mainContext]];
        
        mSampleTotalMeasurement.sampleTotalMeasurement_TotalArea = [dict objectForKey:@"Area"];
        mSampleTotalMeasurement.sampleTotalMeasurement_TotalMinutes = [dict objectForKey:@"Minutes"];
        mSampleTotalMeasurement.sampleTotalMeasurement_TotalVolume = [dict objectForKey:@"Volume"];
        mSampleTotalMeasurement.sampleTotalMeasurementID = [dict objectForKey:@"MeasurementId"];

        //[sample addAiresSampleTotalMeasurementObject:mSampleTotalMeasurement];
        [[self mainContext] save:nil];
    }
}

-(NSArray *)getSampleTotalMeasurementforSample:(Sample *)sample
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"SampleTotalMeasurement" inManagedObjectContext:[self mainContext]]];
    NSArray *results = [[self mainContext] executeFetchRequest:request error:nil];
    NSMutableArray *finalResult = [NSMutableArray arrayWithArray:results];
    for (SampleTotalMeasurement *mSampleTotalMeasurement in results) {
        if ([mSampleTotalMeasurement.fromSample.sample_SampleId isEqualToNumber:sample.sample_SampleId]) {
            [finalResult removeObject:mSampleTotalMeasurement];
        }
    }
    return finalResult;
}

-(void)storeSampleMeasurementDetails:(NSArray *)sampleMeaseurement forSample:(Sample *)sample
{
    NSLog(@"Number of sampleMeaseurement :%d",[sampleMeaseurement count]);
    for (NSDictionary *dict in sampleMeaseurement)
    {
        SampleMeasurement *mSampleMeasurement = [NSEntityDescription
                                                           insertNewObjectForEntityForName:@"SampleMeasurement"
                                                           inManagedObjectContext:[self mainContext]];
        
        mSampleMeasurement.sampleMeasurement_OffFlowRate = [dict objectForKey:@"OffFlowRate"];
        mSampleMeasurement.sampleMeasurement_OffTime = [dict objectForKey:@"OffTime"];
        mSampleMeasurement.sampleMeasurement_OnFlowRate = [dict objectForKey:@"OnFlowRate"];
        mSampleMeasurement.sampleMeasurement_OnTime = [dict objectForKey:@"OnTime"];
        mSampleMeasurement.sampleMesurementID = [dict objectForKey:@"MeasurementId"];

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
        if ([mSampleMeasurement.fromSample.sample_SampleId isEqualToNumber:sample.sample_SampleId]) {
            [finalResult removeObject:mSampleMeasurement];
        }
    }
    return finalResult;
}

@end
