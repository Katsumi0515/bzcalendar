//
//  DayScheduleComponent.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/23.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit
import EventKit

protocol BzDayScheduleComponent {
    var fromTime : Date { get }
    var toTime : Date { get }
    var nextFromTime : Date { get }
    var rokuyoTitle : String { get }
    func alldayEvens() -> Array<EKEvent>
    
    func standardEvents() -> Array<EKEvent>
}

class DayScheduleComponent : NSObject, BzDayScheduleComponent {
    
    fileprivate var targetDateAtMidnight : Date!
    fileprivate var targetDateAt235959   : Date!
    fileprivate var nextDateAtMidnight : Date!

    fileprivate var alldayEventArray : Array<EKEvent> = Array()
    fileprivate var standardEventArray : Array<EKEvent> = Array()
    
    var rokuyoTitle: String = ""
    
    // 00:00:00(mid night) of the target date.
    var fromTime : Date {
        get {
            return self.targetDateAtMidnight
        }
    }
    
    // 23:59:59 of the target date.
    var toTime : Date {
        get {
            return self.targetDateAt235959
        }
    }
    
    // 00:00:00 of the target date next date.
    var nextFromTime : Date {
        get {
            return self.nextDateAtMidnight
        }
    }
    
    // MARK: - インスタンス生成
    
    init(date:Date) {
        super.init()
        let appCalender = CalendarManager.shared().appCalendar()!
        
        let comps = appCalender.dateComponents([.year, .month, .day], from: date)
        
        var fromComps : DateComponents = comps
        fromComps.hour = 0
        fromComps.minute = 0
        fromComps.second = 0
        
        self.targetDateAtMidnight = appCalender.date(from: fromComps)!
        
        
        var toComps : DateComponents = comps
        toComps.hour = 23
        toComps.minute = 59
        toComps.second = 59
        //toComps.nanosecond = 990000000
        self.targetDateAt235959 = appCalender.date(from: toComps)
        
        
        var oneDayDiffComp = DateComponents()
        oneDayDiffComp.day = 1
        
        self.nextDateAtMidnight = appCalender.date(byAdding: oneDayDiffComp, to: self.targetDateAtMidnight)
        
        
    }
    
    private override init() {
        fatalError()
    }
    
    // MARK: -
    func alldayEvens() -> Array<EKEvent> {
        return self.alldayEventArray
    }
    
    func standardEvents() -> Array<EKEvent> {
        return self.standardEventArray
    }
    
    // MARK: -
    
    fileprivate func add(event:EKEvent) {
        if event.isAllDay {
            self.alldayEventArray.append(event)
        } else if self.isAllTodayEvent(event: event) == true {
            self.alldayEventArray.append(event)
        } else {
            self.standardEventArray.append(event)
        }
    }
    
    func add(events:Array<EKEvent>) {
        let sortedEvents = events.sorted(by: {
            let compareResult = $0.startDate.compare($1.startDate)
            if  compareResult == .orderedAscending {
                return true
            } else if compareResult == .orderedSame {
                // ToDo: 開始時間が同じ場合、カレンダーの優先順位で決める
            }
            return false
        })

        for evt in sortedEvents {
            self.add(event: evt)
        }

    }
    
    fileprivate func isAllTodayEvent(event:EKEvent) -> Bool {
        if event.isAllDay {
            return true
        }
        
        if event.startDate.compare(self.fromTime) == .orderedDescending {
            return false
        }
        if event.endDate.compare(self.nextFromTime) == .orderedAscending {
            return false
        }
        return true
    }
    
}


