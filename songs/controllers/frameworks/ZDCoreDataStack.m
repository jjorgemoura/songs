//
//  ZDCoreDataStack.m
//  songs
//
//  Created by Jorge Moura on 11/07/14.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDCoreDataStack.h"


static NSString *const ZDCoreDataModelFileName = @"songs";


@interface ZDCoreDataStack ()

@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@property (nonatomic, strong) NSManagedObjectContext *mainQueueContext;
@property (nonatomic, strong) NSManagedObjectContext *privateQueueContext;

@end




@implementation ZDCoreDataStack

//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Singleton
//---------------------------------------------------------------------------------------
+ (instancetype)defaultStore {

    static ZDCoreDataStack *_defaultStore = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _defaultStore = [self new];
    });
    
    return _defaultStore;
}


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Singleton Access
//---------------------------------------------------------------------------------------
+ (NSManagedObjectContext *)mainQueueContext {

    return [[self defaultStore] mainQueueContext];
}

+ (NSManagedObjectContext *)privateQueueContext {

    return [[self defaultStore] privateQueueContext];
}

+ (NSManagedObjectID *)managedObjectIDFromString:(NSString *)managedObjectIDString {

    return [[[self defaultStore] persistentStoreCoordinator] managedObjectIDForURIRepresentation:[NSURL URLWithString:managedObjectIDString]];
}


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Constructor
//---------------------------------------------------------------------------------------
- (id)init {

    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSavePrivateQueueContext:)name:NSManagedObjectContextDidSaveNotification object:[self privateQueueContext]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSaveMainQueueContext:) name:NSManagedObjectContextDidSaveNotification object:[self mainQueueContext]];
    }
    return self;
}


- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Notifications
//---------------------------------------------------------------------------------------
- (void)contextDidSavePrivateQueueContext:(NSNotification *)notification {

    @synchronized(self) {
        [self.mainQueueContext performBlock:^{
            [self.mainQueueContext mergeChangesFromContextDidSaveNotification:notification];
        }];
    }
}

- (void)contextDidSaveMainQueueContext:(NSNotification *)notification {

    @synchronized(self) {
        [self.privateQueueContext performBlock:^{
            [self.privateQueueContext mergeChangesFromContextDidSaveNotification:notification];
        }];
    }
}


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Getters
//---------------------------------------------------------------------------------------
- (NSManagedObjectContext *)mainQueueContext {

    if (!_mainQueueContext) {
        _mainQueueContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainQueueContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    
    return _mainQueueContext;
}

- (NSManagedObjectContext *)privateQueueContext {

    if (!_privateQueueContext) {
        _privateQueueContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _privateQueueContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    
    return _privateQueueContext;
}


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
#pragma mark - Stack Setup
//---------------------------------------------------------------------------------------
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {

    if (!_persistentStoreCoordinator) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        NSError *error = nil;
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self persistentStoreURL] options:[self persistentStoreOptions] error:&error]) {
            NSLog(@"Error adding persistent store. %@, %@", error, error.userInfo);
        }
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectModel *)managedObjectModel {

    if (!_managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:ZDCoreDataModelFileName withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return _managedObjectModel;
}


- (NSURL *)persistentStoreURL {

    NSString *appName = [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
    appName = [appName stringByAppendingString:@".sqlite"];
    
    
    NSURL *appDocsDirURL = [[[UIApplication sharedApplication] delegate] performSelector:@selector(applicationDocumentsDirectory)];
    
    //return [[NSFileManager appLibraryDirectory] URLByAppendingPathComponent:appName];
    return [appDocsDirURL URLByAppendingPathComponent:appName];
}


- (NSDictionary *)persistentStoreOptions {

    return @{NSInferMappingModelAutomaticallyOption: @YES, NSMigratePersistentStoresAutomaticallyOption: @YES, NSSQLitePragmasOption: @{@"synchronous": @"OFF"}};
}

@end
