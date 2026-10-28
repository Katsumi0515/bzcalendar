//
//  BZVMWeekRowDayItem.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/06/22.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

protocol BZVMWeekRowItem {
    var rowIndex : Int { get }
    var startDayIndex: Int { get }
    var endDayIndex: Int { get }
    var daysInThisWeek : Int { get }

    func title() -> String?
    func calendarColor() -> UIColor?
//    func textColor() -> UIColor
//    func bgColor() -> UIColor
}
class BZVMWeekRowHolidayItem : NSObject, BZVMWeekRowItem {
    let rowIndex : Int
    
    let startDayIndex: Int
    let endDayIndex: Int
    let daysInThisWeek : Int
    let _title : String
    
    init(rowIndex:Int, title: String, startIndex:Int, daysInThisWeek:Int = 1) {
        guard daysInThisWeek > 0 else {
            fatalError("length must be more than 0")
        }
        self._title = title
        self.rowIndex = rowIndex
        self.startDayIndex = startIndex
        self.daysInThisWeek = daysInThisWeek
        self.endDayIndex = startIndex + daysInThisWeek - 1
        super.init()
    }
    func title() -> String? {
        return self._title
    }
    func calendarColor() -> UIColor? {
        return nil
    }
//    func textColor() -> UIColor {
//        return
//    }
//    func bgColor() -> UIColor {
//        return self.event.bgColor()
//    }

}

@objc @objcMembers class BZVMWeekRowDayItem: NSObject, BZVMWeekRowItem {
    let rowIndex : Int

    let event: EKEvent
    let startDayIndex: Int
    let endDayIndex: Int
    let daysInThisWeek : Int
    
    let isLongEvent: Bool
    
    init(rowIndex:Int, event:EKEvent, startIndex:Int, daysInThisWeek:Int = 1, isLongEvent:Bool = false) {
        guard daysInThisWeek > 0 else {
            fatalError("length must be more than 0")
        }
        self.rowIndex = rowIndex
        self.event = event
        self.startDayIndex = startIndex
        self.daysInThisWeek = daysInThisWeek
        self.endDayIndex = startIndex + daysInThisWeek - 1
        self.isLongEvent = isLongEvent
        super.init()
    }
    private override init() {
        fatalError("init() not supported")
    }
    func title() -> String? {
        return self.event.title
    }
    func calendarColor() -> UIColor? {
        return ColorUtil.shared.UIColorFromEKEvent(self.event)
    }
    func textColor() -> UIColor {
        return self.event.textColor()
    }
    func bgColor() -> UIColor {
        return self.event.bgColor()
    }
    func isAllDay() -> Bool {
        return self.event.isAllDay
    }
    
}
