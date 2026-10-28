//
//  WorldCalendarManager.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/31.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

@objc @objcMembers class WorldCalendarManager: NSObject {
    static var shared : WorldCalendarManager = WorldCalendarManager()
    
    fileprivate var holidaySelectionMgr  = HolidaySelectionManager.shared()
    fileprivate var basicSettingMgr = BasicAppSettingManager.shared()
    fileprivate var isAutoHolidayDetect : Bool = false
    fileprivate var selectedHolidayIdentifireList : Array<String> = Array()
    
    fileprivate override init() {
        super.init()
        self.update()
    }
    
    func selectedHolidayIdentifiers() -> Array<String> {
        return self.selectedHolidayIdentifireList
    }
    
    
    func holidayTitle(at date: Date) -> String? {
        if self.selectedHolidayIdentifireList.count == 0  {
            return nil;
        }
        guard let appCalendar = CalendarManager.shared().appCalendar() else {
            return nil
        }
        
        
        let context = BzHolidayManagedObjectContextManager.shared.sharedContext()
        
        let flags : Set<Calendar.Component> = [.day, .month, .year]

        var comp = appCalendar.dateComponents(flags, from: date)
        comp.hour = 0
        comp.minute = 0
        comp.second = 0
        let dt = appCalendar.date(from:comp)!
        
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"WorldHoliday")
        request.predicate = NSPredicate(format:"identifier in %@ and date = %@", self.selectedHolidayIdentifireList, (dt as NSDate))
        
        do {
            if let array = try context.fetch(request) as? [WorldHoliday], let item = array.first {
                if let rtnString = item.title {
                    return rtnString
                }
            }
        }
        catch {
            print("error", error)
        }
        return nil
    }
    
    func isHolidayOn() -> Bool {
        var rtnVal : Bool = false
        if self.isAutoHolidayDetect || self.selectedHolidayIdentifireList.count > 0  {
            rtnVal = true
        }
        return rtnVal
    }
    
    func saveHolidayCalendars(identifierList: Array<String>?) -> Error? {
        
        do {
            try HolidaySelectionManager.shared().saveSelectedHolidays(identifierList)
            self._setSelectedHolidayCalendar()
            return nil
        }
        catch {
            return error
        }
    }
    func update() {
        self.isAutoHolidayDetect = BasicAppSettingManager.shared().isAutoHolidayDetect()
        
        if self.isAutoHolidayDetect {
            self._setAutoDetectedHolidayCalendar()
        } else {
            self._setSelectedHolidayCalendar()
        }

    }
    
    //-(NSArray*)holidayArrayFrom:(NSDate*)fromDate to:(NSDate*)toDate;

    
    // MARK: - プライベート
    
    fileprivate func _setAutoDetectedHolidayCalendar() {
        
        self.selectedHolidayIdentifireList = Array()

        let context = BzHolidayManagedObjectContextManager.shared.sharedContext()
        let locale = (Locale.current as NSLocale)

        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"WorldHolidayCalendar")
        if let countryCode = (locale as NSLocale).object(forKey: .countryCode) as? String {
            request.predicate = NSPredicate(format:"countryCode = %@", countryCode)
        }
        
        do {
            if let array = try context.fetch(request) as? [WorldHolidayCalendar], let holidayCal = array.first {
                if let holidayCalIdentifier = holidayCal.identifier {
                    self.selectedHolidayIdentifireList.append(holidayCalIdentifier)
                }
            }
        }
        catch {
            print("error", error)
        }
    
    }
    
    fileprivate func _setSelectedHolidayCalendar() {
        self.selectedHolidayIdentifireList = []
        if let array = HolidaySelectionManager.shared().selectedHolidayIdentifiers() as? [String] {
            self.selectedHolidayIdentifireList =  array
        }
    }
    

    // MARK: -
    
    //-(NSArray*)holidayArrayFrom:(NSDate*)fromDate to:(NSDate*)toDate {
    //    LOG_METHOD;
    //
    //    if( self.selectedHolidayIdentifireList == nil ) {
    //        return nil;
    //    }
    //    NSManagedObjectContext* context = [[BzHolidayManagedObjectContextManager shared] sharedContext];
    //    NSManagedObjectContext* tmpMoc = context;
    //
    //
    //    [tmpMoc performBlockAndWait:^{
    //        NSUInteger unitFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    //        NSDateComponents* compFrom = [[NSCalendar currentCalendar] components: unitFlag
    //                                                                     fromDate:fromDate];
    //        compFrom.hour = 0;
    //        compFrom.minute = 0;
    //        compFrom.second = 0;
    //        NSDate* fromDt = [[NSCalendar currentCalendar] dateFromComponents:compFrom];
    //
    //        NSDateComponents* compTo = [[NSCalendar currentCalendar] components: unitFlag
    //                                                                   fromDate:toDate];
    //        compTo.hour = 0;
    //        compTo.minute = 0;
    //        compTo.second = 0;
    //        NSDate* toDt = [[NSCalendar currentCalendar] dateFromComponents:compTo];
    //
    //
    //        NSFetchRequest* request;
    //        NSEntityDescription* entity;
    //        NSError* sysError = nil;
    //
    //        request = [[NSFetchRequest alloc] init];
    //        entity = [NSEntityDescription entityForName:@"WorldHoliday" inManagedObjectContext:tmpMoc];
    //        [request setEntity:entity];
    //
    //        NSPredicate* predicate1 = [NSPredicate predicateWithFormat:
    //                                   @"identifier in %@ and date >= %@ and date <= %@",
    //                                   self.selectedHolidayIdentifireList,
    //                                   fromDt,
    //                                   toDt];
    //        [request setPredicate:predicate1];
    //
    //        self._holidayArrayFromTo = [tmpMoc executeFetchRequest:request error:&sysError];
    //
    //
    //        if( sysError ) {
    //        }
    //    }];
    //
    //
    //
    //    return self._holidayArrayFromTo;
    //
    //
    //}

}
