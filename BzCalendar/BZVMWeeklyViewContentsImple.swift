//
//  BzWeekScheduleComponent.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/26.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit
import EventKit

fileprivate class WeekScheduleComponentDayData : NSObject, BZVMWeeklyViewDayContents {
    
    var date : Date = Date()
    var weekday : Int!
    var isHoliday : Bool = false
    var holidayTitle: String? = nil
    var isCustomHoliday: Bool = false
    var rokuyoTitle: String? = nil
    var isSelectedDate: Bool = false
    
    var eventComponents : Array<BZVMTimedComponent> = Array()
    
    func add(event:EKEvent) {
        var isAdded = false
        
        var timedComponents = self.eventComponents.last
        
        if let timedComponents = timedComponents {
            if timedComponents.isEventTimeOverlap(event: event) {
                timedComponents.add(event: event)
                isAdded = true
            }
        }
        if isAdded == false {
            timedComponents = BZVMTimedComponent(event: event)
            self.eventComponents.append(timedComponents!)
        }
    }
//    fileprivate var _longEvents: Array<BzWeekScheduleComponentLongEvent> = Array()
//    func longEvents() -> Array<BzWeekScheduleComponentLongEvent> {
//        return _longEvents
//    }
//    func addLongEvent(longEvent:BzWeekScheduleComponentLongEvent) {
//        self._longEvents.append(longEvent)
//    }
//    fileprivate var _alldayEvents: Array<EKEvent> = Array()
//    func alldayEvents() -> Array<EKEvent> {
//        return _alldayEvents
//    }
//    func addAlldayEvent(event:EKEvent) {
//        self._alldayEvents.append(event)
//    }
//    fileprivate var _endAfterStartDayEvents : Array<EKEvent> = Array()
//    func endAfterStartDayEvents() -> Array<EKEvent> {
//        return _endAfterStartDayEvents
//    }
//    func addEndAfterStartDayEvent(event:EKEvent) {
//        self._endAfterStartDayEvents.append(event)
//    }
//    fileprivate var _shortEvents: Array<EKEvent> = Array()
//    func shortEvents() -> Array<EKEvent> {
//        return _shortEvents
//    }
//    func addShortEvent(event:EKEvent) {
//        self._shortEvents.append(event)
//    }
    
    func clearData() {
//        self._longEvents.removeAll()
//        self._alldayEvents.removeAll()
//        self._endAfterStartDayEvents.removeAll()
//        self._shortEvents.removeAll()
    }
    
    func isSunday() -> Bool {
        return self.weekday == 1 // グレゴリアン
    }
    func isSaturday() -> Bool {
        return self.weekday == 7 // グレゴリアン
    }
    // MARK: - インスタンス化
    init(date:Date) {
        super.init()
        self.date = date
        
        let appCalendar = CalendarManager.shared().appCalendar()!
        let comps = appCalendar.dateComponents([.weekday], from: date)
        self.weekday = comps.weekday!
        
        let holidayManager = WorldCalendarManager.shared
        if let title = holidayManager.holidayTitle(at: date), title.isEmpty == false {
            self.isHoliday = true
            self.holidayTitle = title
        }

    }
    
    private override init() {
        fatalError("init() is not to be used")
    }
}

// BzWeekScheduleComponentの実装
class WeekScheduleComponent : NSObject, BZVMWeeklyViewContents {    
    
    fileprivate var startDate: Date!
    fileprivate var endDate: Date!

    fileprivate var year : Int!
    fileprivate var month: Int!
    fileprivate var day : Int!
    fileprivate var endDateEndTime: Date!
    //fileprivate var dayComponents : Array<DayScheduleComponent> = Array()
    fileprivate var dayDataArray : Array<WeekScheduleComponentDayData> = Array()
    fileprivate var _alldayViewContents : BZVMAlldayViewContents = BZVMAlldayViewContents()

    func selectedDate(_ selectedDate: Date?) {
        if let date = selectedDate {
            if date.compare(self.startDate) != .orderedAscending &&
                date.compare(self.endDate) != .orderedDescending  {
                // selectedDateが対象期間の日付の場合はアップデートする
                for dayData in self.dayDataArray {
                    if dayData.date.compare(date) == .orderedSame {
                        dayData.isSelectedDate = true
                    } else {
                        dayData.isSelectedDate = false
                    }
                }
            }
        }
    }
    
