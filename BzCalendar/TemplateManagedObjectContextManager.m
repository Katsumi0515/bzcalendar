//
//  TemplateManagedObjectContextManager.m
//  GSystemInitData
//
//  Created by 小林 活水 on 11/03/01.
//  Copyright 2011 Yamaha Employee. All rights reserved.
//

#import "TemplateManagedObjectContextManager.h"

@interface TemplateManagedObjectContextManager()
- (NSManagedObjectModel *) managedObjectModel;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;

@end


@implementation TemplateManagedObjectContextManager
static  TemplateManagedObjectContextManager* singletonManager = nil;

+ (TemplateManagedObjectContextManager*) sharedContextManager {
	if(singletonManager != nil) {
		return singletonManager;
	}
	singletonManager = [[TemplateManagedObjectContextManager alloc] init];
	return singletonManager;
}

- (id) init {
    self = [super init];
	if(self != nil) {
        managedObjectContext = [self sharedContext];
	}
	
	return self;
}
- (BOOL)save:(NSError **)error {
	// Commit the change.
	return [managedObjectContext save:error];
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) sharedContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        // BzCalendar.momdのコンテキスト
        managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BzCalendar" ofType:@"momd"];
    NSURL *momURL = [NSURL fileURLWithPath:path];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
        
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
	
	NSError* error = nil;
	
		
	//NSString *templateStorePath = [[NSBundle bundleForClass:[self class]] 
	//							   pathForResource:@"TemplateData" 
	//							   ofType:@"sqlite"];
	
    NSString* templateStorePath = [[NSBundle bundleForClass:[self class]] 
                        pathForResource:@"BzCalendar" 
                        ofType:@"sqlite"];

	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ( ![fileManager fileExistsAtPath:templateStorePath] ) {
		LOG(@"template does not exist");
	} else {
		LOG(@"template DOES exist");
	}
	
    NSURL *storeURL = [NSURL fileURLWithPath:templateStorePath];

	persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES],NSReadOnlyPersistentStoreOption,nil];
	
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] 
                                  initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType 
                                                  configuration:nil 
                                                            URL:storeURL 
                                                        options:options
                                                          error:&error]) {
		
        NSString* errorAt = [NSString stringWithFormat:@"%s", __func__];
        [[SystemErrorManager sharedManager] error:error
                                               at:errorAt
                                        callStack:[NSThread callStackSymbols]
                                   alertWithTitle:NSLocalizedString(@"AlertTitle_SystemError", @"システムエラー")
                                          message:NSLocalizedString(@"AlertMessage_SuggestReportingToDevelopper", @"エラー発生情報のサポートへの自動送付にご協力お願い致します。")];
    }
	
    return persistentStoreCoordinator;
}

@end
