//
//  BzEventExtensionManager.m
//  BzCalendar
//
//  Created by 小林 活水 on 12/05/17.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import "BzEventExtensionManager.h"
#import "CalendarManager.h"

#import "BzCalendar-Swift.h"

@interface BzEventExtensionManager()

@property (atomic) BOOL cacheInProcess;
//NSManagedObjectContext* _privateMoc;
//NSMutableDictionary* _extensionDict;

@property(nonatomic, retain) NSManagedObjectContext* _privateMoc;
@property(nonatomic, retain) NSMutableDictionary* _extensionDict;

- (id) initSingleton;

//- (EventExtension*) getExtensionOfFromCoreData:(EKEvent*)event;

@end

@implementation BzEventExtensionManager

//@synthesize _privateMoc;
//@synthesize _extensionDict;

#pragma mark - インスタンス

+(BzEventExtensionManager*)sharedManager {
    static BzEventExtensionManager* singleton = nil;
    
    if( singleton == nil ) {
        singleton = [[BzEventExtensionManager alloc] initSingleton];
        
    }
    return singleton;
}

- (id) initSingleton {
    LOG_METHOD;
    self = [super init];
    if( self != nil ) {
        self.cacheInProcess = FALSE;
        self._extensionDict = [NSMutableDictionary dictionaryWithCapacity:100];
        self._privateMoc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
    }
    return self;
}

- (id) init {
    LOG(@"use initSingleton caz this is singleton class");
    return nil;
}


#pragma mark - NSManagedObjectContextを受け取って設定する

// 親のNSManagedObjectContextは別にあって、子供のNSManagedObjectContextを外からセットする
-(void)setPrivateContext:(NSManagedObjectContext *)privateContext {
    self._privateMoc = privateContext;
    
    [self clearCache:^(NSError *error) {
        
    }];
    
}

#pragma mark -
- (void)dealloc {
    if( self._privateMoc ) self._privateMoc = nil;
    if( self._extensionDict ) self._extensionDict = nil;
    
}

#pragma mark -
- (NSArray*) getAllIdentifiers {
    return [self._extensionDict allKeys];
}

- (EventExtension*) getExtensionOf:(EKEvent*)event {
    
    if( self.cacheInProcess ) {
        return nil;
    }
    EventExtension* rtnVal = nil;
    if( self._extensionDict != nil ) {
		rtnVal = [self._extensionDict objectForKey:event.calendarItemExternalIdentifier];
		if( rtnVal == nil) {
			rtnVal = [self._extensionDict objectForKey:event.calendarItemIdentifier];
		}
		if( rtnVal == nil ) {
			rtnVal = [self._extensionDict objectForKey:event.eventIdentifier];
		}
    }
    return rtnVal;
}