    var alldayViewContents : BZVMAlldayViewContents {
        get {
            return self._alldayViewContents
        }
    }

    var fromDate: Date {
        get {
            return self.startDate
        }
    }
    var toDate: Date {
        get {
            return self.endDate
        }
    }
    var fromTime : Date {
        get {
            return self.startDate
        }
    }
    var toTime : Date {
        get {
            return self.endDateEndTime
        }
    }
    fileprivate func date(index:Int) -> Date {
        if index < 0 || index > 6 {
            fatalError("index is in the range 0..<7")
        }
        return self.dayDataArray[index].date

        //return self.dayComponents[index].fromTime
    }
//    fileprivate func dayComponent(index:Int) -> DayScheduleComponent {
//        if index < 0 || index > 6 {
//            fatalError("index out of range")
//        }
//        return self.dayComponents[index]
//    }
    
    func bzDateArray() -> Array<BZVMWeeklyViewDayContents> {
        return self.dayDataArray
    }

    func dayData(index:Int) -> BZVMWeeklyViewDayContents {
        return self.dayDataArray[index]
    }
    func clearDayData() {
//        for dayData in self.dayDataArray {
//            dayData.clearData()
//        }
    }

    // MARK: - インスタンス化
    
    init(containsDate date: Date) {
        self._alldayViewContents = BZVMAlldayViewContents()
        super.init()
        let appCalendar = CalendarManager.shared().appCalendar()!
        let firstWeekday = appCalendar.firstWeekday
        
        let unitFlag : Set<Calendar.Component> = [.year, .month, .day, .weekday]
        let comps = appCalendar.dateComponents(unitFlag, from: date)
        self.year = comps.year!
        self.month = comps.month!
        self.day = comps.day!
        
        let dateWeekday = comps.weekday!
        
        var midnightComps = comps
        midnightComps.hour = 0
        midnightComps.minute = 0
        midnightComps.second = 0
        let midnightDate = appCalendar.date(from: midnightComps)!
        
        let beforeDiff : Int = -((dateWeekday - firstWeekday + 7) % 7)
        let afterDiff  : Int = 6 + beforeDiff
        
        var beforeDiffComps = DateComponents()
        beforeDiffComps.day = beforeDiff
        
        self.startDate = appCalendar.date(byAdding: beforeDiffComps, to: midnightDate)!
        
        var afterDiffComps = DateComponents()
        afterDiffComps.day = afterDiff
        
        self.endDate = appCalendar.date(byAdding: afterDiffComps, to: midnightDate)
        
        let endDateComps = appCalendar.dateComponents([.year, .month, .day, .weekday], from: self.endDate)
        var toTimeComps = endDateComps
        toTimeComps.hour = 23
        toTimeComps.minute = 59
        toTimeComps.second = 59
        
        self.endDateEndTime = appCalendar.date(from: toTimeComps)!
        
        var oneDayDiffComps = DateComponents()
        
        let rokuyoReader = BZIFRokuyoReader.shared
        // 2018/12/31の六曜データがないようで、配列でループするとデータが足りないため落ちる
        
        let customHolidaySet = CustomHolidayCalendarManager.shared.ekEventSetFrom(from: fromTime, to: toTime)

//        self.dayComponents.append(
//            DayScheduleComponent(date: self.startDate)
//        )
        let dayData = WeekScheduleComponentDayData(date: self.startDate)
        if customHolidaySet.contains(self.startDate) {
            dayData.isCustomHoliday = true
        }
        let title = rokuyoReader.rokuyoTitleAt(date: self.startDate)
        dayData.rokuyoTitle = title
        
        self.dayDataArray.append(dayData)
        for idx in 1..<7 {
            oneDayDiffComps.day = idx
            let date = appCalendar.date(byAdding: oneDayDiffComps, to: self.startDate)!
            //let dayComp = DayScheduleComponent(date: date)
//            self.dayComponents.append(dayComp)
            
            let dayData = WeekScheduleComponentDayData(date: date)
            
            if customHolidaySet.contains(date) {
                dayData.isCustomHoliday = true
            }
            // 2018/12/31の六曜データがないようで、配列でループするとデータが足りないため落ちる
            let title = rokuyoReader.rokuyoTitleAt(date: date)
            dayData.rokuyoTitle = title
            

            self.dayDataArray.append(dayData)

        }
        
        self.loadData()
    }
    
    private override init() {
        fatalError()
    }
    
