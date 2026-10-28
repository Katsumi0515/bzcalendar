//
//  TemplateManagedObjectContextManager.h
//  GSystemInitData
//
//  Created by 小林 活水 on 11/03/01.
//  Copyright 2011 Yamaha Employee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import	<CoreData/CoreData.h>


@interface TemplateManagedObjectContextManager : NSObject {
	NSManagedObjectContext* managedObjectContext;
	NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

+ (TemplateManagedObjectContextManager*) sharedContextManager;
- (BOOL)save:(NSError **)error;
- (NSManagedObjectContext*) sharedContext;

@end