-(void)clearCache:(void (^)(NSError *))completionHandler {
    LOG_METHOD;
    
    self.cacheInProcess = TRUE;
    
    [self._privateMoc performBlock:^{
        [self._privateMoc refreshAllObjects];
        
        NSMutableDictionary* tempDict = [NSMutableDictionary dictionaryWithCapacity:10];
        
        NSFetchRequest*      fetchRequest;
        NSEntityDescription* entity;
        
        fetchRequest = [[NSFetchRequest alloc] init];
        entity = [NSEntityDescription entityForName:@"EventExtension" inManagedObjectContext:self._privateMoc];
        [fetchRequest setEntity:entity];
        
        NSAsynchronousFetchRequest *asynchronousFetchRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:fetchRequest completionBlock:^(NSAsynchronousFetchResult *result) {
            
            NSArray* array = result.finalResult;
            NSError* operationError = result.operationError;
            
            if( operationError ) {
                self.cacheInProcess = FALSE;
                LOG_METHOD;
                LOG(@"error: %@",operationError);
                completionHandler(operationError);
                return;
            }
            
            __block BOOL updated = NO;
            //requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            
            EKEventStore* eventStore     = [[AppEventKit shared] store];
            
            //[eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            for( EventExtension* ext in array ) {
                //   ext.identifier
                //NSLog(@"ext.identifier: %@", ext.identifier);
                //EKCalendar* calendar = [eventStore calendarWithIdentifier:ext.calendarIdentifier];
                
                EKEvent* evt = nil;
                NSArray* extEvents = [eventStore calendarItemsWithExternalIdentifier:ext.identifier];
                evt = [extEvents firstObject];
                
                if( evt == nil ) {
                    evt = [eventStore eventWithIdentifier:ext.identifier];
                    if( evt == nil ) {
                        NSLog(@"not found");
                        continue;
                    }
                }
                
                if( evt.calendarItemExternalIdentifier &&
                   ([ext.identifier compare:evt.calendarItemExternalIdentifier] != NSOrderedSame) ){
                    ext.identifier = evt.calendarItemExternalIdentifier;
                    updated = YES;
                } else if ( evt.calendarItemIdentifier &&
                           ([ext.identifier compare:evt.calendarItemIdentifier] != NSOrderedSame) ) {
                    ext.identifier = evt.calendarItemIdentifier;
                    updated = YES;
                }
                
                NSString* eventID = ext.identifier;
                if( eventID ) {
                    [tempDict setObject:ext forKey:eventID];
                    
                    LOG(@"got Extension: %@", ext);
                    
                } else {
                    NSLog(@"eventID is NULL!!!!!");
                }
                
            }
            [self._extensionDict removeAllObjects];
            [self._extensionDict setDictionary:tempDict];
            
            if( updated ) {

                [self._privateMoc performBlock:^{
                    NSError* error = nil;
                    [self._privateMoc save:&error];
                    if( error ) {
                        LOG(@"error: %@", error);
                    } else {
                        [self._privateMoc.parentContext performBlock:^{
                            NSError* error = nil;
                            [self._privateMoc.parentContext save:&error];
                            if( error ) {
                                LOG(@"error: %@", error);
                            }
                        }];
                    }

                 }];
            }
            
            
            NSNotification* notify = [NSNotification notificationWithName:NSNotification.BzCalendar_iCloudData_Ready
                                                                   object:self
                                                                 userInfo:nil];
            
            NSNotificationCenter* nCenter = [NSNotificationCenter defaultCenter];
            [nCenter postNotification:notify];
            
            self.cacheInProcess = FALSE;
            completionHandler(nil);

        }];
        NSError *asynchronousFetchRequestError = nil;
        NSAsynchronousFetchResult *asynchronousFetchResult = (NSAsynchronousFetchResult *)[self._privateMoc executeRequest:asynchronousFetchRequest error:&asynchronousFetchRequestError];
        
        
    }];
    
}
- (void)saveAllChangesInContext:(void (^)(NSError* error))completionHandler {
	LOG_METHOD;
    __block BOOL rtnVal = NO;
    //NSError* error = nil;
	NSLog(@"privateMoc: %@, parentMoc: %@", self._privateMoc, self._privateMoc.parentContext);
	
    [self._privateMoc performBlock:^{
        NSError* error = nil;
        [self._privateMoc save:&error];
        if( error ) {
            completionHandler(error);
            return;
        }
        [self._privateMoc.parentContext performBlock:^{
            NSError* error = nil;
            
            rtnVal = [self._privateMoc.parentContext save:&error];
            if( error ) {
                completionHandler(error);
                return;
            }
            [self clearCache:^(NSError *error) {
                completionHandler(error);
                return;
            }];
        }];

    }];
}

- (void) deleteExtension:(EventExtension*)ext {
    [self._privateMoc performBlock:^{
        [self._extensionDict removeObjectForKey:ext.identifier];

        [self._privateMoc deleteObject:ext];
        
        NSError* error = nil;
        [self._privateMoc save:&error];
        if( error ) {
            LOG(@"error: %@",error);
        } else {
            [self._privateMoc.parentContext performBlock:^{
                NSError* error = nil;
                [self._privateMoc.parentContext save:&error];
                if( error ) {
                    LOG(@"error: %@",error);
                }
            }];
        }

        
    }];
 //   [tmpMoc release];
}
- (EventExtension*) addExtensionTo:(EKEvent*)event {
    __block EventExtension* newExtension = nil;
    [self._privateMoc performBlockAndWait:^{
    //[self._privateMoc performBlock:^{

        if( self._extensionDict != nil ) {
            newExtension = [self getExtensionOf:event];
            if( newExtension == nil ) {
                
                newExtension = (EventExtension*) [NSEntityDescription
                                                  insertNewObjectForEntityForName:@"EventExtension"
                                                  inManagedObjectContext:self._privateMoc];
			
				if( event.calendarItemExternalIdentifier ) {
					newExtension.identifier = event.calendarItemExternalIdentifier;
				} else if( event.calendarItemIdentifier ){
					newExtension.identifier = event.calendarItemIdentifier;
				}
                [self._extensionDict setObject:newExtension forKey:newExtension.identifier];
            }
        }
    }];
//    [tmpMoc release];

    return newExtension;
}

@end
