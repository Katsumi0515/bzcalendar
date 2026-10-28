//
//  AppEventKit.m
//  GSystemT0
//
//  Created by 小林 活水 on 11/01/03.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "AppEventKit.h"
#import "CalendarManager.h"

#import "BzCalendar-Swift.h"

@interface AppEventKit()

@property(nonatomic, strong) EKEventStore* store;

-(id)initSingleton;

@end

@implementation AppEventKit

static AppEventKit* singleton;
static EKEvent* newEventSinglton;

#pragma mark - インスタンス

+(AppEventKit*) sharedEventKit {
    if( singleton != nil )
        return singleton;
    singleton = [[AppEventKit alloc] initSingleton];
    return singleton;
}

-(id) initSingleton {
    if ( (self = [super init]) != nil ) {
        
        EKEventStore* tmpStore = [[EKEventStore alloc] init];
        [tmpStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            /* This code will run when uses has made his/her choice */
            if( granted ) {
                [tmpStore reset];
                self.store = tmpStore;
            } else {
            }
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeChanged:)
                                                     name:EKEventStoreChangedNotification object:self.store];
    }
    return self;
}

-(id)init {
    LOG(@"need to call for singleton");
    LOG_METHOD;
    SINGLTON_INIT_NOT_ALLOWED;
    return nil;
}

#pragma mark - EKEventStoreに変更があった際の処理
// ToDo:
// EKEventStoreが変更された時の処理を追加する
-(void) storeChanged:(NSNotification*)notification {
    LOG(@"storeChange:");
    // コメントアウトのコードは特定期間のイベントが変更されたイベントかどうか「総当たり」で調べているもの
//    EKEventStore* ekEventStore = notification.object;
//    NSDate *now = [NSDate date];
//    NSDateComponents *offsetComponents = [NSDateComponents new];
//    [offsetComponents setDay:-1];
//    [offsetComponents setMonth:-1];
//    [offsetComponents setYear:0];
//    NSDate* fromDate = [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents toDate:now options:0];
//    [offsetComponents setDay:1];
//    [offsetComponents setMonth:1];
//    NSDate *endDate = [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents toDate:now options:0];
//    NSArray *ekEventStoreChangedObjectIDArray = [notification.userInfo objectForKey:@"EKEventStoreChangedObjectIDsUserInfoKey"];
//    NSPredicate *predicate = [ekEventStore    predicateForEventsWithStartDate:fromDate
//                                                                      endDate:endDate
//                                                                    calendars:nil];
//    [ekEventStore enumerateEventsMatchingPredicate:predicate usingBlock:^(EKEvent *ekEvent, BOOL *stop) {
//        // Check this event against each ekObjectID in notification
//        [ekEventStoreChangedObjectIDArray enumerateObjectsUsingBlock:^(NSString *ekEventStoreChangedObjectID, NSUInteger idx, BOOL *stop) {
//            NSObject *ekObjectID = [(NSManagedObject *)ekEvent objectID];
//            if ([ekEventStoreChangedObjectID isEqual:ekObjectID]) {
//                // Log the event we found and stop (each event should only exist once in store)
//                LOG(@"calendarChanged(): Event Changed: title:%@", ekEvent.title);
//                *stop = YES;
//            }
//        }];
//    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AppEventKit_EventStoreChanged" object:nil userInfo:nil];
}

#pragma mark -

-(EKEvent*) newEvent {
    
    if( newEventSinglton ) {
        newEventSinglton =nil;
    }
    newEventSinglton = [EKEvent eventWithEventStore:self.store];
    return newEventSinglton;
}


-(EKEventStore*) store {
	return _store;
}

-(NSArray<EKEvent*>*) eventsFrom:(NSDate*)fromDate to:(NSDate*)toDate calendars:(NSArray*)calendars {
    NSArray* arr = nil;
    if( self.store ) {
        NSPredicate* predicate = [self.store predicateForEventsWithStartDate:fromDate endDate:toDate calendars:calendars];
        arr = [self.store eventsMatchingPredicate:predicate];
    }
    return arr;
}

//-(BOOL) cancelNewEvent {
//
//    NSError* error = nil;
//    [self.store removeEvent:newEventSinglton span:EKSpanThisEvent error:&error];
//    return (error == nil);
//
//}

//-(BOOL) saveNewEventAndReleaseInstance {
//
//    NSError* error = nil;
//    [self.store saveEvent:newEventSinglton span:EKSpanThisEvent error:&error];
//    return (error == nil);
//
//}

//// 全てのカレンダー
//-(NSArray<EKCalendar*>*)eventCalendars {
//
//    return [self.store calendarsForEntityType:EKEntityTypeEvent];
//
//}

@end
