//
//  BzCloudManagedObjectContextManager.m
//  BzCalendar
//
//  Created by 小林 活水 on 12/01/31.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import "BzCloudManagedObjectContextManager.h"
#import <EventKit/EventKit.h>
#import "CalendarManager.h"
//#import "ManagedObjectCloner.h"

#import "BzCalendar-Swift.h"



static NSString* kFallbackPersistentStoreFilename = @"fallbackStore.sqlite"; //used when iCloud is not available
static NSString* kManagedObjectModelName_BzCloud = @"BzCloud";

@interface BzCloudManagedObjectContextManager()

//  1)  NSManagedObjectModelを生成
@property(nonatomic, strong) NSManagedObjectModel* managedObjectModel;

//  2)  NSPersistentStoreCoordinatorを1)で生成したNSManagedObjectModelを引数にして生成
@property(nonatomic, strong) NSPersistentStoreCoordinator* persistentStoreCoordinator;

//  3)  NSManagedObjectContextを生成、2)のNSPersistentStoreCoordinatorをセット
@property (nonatomic, strong) NSManagedObjectContext* parentMOC;   // NSPrivateQueueConcurrencyTypeで動かす

//  4)  PersistentStoreを2)のコーディネーターにセットする
@property (nonatomic, strong) NSPersistentStore*    iCloudStore;
//@property (nonatomic, strong) NSPersistentStore*    fallbackStore;
@property (nonatomic) BOOL    fallbackStoreIsReady;

//
@property (nonatomic, strong) NSMutableArray* observerList;

@property (nonatomic, strong) NSMutableSet* clientsSet;

@property (nonatomic, strong) NSURL*  ubiquityURL;
@property (nonatomic, strong) id      currentUbiquityToken;


@property (nonatomic) BOOL isReadyToUse;


@property (nonatomic, strong) NSURL* presentedItemURL;



- (id) initPrivate;

//- (NSManagedObjectModel*) managedObjectModel;
- (NSString *)applicationDocumentsDirectory;

//- (void)mergeiCloudChanges:(NSNotification*)note forContext:(NSManagedObjectContext*)moc;
- (void)mergeChangesFrom_iCloud:(NSNotification*) note;


- (NSURL*) iCloudURL;
- (NSURL*) iCloudThisDocumentURL;
- (NSURL*) iCloudCoreDataLogFilesURL;

@end

@implementation BzCloudManagedObjectContextManager

#pragma mark - Singleton

