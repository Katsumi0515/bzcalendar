//
//  CustomHolidayCalendarManager.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/27.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class CustomHolidayCalendarManager: NSObject {

    static var shared : CustomHolidayCalendarManager = CustomHolidayCalendarManager()
    fileprivate var _holidaySet : Set<Date> = Set()
    
    fileprivate override init() {
        super.init()
    }
    
    func ekEventSetFrom(from:Date, to:Date) -> Set<Date> {
        guard let holidayID = BasicAppSettingManager.shared().customHolidayID(), holidayID.isEmpty == false else {
            return Set()
        }
        
        var mutSet : Set<Date> = Set()
        
        guard let holidayCal = AppEventKit.shared.store()?.calendar(withIdentifier: holidayID) else {
            return Set()
        }
//        guard let holidayCal = AppEventKit.shared().store().calendar(withIdentifier: holidayID) else {
//            return Set()
//        }
        
  
        var selectedEKCals : Array<EKCalendar> = Array()
        selectedEKCals.append(holidayCal)
        
        let arr = AppEventKit.shared.events(from: from, to: to, calendars: selectedEKCals)
//        guard let arr = AppEventKit.shared().events(from: from, to:to, calendars:selectedEKCals) else {
//            return Set()
//        }
        
        let calendar = CalendarManager.shared().appCalendar()!
        let flag : Set<Calendar.Component> = [ .day, .month, .year ]
        for evt in arr {
            let comp = calendar.dateComponents(flag, from:evt.startDate)
            if let midNightDate = calendar.date(from:comp) {
                mutSet.insert(midNightDate)
            }
        }
        
        self._holidaySet = mutSet;
        return self._holidaySet;
    }

    func eventExists(on date:Date) -> Bool {
        
        let appCalendar = CalendarManager.shared().appCalendar()!

        let flag : Set<Calendar.Component>  = [ .year, .month, .day ]

        let fromDtComp = appCalendar.dateComponents(flag, from:date)
        var toDtComp = appCalendar.dateComponents(flag, from:date)
        toDtComp.hour = 23
        toDtComp.minute = 59
        toDtComp.second = 59
        
        let fromDt = appCalendar.date(from: fromDtComp)!
        let toDt = appCalendar.date(from: toDtComp)!
        let eventSet = self.ekEventSetFrom(from: fromDt, to: toDt)

        if eventSet.count > 0 {
            return true
        }
        
        return false
    }

}
