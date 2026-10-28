//
//  BzMonthScheduleComponent.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/06/06.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit
import EventKit


class MonthScheduleComponent: NSObject, BZVMMonthlyViewContents {
    
    var fromDate : Date
    var monthStartDate : Date
    var monthEndDate : Date
    var toDate : Date
    
    func selectedDate(date: Date) {
        // 対象月の選択の場合、更新する
        if date.compare(self.monthStartDate) != .orderedAscending &&
            date.compare(self.monthEndDate) != .orderedDescending  {
            // selectedDateが対象期間の日付の場合はアップデートする
            for weekData in self.weekDataArray() {
                weekData.selectedDate(date)
            }
        }
    }
    
    let weeksCount : Int
    var daysCount : Int
    
    fileprivate let weekday : Int  // 1 sunday, 2 monday, ...
    fileprivate let year : Int
    fileprivate let month : Int
    fileprivate let day   : Int
    fileprivate let weekStartWeekday : Int
    fileprivate var weekDataComps : Array<MonthScheduleComponentWeekData> = Array()
    
    func weekDataArray() -> Array<BZVMWeekRowComponent> {
        return self.weekDataComps
    }
    init(containsDate date: Date) {
        let appCalendar = CalendarManager.shared().appCalendar()!
        
        let unitFlags : Set<Calendar.Component> = [ .year, .month, .day, .weekday]
        // 日時分なしの日付とするため再計算
        var comps = appCalendar.dateComponents(unitFlags, from: date)
        let targetDate = appCalendar.date(from: comps)!
        
        // 月の日数の設定
        self.daysCount = targetDate.dayCountInMonth()
        
        // 月初を設定
        comps.day = 1
        self.monthStartDate = appCalendar.date(from: comps)!
        
        // 再度NSDateComponentsを計算してweekdayを設定する（月初のweekdayなので）
        let firstDateComp = appCalendar.dateComponents(unitFlags, from: self.monthStartDate)
        self.weekday = firstDateComp.weekday!   // 1 sunday, 2 monday, ...
        self.year = firstDateComp.year!
        self.month = firstDateComp.month!
        self.day = firstDateComp.day!
        
        var endOfMonthsetComp = DateComponents()
        endOfMonthsetComp.day = self.daysCount - 1
        
        //    if( endOfMonthDate ) endOfMonthDate =nil;
        
        // 今月の月初に.month = 1, .day = -1 を追加しても今月末になるのでは？
        self.monthEndDate = appCalendar.date(byAdding: endOfMonthsetComp, to: self.monthStartDate)!
        
        self.weekStartWeekday = Int( CalendarManager.shared().weekStartWeekday() )
        
        let beforeDays : Int = -((self.weekday - self.weekStartWeekday + 7) % 7)
        
        var firstWeekStartDateOffsetComp = DateComponents()
        firstWeekStartDateOffsetComp.day = beforeDays
        self.fromDate = appCalendar.date(byAdding: firstWeekStartDateOffsetComp, to: self.monthStartDate)!
        //
        
        
        let weekRange = appCalendar.range(of: .weekOfMonth, in: .month, for: targetDate)
        self.weeksCount = weekRange!.count
        
        var lastWeekEndDateOffsetComp = DateComponents()
        lastWeekEndDateOffsetComp.day = (self.weeksCount * 7) - 1
        
        self.toDate = appCalendar.date(byAdding: lastWeekEndDateOffsetComp, to: self.fromDate)!

        var weekDiffComp = DateComponents()
        weekDiffComp.day = 7
        var tempFromDate = self.fromDate
        for week in 0..<self.weeksCount {
            
            let weekData = MonthScheduleComponentWeekData(fromDate: tempFromDate, weekNumber: (week + 1))
            self.weekDataComps.append(weekData)

            tempFromDate = appCalendar.date(byAdding: weekDiffComp, to: tempFromDate)!

        }
        
        if let firstWeek = self.weekDataComps.first {
            var idx = 0
            var tempDate = firstWeek.dayData(index: idx)
            while tempDate.date.compare(self.monthStartDate) == .orderedAscending {
                tempDate.isThisMonth = false
                idx += 1
                if idx < 7 {
                    tempDate = firstWeek.dayData(index: idx)
                } else {
                    break
                }
            }
        }
        if let lastWeek = self.weekDataComps.last {
            for idx in 0..<7 {
                var tempDate = lastWeek.dayData(index: idx)
                if tempDate.date.compare(self.monthEndDate) == .orderedDescending {
                    tempDate.isThisMonth = false
                }
            }
        }
        
        super.init()
        self.selectedDate(date: self.monthStartDate)

    }
    private override init() {
        fatalError("call init(containsDate)")
    }
    
