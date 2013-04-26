//
//  PersistentStoreManager.m
//  aires
//
//  Created by Gautham on 22/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "PersistentStoreManager.h"

@interface PersistentStoreManager ()

- (NSString *) documentsDirectory;

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

-(User *)getAiresUser
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:[self mainContext]]];
    NSArray *results = [[self mainContext] executeFetchRequest:request error:nil];
    
    if([results count] > 0)
    {
        User *mUser = [results objectAtIndex:0];
        return mUser;
    }
    
    return nil;
}

-(void)storeProjectDetails:(NSArray *)projects
{
    NSLog(@"Number of Projects :%d",[projects count]);
    
    for (NSDictionary *dict in projects)
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
        //mProject.project_ProjectNumber = (NSNumber *)[dict objectForKey:@"ProjectNumber"];
        //mProject.project_TurnAroundTime = [dict objectForKey:@"TurnaroundTime"];
        mProject.projectID = (NSNumber *)[dict objectForKey:@"ProjectId"] ;
        [[self getAiresUser] addAiresProjectObject:mProject];
        [[self getAiresUser] addAiresProjectObject:mProject];
        
        [[self mainContext] save:nil];
        
        [self getAiresUser];
        
    }
    
    [self getUserProjects];
}

-(Project *)getUserProjects
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Project" inManagedObjectContext:[self mainContext]]];
    NSArray *results = [[self mainContext] executeFetchRequest:request error:nil];
    
    if([results count] > 0)
    {
        Project *mProject = [results objectAtIndex:0];
        return mProject;
    }
    
    return nil;
}

@end