+ (void)createContextManager: (void (^)(NSObject<BzCloudMOCManagerProtocol>* parentContext, NSError *error))completionHandler {

    BzCloudManagedObjectContextManager* mgr = [[BzCloudManagedObjectContextManager alloc] initPrivate];
    
    NSString* storePath = [[mgr applicationDocumentsDirectory] stringByAppendingPathComponent: @"BzCloud.sqlite"];
    NSURL* storeURL = [NSURL fileURLWithPath:storePath];
    NSURL* cloudURL = [mgr iCloudURL];
    NSString* contentName = [cloudURL lastPathComponent];
    
    NSURL* cloudLogURL = [mgr iCloudCoreDataLogFilesURL];

    
    NSPersistentStoreDescription* description = [[NSPersistentStoreDescription alloc] initWithURL: storeURL];
    description.shouldAddStoreAsynchronously = YES;
    description.shouldMigrateStoreAutomatically = YES;
    description.shouldInferMappingModelAutomatically = YES;
    [description setOption:contentName forKey:NSPersistentStoreUbiquitousContentNameKey];
    [description setOption:cloudLogURL forKey:NSPersistentStoreUbiquitousContentURLKey];

    NSLog(@"options: %@", description.options);
    
    
    NSManagedObjectContext* moc = [[NSManagedObjectContext alloc]
                                   initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    mgr.parentMOC = moc;
    
    
    __block BzCloudManagedObjectContextManager* weakMgr = mgr;
    
    [mgr.persistentStoreCoordinator addPersistentStoreWithDescription:description completionHandler:^(NSPersistentStoreDescription* storeDescription , NSError * error) {
        
        if( error ) {
            completionHandler(nil, error);
            return;
        }
        weakMgr.isReadyToUse = TRUE;
        weakMgr.parentMOC = moc;
        
        
        
        [weakMgr.parentMOC setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];   // メモリ上に優先権
        //[moc setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
        
        [weakMgr.parentMOC setStalenessInterval:0.0]; // ToDo
        //[self.parentMOC reset]; // setStalenessInterval:0.0の代わりにresetでもいい
        
        //  4)  2)のNSPersistentStoreCoordinatorを3)のNSManagedObjectContextにセット
        [weakMgr.parentMOC setPersistentStoreCoordinator: weakMgr.persistentStoreCoordinator];
        
        NSLog(@"type: %@", description.type);
        
        completionHandler(weakMgr, nil);
    }];

    return;
    
}

- (id) initPrivate {
    self = [super init];
    if( self ) {
        _isReadyToUse = FALSE;
        
        self.ubiquityURL = nil;
        self.currentUbiquityToken = nil;
        self.presentedItemURL = nil;
        
        //　＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
        //　処理概要
        //　＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
        //  1)  NSManagedObjectModelを生成
        //  2)  NSPersistentStoreCoordinatorを1)で生成したNSManagedObjectModelを引数にして生成
        //  3)  NSManagedObjectContextを生成
        //  4)  2)のNSPersistentStoreCoordinatorを3)のNSManagedObjectContextにセット
        //  5)  PersistentStoreを2)のコーディネーターにセットする
        //　＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
        
        //  1)  NSManagedObjectModelを生成
        NSManagedObjectModel* tmpMOM = [self managedObjectModel];
        
        //  2)  NSPersistentStoreCoordinatorを1)で生成したNSManagedObjectModelを引数にして生成
        NSPersistentStoreCoordinator* tmpCoordinator = [[NSPersistentStoreCoordinator alloc]
                                                        initWithManagedObjectModel:tmpMOM];
        self.persistentStoreCoordinator = tmpCoordinator;
        
        //  3)  NSManagedObjectContextを生成
        // BzCloud.momdのコンテキスト
        NSManagedObjectContext* moc = [[NSManagedObjectContext alloc]
                                       initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        self.parentMOC = moc;
        [[NSNotificationCenter defaultCenter] addObserverForName:NSPersistentStoreCoordinatorStoresWillChangeNotification
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification* note) {
                                                          
                                                          [self.parentMOC performBlock:^{
                                                              if([self.parentMOC hasChanges]) {
                                                                  NSError* saveError;
                                                                  if(![self.parentMOC save:&saveError]){
                                                                      NSLog(@"Save error: %@", saveError);
                                                                  }
                                                              } else {
                                                                  // drop any managed object references
                                                                  [self.parentMOC reset];
                                                              }
                                                          }];
                                                          
                                                      }];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(iCloudAccountChanged:)
                                                     name:NSUbiquityIdentityDidChangeNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(mergeChangesFrom_iCloud:)
                                                    name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                                  object:self.persistentStoreCoordinator];
    }
    
    return self;
}
- (id) init {
    //return [self initSingleton];
    LOG_METHOD;
    LOG(@"Use sharedContextManager method to get a singleton instance");
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-init is not a valid initializer for the class Foo"
                                 userInfo:nil];
    SINGLTON_INIT_NOT_ALLOWED;

}


#pragma mark -
- (NSManagedObjectContext*) bzCloudContext {
    return _parentMOC;
}


- (void)dropStores {
    
    __block NSError *error = nil;
    
//    if (self.fallbackStore) {
//        [self.parentMOC performBlockAndWait:^{
//            if ([self.persistentStoreCoordinator removePersistentStore:self.fallbackStore
//                                                                 error:&error]) {
//                LOG(@"Removed fallback store");
//                self.fallbackStore = nil;
//            } else {
//                LOG(@"Error removing fallback store: %@", error);
//            }
//        }];
//    }
    if (self.iCloudStore) {
        [self.parentMOC performBlockAndWait:^{
            
            self.presentedItemURL = nil;
            if ([self.persistentStoreCoordinator removePersistentStore:self.iCloudStore
                                                                 error:&error]) {
                NSLog(@"Removed iCloud Store");
                self.iCloudStore = nil;
            } else {
                LOG(@"Error removing iCloud Store: %@", error);
            }
        }];
    }
     
}
- (void)iCloudAccountChanged:(NSNotification *)notification {
    //tell the UI to clean up while we re-add the store
    [self dropStores];
    
    // update the current ubiquity token
    
    id token = [[NSFileManager defaultManager] ubiquityIdentityToken];
    self.currentUbiquityToken = token;
    
    //reload persistent store
   // [self loadPersistentStores];
}

