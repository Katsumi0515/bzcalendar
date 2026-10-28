//
//  BzCloudManagedObjectContextManager.h
//  BzCalendar
//
//  Created by 小林 活水 on 12/01/31.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import	<CoreData/CoreData.h>
#import "BzCloudMOCManagerProtocol.h"


@interface BzCloudManagedObjectContextManager : NSObject
<BzCloudMOCManagerProtocol> {
    
}

+ (void)createContextManager: (void (^)(NSObject<BzCloudMOCManagerProtocol>* parentContext, NSError *error))completionHandler;

- (NSManagedObjectContext*) bzCloudContext;

//- (BOOL)save:(NSError **)error;

- (BOOL) isReadyToUse;
- (void) processPendingChanges;

@end
