//
//  AppEventKit.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/29.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

@objc @objcMembers class AppEventKit: NSObject {
    static var shared : AppEventKit = AppEventKit()
    
    fileprivate var eventStore : EKEventStore? = nil
    fileprivate var newEventSinglton : EKEvent? = nil
    
    fileprivate override init() {
        super.init()
        
        let tmpStore = EKEventStore()
        tmpStore.requestAccess(to: .event) {
            (success, error) in
            if success == true {
                tmpStore.reset()
                self.eventStore = tmpStore
            }
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(storeChanged),
                                               name: NSNotification.Name.EKEventStoreChanged,
                                               object: self.eventStore)
        
    }
    
    func store() -> EKEventStore? {
        return self.eventStore
    }

    func newEvent() -> EKEvent? {
        guard let store = self.eventStore else {
            return nil
        }
        if let _ = self.newEventSinglton {
            self.newEventSinglton = nil
        }
        self.newEventSinglton = EKEvent.init(eventStore: store)
        
        return self.newEventSinglton
    }

    func events(from:Date, to:Date, calendars:Array<EKCalendar>) -> Array<EKEvent> {
        var arr : Array<EKEvent> = Array()
        
        if let store = self.store()  {
            let predicate = store.predicateForEvents(withStart: from, end: to, calendars: calendars)
            arr = store.events(matching: predicate)
        }
        return arr
    }

    @objc fileprivate func storeChanged(note:Notification) {
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
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AppEventKit_EventStoreChanged"), object: nil)
        
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

}