#pragma mark -
#pragma mark Application Lifecycle - Seeding
//- (void)addToCloud_FromFallbackStore:(NSURL *)seedStoreURL
//                                      error:(NSError**)error
//                            removeFromStore:(BOOL)removeFromStore
//                       completion:(void (^)(BOOL success))completionHandler
//{
//
//    BOOL success = YES;
//    NSError *localError = nil;
//
//    if( self.iCloudStore == nil ) {
//        completionHandler(FALSE);
//        return;
//    }
//
//    //NSManagedObjectContext* moc = self.parentMOC;
//    NSManagedObjectContext* moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
////    NSManagedObjectContext* moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//    [moc setPersistentStoreCoordinator:self.persistentStoreCoordinator];
//
//    //NSManagedObjectContext* moc = self.parentMOC;
//
//    NSManagedObjectModel *model = [self managedObjectModel]; // [NSManagedObjectModel mergedModelFromBundles:nil];
//    NSPersistentStoreCoordinator *seedPSC = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
//    NSDictionary *seedStoreOptions = @{ NSReadOnlyPersistentStoreOption : [NSNumber numberWithBool:YES] };
//
//    NSPersistentStore *seedStore = [seedPSC addPersistentStoreWithType:NSSQLiteStoreType
//                                                         configuration:nil
//                                                                   URL:seedStoreURL
//                                                               options:seedStoreOptions
//                                                                 error:&localError];
//
//
//    if (seedStore) {
//
//
//        NSManagedObjectContext *seedMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType ];
//        //NSManagedObjectContext *seedMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//        [seedMOC setPersistentStoreCoordinator:seedPSC];
//
//
//        NSArray* entityNames = [NSArray arrayWithObjects:
//                                @"CalendarExtension",
//                                @"CustomHolidayCalendar",
//                                @"CustomHolidayCalendarItem",
//                                @"EventExtension",
//                                @"EventTemplate",
//                                nil];
//
//
//        [ManagedObjectCloner addEntities:   entityNames
//                               fromContext: seedMOC
//                                 toContext: moc
//                      withDuplicationCheck: YES
//                                completion: ^(NSError* error) {
//
//                                    if( error ) {
//                                        completionHandler(FALSE);
//                                        return;
//                                    }
//
//                                    [moc performBlockAndWait:^{
//                                        NSError* contextError = nil;
//
//                                        [moc save:&contextError];
//
//                                        if( contextError ) {
//                                            [moc reset];
//                                        }
//
//                                        if( removeFromStore == YES ) {
//                                            NSError* removeErr = nil;
//                                            [[NSFileManager defaultManager] removeItemAtURL: seedStoreURL
//                                                                                      error: &removeErr];
//                                            if( removeErr ) {
//                                                LOG(@"removeError: %@", removeErr);
//                                            }
//                                        }
//                                        completionHandler(TRUE);
//                                        return;
//                                    }];
//                                }];
//
//
//    } else {
//        success = NO;
//        LOG(@"Error adding seed store: %@", localError);
//    }
//
//    if (NO == success) {
//        if (localError  && (error != NULL)) {
//            *error = localError;
//        }
//    }
//
//
//    completionHandler( success );
//}
//


- (BOOL)isRequiredMigration
{    
    NSURL* fileURL = [self iCloudURL];
    NSError* error = nil;
    
    // ToDo この方法はうまくいかないらしい
    NSDictionary* sourceMetaData =
    [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType
                                                               URL:fileURL
                                                           options:@{}
                                                             error:&error];
    
    if (sourceMetaData == nil) {
        return NO;
    } else if (error) {
        LOG(@"Checking migration was failed (%@, %@)", error, [error userInfo]);
    }
    
    
    BOOL isCompatible = [[self managedObjectModel] isConfiguration:nil
                                        compatibleWithStoreMetadata:sourceMetaData]; 
    
    return !isCompatible;
    
}
/*
- (NSManagedObjectContext*) context {
    LOG_METHOD;
    if( _isReadyToUse ) {
        return self._parentMOC;
    } else {
        return nil;
    }
}
 */


