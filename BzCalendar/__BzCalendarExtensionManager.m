//
//  BzCalendarExtensionManager.m
//  BzCalendar
//
//  Created by 小林 活水 on 12/02/10.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import "BzCalendarExtensionManager.h"
#import "CalendarManager.h"

#import "BzCalendar-Swift.h"

@interface BzCalendarExtensionManager()

@property(nonatomic, retain) NSManagedObjectContext* _privateMoc;
@property(nonatomic, retain) NSMutableDictionary* _extensionDict;

@property (atomic) BOOL cacheInProcess;

- (id) initSingleton;

@end

@implementation BzCalendarExtensionManager


@synthesize _privateMoc;
@synthesize _extensionDict;

#pragma mark - インスタンス
+(BzCalendarExtensionManager*)sharedManager {
    static BzCalendarExtensionManager* singleton = nil;
    
    if( singleton == nil ) {
        singleton = [[BzCalendarExtensionManager alloc] initSingleton];
        
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

#pragma mark -

-(void)setPrivateContext:(NSManagedObjectContext*)privateContext {
    self._privateMoc = privateContext;

    [self clearCache:^(NSError *error) {
        
    }];

}

#pragma mark -
- (void)dealloc {
    if( self._privateMoc ) self._privateMoc = nil;
    if( self._extensionDict ) self._extensionDict = nil;
    
}

#pragma marks -
- (void)clearCache:(void (^)(NSError* error))completionHandler {
    LOG_METHOD;
    self.cacheInProcess = TRUE;
    
    [self._privateMoc performBlock:^{
        
        NSFetchRequest* fetchRequest;
        NSEntityDescription* entity;
        
        fetchRequest = [[NSFetchRequest alloc] init];
        entity = [NSEntityDescription entityForName:@"CalendarExtension" inManagedObjectContext:self._privateMoc];
        [fetchRequest setEntity:entity];
        
        NSAsynchronousFetchRequest *asynchronousFetchRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:fetchRequest completionBlock:^(NSAsynchronousFetchResult *result) {
            
            NSArray* array = result.finalResult;
            NSError* error = result.operationError;
            
            if( error ) {
                self.cacheInProcess = FALSE;
                LOG_METHOD;
                LOG(@"error: %@",error);
                completionHandler(error);
                return;
            }
            
            LOG(@"extension count: %d",[array count]);
            NSMutableDictionary* tmpDict = [NSMutableDictionary dictionaryWithCapacity:100];
            for( CalendarExtension* ext in array ) {
                NSString* calendarID = ext.identifier;
                [tmpDict setObject:ext forKey:calendarID];
                LOG(@"got Extension: %@", ext);
            }
            [self._extensionDict removeAllObjects];
            [self._extensionDict setDictionary:tmpDict];
            
            self.cacheInProcess = FALSE;
            completionHandler(nil);

        }];
        NSError *asynchronousFetchRequestError = nil;
        NSAsynchronousFetchResult *asynchronousFetchResult = (NSAsynchronousFetchResult *)[self._privateMoc executeRequest:asynchronousFetchRequest error:&asynchronousFetchRequestError];
        
        
    }];

}

#pragma mark -
- (void)saveAllChangesInContext:(void (^)(NSError* error))completionHandler {
    LOG_METHOD;

    [self._privateMoc performBlock:^{
        __block BOOL rtnVal = NO;
        NSError* err = nil;
        rtnVal = [self._privateMoc save:&err];
        if( err ) {
            LOG(@"error: %@", err);
            
            [self clearCache:^(NSError *error) {
                completionHandler(err);
            }];
            
        } else {
            [self._privateMoc.parentContext performBlock:^{
                NSError* err = nil;
                rtnVal = [self._privateMoc.parentContext save:&err];
                if( err ) {
                    LOG(@"error: %@", err);
                }
                [self clearCache:^(NSError *error) {
                    completionHandler(err);
                }];
                
            }];
        }

    }];
}


#pragma mark -
- (CalendarExtension*) getExtensionOf:(EKCalendar*)calendar {
    __block CalendarExtension* rtnVal = nil;
    //calendar.calendarIdentifier
//    [self._privateMoc performBlock:^{
//        //[self._extensionDict removeAllObjects];
//
//        NSFetchRequest* request;
//        NSEntityDescription* entity;
//        NSError* error = nil;
//
//        request = [[NSFetchRequest alloc] init];
//        entity = [NSEntityDescription entityForName:@"CalendarExtension" inManagedObjectContext:self._privateMoc];
//        [request setEntity:entity];
//
//        NSPredicate* predicate = [NSPredicate predicateWithFormat:
//                                  @"identifier = %@", calendar.calendarIdentifier];
//
//        [request setPredicate:predicate];
//
//        NSArray* array = [self._privateMoc executeFetchRequest:request error:&error];
//
//        if( error ) {
//            LOG_METHOD;
//            LOG(@"error: %@",error);
//        } else if( array != nil ) {
//            for( CalendarExtension* ext in array ) {
//                NSString* calendarID = ext.identifier;
//                [self._extensionDict setObject:ext forKey:calendarID];
//            }
//
//            //rtnVal = array.firstObject;
//        }
//
//    }];
    
    if (self.cacheInProcess == TRUE) {
        return nil;
    }
    if( self._extensionDict != nil ) {
        rtnVal = [self._extensionDict objectForKey:calendar.calendarIdentifier];
    }
    return rtnVal;
}

- (CalendarExtension*) addExtensionTo:(EKCalendar*)calendar {
    __block CalendarExtension* newExtension = nil;

    
    //[self._privateMoc performBlockAndWait:^{
    [self._privateMoc performBlock:^{

        if( self._extensionDict != nil ) {
            newExtension = [self getExtensionOf:calendar];
            if( newExtension == nil ) {
                
                newExtension = (CalendarExtension*) [NSEntityDescription
                                                     insertNewObjectForEntityForName:@"CalendarExtension"
                                                     inManagedObjectContext:self._privateMoc];
                newExtension.identifier = calendar.calendarIdentifier;
                [self._extensionDict setObject:newExtension forKey:newExtension.identifier];
            }
        }
    }];
    
    return newExtension;
}

@end