    // MARK: - プライベート
    fileprivate func loadData() {
        
        self._alldayViewContents = BZVMAlldayViewContents()
        self.clearDayData()
        
        let fromTime = self.fromTime
        let toTime   = self.toTime
        
        let appCalendar = CalendarManager.shared().appCalendar()!
        
        let calMgar = BzCalendarSettingManager.shared

        let selectedEKCals = calMgar.selectedEKCalendars()
        var ekEvents = AppEventKit.shared.events(from: fromTime, to: toTime, calendars: selectedEKCals) 
        ekEvents = ekEvents.sorted(by: {
            let compareResult = $0.startDate.compare($1.startDate)
            if  compareResult == .orderedAscending {
                return true
            } else if compareResult == .orderedSame {
                let compareResultLastDate = $0.endDate.compare($1.endDate)
                if compareResultLastDate != .orderedDescending {
                    return true
                }
            }
            return false
        })
        let diffFlag : Set<Calendar.Component> = [.day]
        for event in ekEvents {
            var dayIdx : Int = 0
            if event.startDate.compare(self.startDate) != .orderedAscending {
                let diffComps = appCalendar.dateComponents( diffFlag, from: self.startDate, to: event.startDate)
                if dayIdx >= 0 && dayIdx < 7 {
                    dayIdx = diffComps.day!
                }
            }
            let dayData = self.dayDataArray[dayIdx]
            
            if self.isLongEvent(event: event) { // 24時間よりも長いイベント
                let daysInThisWeek = self.eventLengthInThisWV(event: event)
                self._alldayViewContents.add(event: event, index: dayIdx, length: daysInThisWeek)
            } else if event.isAllDay == true { // 終日イベント（２日以上の終日はisLongEventで既にtrueとなっている
                self._alldayViewContents.add(event: event, index: dayIdx)
            } else if self.daysCount(event: event) > 0 { // 日にちを明日以降までまたぐイベント
                let nextDayIdx = dayIdx + 1
                if nextDayIdx < 7 {
                    let nextDayData = self.dayDataArray[nextDayIdx]
                    nextDayData.add(event: event)
                }
                dayData.add(event: event)
            } else {
                dayData.add(event: event)
            }
            
        }
        self.selectedDate(self.fromDate)

    }
    
    
    fileprivate func eventLengthInThisWV(event:EKEvent) -> Int {
        
        if event.title == "long time" {
            
        }
        
        var length = 0
        
        let appCalendar = CalendarManager.shared().appCalendar()!
        
        // if 開始日がこの週の最初の日より前
        if event.startDate.compare(self.fromDate) == .orderedAscending {
            // if 終了日この週の終了日より後
            if event.endDate.compare(self.endDate) == .orderedDescending {
                length = 7
            } else {
                // endDateはこの週ビュー
                let dayFlag : Set<Calendar.Component> = [ .day ]
                let endComps = appCalendar.dateComponents(dayFlag, from: self.fromDate, to:event.endDate)
                length = endComps.day! + 1 // self.fromDateは0時基準なので、
            }
        } else {
            // この週のイベントがくることが前提条件なので、開始日がこの週以前でなければ必ずこの週であるはずである
            // if 終了日がこの週の最終日より後
            if event.endDate.compare(self.endDate) == .orderedDescending {
                //開始日から今週最終日までが長さ
                let unitFlag : Set<Calendar.Component> = [ .day, .hour, .minute, .second ]
                
                //let startComps = appCalendar.dateComponents(unitFlag, from: event.startDate)
                //let weekEndComps = appCalendar.dateComponents(unitFlag, from: self.endDate)
                
                let comp = appCalendar.dateComponents(unitFlag, from: event.startDate, to:self.endDate)
                //length = weekEndComps.day! - startComps.day! + 1
                length = comp.day! + 1
                if comp.hour! > 0 || comp.minute! > 0 || comp.second! > 0 {
                    length += 1
                }
                if length < 0 {
                    
                }
            } else {
                // つまり今週始まりの今週終わりのイベント
                let unitFlag : Set<Calendar.Component> = [ .day, .hour, .minute, .second ]
                let startComps = appCalendar.dateComponents(unitFlag, from: event.startDate)
                let endComps = appCalendar.dateComponents(unitFlag, from: event.endDate)
                
                let comp = appCalendar.dateComponents(unitFlag, from: event.startDate, to: event.endDate)
                
                length = comp.day!
                if comp.hour! > 0 || comp.minute! > 0 || comp.second! > 0 {
                    length += 1
                }
                //length = endComps.day! - startComps.day! + 1 // 月またぐとマイナスの値になるよ
                
                if length < 0 {
                    
                }
            }
        }
        if length > 7 {
            fatalError()
        }
        if length < 0 {
            
        }
        return length
        
    }
    
}