//- (void)mergeiCloudChanges:(NSNotification*)note
//                forContext:(NSManagedObjectContext*)moc {
//    LOG_METHOD;
//    [moc mergeChangesFromContextDidSaveNotification:note];
//    NSError* error = nil;
//    [moc save:&error];
//
//    // ToDo:
//    // CalendarManagerから通知しない
//    [[CalendarManager sharedManager] notifyCloudDataChanged];
//
//}

- (void)mergeChangesFrom_iCloud:(NSNotification*) note {
    LOG_METHOD;
    NSLog(@"notification: %@", note);

    [self.parentMOC performBlock:^{
        [self.parentMOC mergeChangesFromContextDidSaveNotification:note];
        NSError* error = nil;
        [self.parentMOC save:&error];
        
        // ToDo:
        // CalendarManagerから通知しない
        [[CalendarManager sharedManager] notifyCloudDataChanged];
    }];
}


- (void) _debug_remove_iCloud_data {
    NSURL* cloudURL = [self iCloudURL];
    
    NSFileCoordinator *coordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
    [coordinator
     coordinateWritingItemAtURL:cloudURL
     options:NSFileCoordinatorWritingForDeleting
     error:nil
     byAccessor:^(NSURL *newURL) {
         [[NSFileManager defaultManager]
          removeItemAtURL:newURL error:nil];
     }];
    
}

- (BOOL)save:(NSError **)error {
    // Commit the change.
    LOG_METHOD;
    BOOL rtnVal = YES;

    if( self.parentMOC == nil ) {
        return NO;
    }
    __block NSError* err = nil;
    [self.parentMOC performBlockAndWait:^{
        [self.parentMOC save:&err];

    }];
    if( err ) {
        (*error) = err;
        rtnVal = NO;
    }
    return rtnVal;
}


/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


- (void) dealloc {
	LOG_METHOD;
    if( self.observerList ) self.observerList = nil;
    if( self.parentMOC ) self.parentMOC = nil;
}

- (NSURL*) iCloudURL {
    NSURL* rtnVal = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    rtnVal = [fileManager URLForUbiquityContainerIdentifier:nil];
    // this needs to match the entitlements and provisioning profile
    //NSURL *cloudURL = [fileManager URLForUbiquityContainerIdentifier:@"<individual ID>."];

    LOG(@"iCloudURL: %@", rtnVal);
    
    return rtnVal;    
}
- (NSURL*) iCloudThisDocumentURL {

    return [[self iCloudURL] URLByAppendingPathComponent:@"BzCalendar"];
}
- (NSURL*) iCloudCoreDataLogFilesURL{
    return [[self iCloudURL] URLByAppendingPathComponent:@"Log"];
}

- (void)processPendingChanges {
    LOG_METHOD;
    /*
    for(id<BzCloudClientProtocol> observer in self.observerList) {
        [observer contextIsReady:self._parentMOC];
    }
     */


    [self save:nil];

}

- (BOOL) isReadyToUse {
    return _isReadyToUse;
}
@end


@interface BzCloudManagedObjectContextManager (Private)

- (NSPersistentStoreCoordinator*) persistentStoreCoordinator;

- (NSManagedObjectModel *)managedObjectModel;

@end

@implementation BzCloudManagedObjectContextManager (Private)

- (NSManagedObjectModel *)managedObjectModel {
    if( _managedObjectModel == nil ) {
        //NSString *path = [[NSBundle mainBundle] pathForResource:@"BzCloud" ofType:@"momd"];
        //NSURL *momURL = [NSURL fileURLWithPath:path];
        //_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];

        BzCloudManagedObjectModel* bzCloudModel = [[BzCloudManagedObjectModel alloc] init];
        _managedObjectModel = bzCloudModel.bzCloudObjectModel;
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator*) persistentStoreCoordinator {
    return _persistentStoreCoordinator;
}


@end

