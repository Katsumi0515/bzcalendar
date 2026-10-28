//
//  BzEventExtensionManager.h
//  BzCalendar
//
//  Created by 小林 活水 on 12/05/17.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@class EventExtension;

@interface BzEventExtensionManager : NSObject {}

+ (BzEventExtensionManager*)sharedManager;
- (void) setPrivateContext:(NSManagedObjectContext*)privateContext;


//- (NSArray*) getAllIdentifiers;
- (EventExtension*) getExtensionOf:(EKEvent*)event;

//- (EventExtension*) addExtensionTo:(EKEvent*)event;

- (void) deleteExtension:(EventExtension*)ext;

//- (void)clearCache:(void (^)(NSError* error))completionHandler;
- (void)saveAllChangesInContext:(void (^)(NSError* error))completionHandler;

@end