    func clearData() {
        for comp in self.weekDataComps {
            comp.clearDayData()
        }
    }
}

// BzWeekScheduleComponentの実装
class MonthScheduleComponentWeekData : NSObject, BZVMWeekRowComponent {
    
    
    var weekNumber : Int
    fileprivate var startDate: Date!
    fileprivate var endDate: Date!
    
    fileprivate var year : Int!
    fileprivate var month: Int!
    fileprivate var day : Int!
    fileprivate var endDateEndTime: Date!
    fileprivate var dayDataArray : Array<MonthScheduleComponentDayData> = Array()
        
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
    func selectedDate(_ selectedDate: Date?) {
        if let date = selectedDate {
            if date.compare(self.startDate) != .orderedAscending &&
                date.compare(self.endDate) != .orderedDescending  {
                for dayData in self.dayDataArray {
                    if dayData.date.compare(date) == .orderedSame {
                        dayData.isSelectedDate = true
                    } else {
                        dayData.isSelectedDate = false
                    }
                }
            } else {
                // 親コンポーネントからselectedDateが呼ばれている場合
                // 前に選択されていた状態をクリアしたい
                for dayData in self.dayDataArray {
                    dayData.isSelectedDate = false
                }
            }
        } else {
            
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

    func bzDateArray() -> Array<BzDate> {
        return self.dayDataArray
    }
    
    func dayData(index:Int) -> BZVMWeekRowDayComponent {
        return self.dayDataArray[index]
    }
    
    func clearDayData() {
        for dayData in self.dayDataArray {
            dayData.clearData()
        }
    }
    
    // MARK: - インスタンス化
    
    init(fromDate date: Date, weekNumber:Int) {
        self.weekNumber = weekNumber
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
        
        let unit : Set<Calendar.Component> = [.day]
        let sevenComp = appCalendar.dateComponents(unit, from: self.startDate, to: self.endDate)
        assert(sevenComp.day! == 6)
        
        let endDateComps = appCalendar.dateComponents([.year, .month, .day, .weekday], from: self.endDate)
        var toTimeComps = endDateComps
        toTimeComps.hour = 23
        toTimeComps.minute = 59
        toTimeComps.second = 59
        
        self.endDateEndTime = appCalendar.date(from: toTimeComps)!
        
        var oneDayDiffComps = DateComponents()
        
        let rokuyoReader =  BZIFRokuyoReader.shared

        let customHolidaySet = CustomHolidayCalendarManager.shared.ekEventSetFrom(from: fromTime, to: toTime)
        
        let dayData = MonthScheduleComponentDayData(date: self.startDate, isThisMonth:true)
        
        if customHolidaySet.contains(self.startDate) {
            dayData.isCustomHoliday = true
        }
        let title = rokuyoReader.rokuyoTitleAt(date: self.startDate)
        dayData.rokuyoTitle = title
        
        self.dayDataArray.append(dayData)
        for idx in 1..<7 {
            oneDayDiffComps.day = idx
            let date = appCalendar.date(byAdding: oneDayDiffComps, to: self.startDate)!
            let dayData = MonthScheduleComponentDayData(date: date, isThisMonth:true)
            if customHolidaySet.contains(date) {
                dayData.isCustomHoliday = true
            }
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
       
        //var longEvents : Array<BzWeekScheduleComponentLongEvent> = Array()
        var standardEventsDict: Dictionary<Int, Array<EKEvent>> = [
            0 : Array(),
            1 : Array(),
            2 : Array(),
            3 : Array(),
            4 : Array(),
            5 : Array(),
            6 : Array()
        ]
        
        self.clearDayData()
        
        let fromTime = self.fromTime
        let toTime   = self.toTime
        
        let appCalendar = CalendarManager.shared().appCalendar()!
        
        let calMgar = BzCalendarSettingManager.shared
        
        
        let selectedEKCals = calMgar.selectedEKCalendars()
//        for cal in selectedEKCals {
//            print("cal: ", cal.title)
//        }
        let ekEvents = AppEventKit.shared.events(from: fromTime, to: toTime, calendars: selectedEKCals)
        
        let diffFlag : Set<Calendar.Component> = [.day]
        for event in ekEvents {
            var dayIdx : Int = 0
            if event.startDate.compare(self.startDate) != .orderedAscending {
                let diffComps = appCalendar.dateComponents( diffFlag, from: self.startDate, to: event.startDate)
                if let day = diffComps.day {
                    if day >= 0 && day < 7 {
                        dayIdx = day
                    }

                }
            }
            let dayData = self.dayDataArray[dayIdx]

//            print("title: ", event.title)
            
            if self.isLongEvent(event: event) { // 24時間よりも長いイベント
                
                let daysInThisWeek = self.eventLengthInThisWV(event: event)
                let rowIndex = self.findRowIndex(startIdx: dayIdx, endIdx: (dayIdx + daysInThisWeek - 1))
                let item = BZVMWeekRowDayItem(rowIndex:rowIndex, event:event, startIndex:dayIdx, daysInThisWeek:daysInThisWeek, isLongEvent:true)

                dayData.add(item: item)
                for idx in item.startDayIndex...item.endDayIndex {
                    let dayData = self.dayDataArray[idx]
                    dayData.addFantomSchedule(rowIdx: rowIndex)
                }
                
            } else {
                standardEventsDict[dayIdx]!.append(event)
            }
            
        } // for event in ekEvents
        
        
        // ロングイベントを配置した後に通常のイベントを配置する
        for dayIdx in 0..<7 {
            let dayData = self.dayDataArray[dayIdx]
            if dayData.isHoliday, let title = dayData.holidayTitle, title.isEmpty == false {
                let rowIndex = self.findRowIndex(startIdx: dayIdx, endIdx: dayIdx)
                let item = BZVMWeekRowHolidayItem(rowIndex: rowIndex, title:title, startIndex: dayIdx)
                dayData.add(item: item)
                dayData.addFantomSchedule(rowIdx: rowIndex)
            }
            if let dayStandardEventArray = standardEventsDict[dayIdx] {
                for event in dayStandardEventArray {
                    let rowIndex = self.findRowIndex(startIdx: dayIdx, endIdx: dayIdx)
                    let item = BZVMWeekRowDayItem(rowIndex:rowIndex, event:event, startIndex:dayIdx)
                    
                    dayData.add(item: item)
                    for idx in item.startDayIndex...item.endDayIndex {
                        let dayData = self.dayDataArray[idx]
                        dayData.addFantomSchedule(rowIdx: rowIndex)
                    }

                }
                

            }
        }
        
    }
    fileprivate func findRowIndex(startIdx:Int, endIdx:Int) -> Int {
        
        var tryIndex = self.dayDataArray[startIdx].nextFreeIndex()
        var found = false
        while found == false {
            found = true
            for idx in startIdx..<endIdx {
                let isFree = self.dayDataArray[idx].isFreeIndex(tryIndex)
                if isFree == false {
                    found = false
                    break
                }
            }
            if found == true {
                break
            }
            tryIndex += 1
        }
        return tryIndex

    }
    
    fileprivate func eventLengthInThisWV(event:EKEvent) -> Int {
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
                length = endComps.day! + 1
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
                if length < 0 {

                }
            } else {
                // つまり今週始まりの今週終わりのイベント
                let unitFlag : Set<Calendar.Component> = [ .day, .hour, .minute, .second ]
                let comp = appCalendar.dateComponents(unitFlag, from: event.startDate, to: event.endDate)

                length = comp.day!
                if comp.hour! > 0 || comp.minute! > 0 || comp.second! > 0 {
                    length += 1
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

extension MonthScheduleComponentWeekData {
    
    fileprivate func isLongEvent(event:EKEvent) -> Bool {
        
        let interval_sec = event.endDate.timeIntervalSince(event.startDate)
        
        let interval_day = interval_sec / (60.0*60.0*24.0)
        
        if interval_day > 1 {
            return true
        }
        
        return false
        
    }
    
}