//    fileprivate func eventLengthInThisWV(event:EKEvent) -> Int {
//        var length = 0
//        
//        
//        let appCalendar = CalendarManager.shared().appCalendar()!
//        
//        // if 開始日がこの週の最初の日より前
//        if event.startDate.compare(self.fromDate) == .orderedAscending {
//            // if 終了日この週の終了日より後
//            if event.endDate.compare(self.endDate) == .orderedDescending {
//                length = 7
//            } else {
//                // endDateはこの週ビュー
//                let dayFlag : Set<Calendar.Component> = [ .day ]
//                let endComps = appCalendar.dateComponents(dayFlag
//                    , from: self.fromDate, to:event.endDate)
//                length = endComps.day! + 1
//            }
//        } else {
//            // この週のイベントがくることが前提条件なので、開始日がこの週以前でなければ必ずこの週であるはずである
//            // if 終了日がこの週の最終日より後
//            if event.endDate.compare(self.endDate) == .orderedDescending {
//                //開始日から今週最終日までが長さ
//                let unitFlag : Set<Calendar.Component> = [ .day, .hour, .minute, .second ]
//                
//                let startComps = appCalendar.dateComponents(unitFlag, from: self.startDate)
//                let weekEndComps = appCalendar.dateComponents(unitFlag, from: self.endDate)
//                
//                length = weekEndComps.day! - startComps.day! + 1
//                
//            } else {
//                // つまり今週始まりの今週終わりのイベント
//                let unitFlag : Set<Calendar.Component> = [ .day, .hour, .minute, .second ]
//                let startComps = appCalendar.dateComponents(unitFlag, from: event.startDate)
//                let endComps = appCalendar.dateComponents(unitFlag, from: event.endDate)
//                
//                length = endComps.day! - startComps.day! + 1
//            }
//        }
//        return length
//        
//    }
//
//}

extension WeekScheduleComponent {
    
    fileprivate func isLongEvent(event:EKEvent) -> Bool {
        
        let startDate : Date = event.startDate
        let endDate : Date = event.endDate
        
        let interval_sec = endDate.timeIntervalSince(startDate)
        
        let interval_day = interval_sec / (60.0*60.0*24.0)
        
        if interval_day > 1 {
            return true
        }

        return false

    }
    
    fileprivate func daysCount(event:EKEvent) -> Int {
        var rtnVal : Int = 0
        let appCalendar = CalendarManager.shared().appCalendar()!
        
        let startDiffComps = appCalendar.dateComponents([ .day ], from: self.date(index: 0), to: event.startDate)
        let endDiffComps   = appCalendar.dateComponents([ .day ], from: self.date(index: 0), to: event.endDate)
        
        rtnVal = endDiffComps.day! - startDiffComps.day!
        return rtnVal
    }
}

extension WeekScheduleComponent {

//    fileprivate func createViewModel() {
//        for viewIdx in 0..<7 {
//            guard var timedComponentsArray = self._timedComponentsDict[viewIdx] else {
//                continue
//            }
//
//            let dayData = self.dayData(index: viewIdx)
//            let longEvents = dayData.longEvents()
//            for longEvent in longEvents {
//                self._alldayViewContents.add(event: longEvent.event, index: longEvent.startIndex, length: longEvent.daysInThisWeek)
//            }
//            let alldayEvents = dayData.alldayEvents()
//            for event in alldayEvents {
//                self._alldayViewContents.add(event: event, index: viewIdx)
//            }
//            let endAfterStartDayEvents = dayData.endAfterStartDayEvents()
//            for event in endAfterStartDayEvents {
//                var isAdded = false
//                var timedComponents = timedComponentsArray.last
//                if let timedComponents = timedComponents {
//                    if timedComponents.isEventTimeOverlap(event: event) {
//                        timedComponents.add(event: event)
//                        isAdded = true
//                    }
//                }
//                if isAdded == false {
//                    timedComponents = BZVMTimedComponent(event: event)
//                    timedComponentsArray.append(timedComponents!)
//                }
//
//
//
//            }
//        }
//    }
    
}
