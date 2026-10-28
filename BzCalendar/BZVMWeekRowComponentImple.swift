//
//  BZVMWeekRowDayComponent.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/06/22.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import Foundation

class MonthScheduleComponentDayData: NSObject, BZVMWeekRowDayComponent {
    
    var date : Date = Date()
    var weekday : Int!
    var isHoliday : Bool = false
    var holidayTitle: String? = nil
    var isCustomHoliday: Bool = false
    var rokuyoTitle: String? = nil
    
    var isThisMonth: Bool = false
    var isSelectedDate: Bool = false
    
    fileprivate var _dayItems : Array<BZVMWeekRowItem> = Array()

    //fileprivate var _events : Array<EKEvent> = Array()
    
    fileprivate var freeIndexLB : Int = 0
    fileprivate var rowSet: Set<Int> = Set()
    
    func clearData() {
        self.freeIndexLB = 0
        self.rowSet.removeAll()
        self._dayItems.removeAll()
       // self._events.removeAll()
    }
    
    func isSunday() -> Bool {
        return self.weekday == 1 // グレゴリアン
    }
    func isSaturday() -> Bool {
        return self.weekday == 7 // グレゴリアン
    }
    
    func isFreeIndex(_ index: Int) -> Bool {
        return ( self.rowSet.contains(index) == false )
    }
    func nextFreeIndex() -> Int {
        var found = false
        
        var searchIndex: Int = self.freeIndexLB
        while found == false {
            if self.isFreeIndex(searchIndex) == false {
                
                searchIndex += 1
                self.freeIndexLB = searchIndex
                if searchIndex > 200  {
                    //print("self.scheduleViewArray.count: %d", self.scheduleViewArray.count)
                }
            } else {
                found = true
            }
        }
        if found == true {
            self.freeIndexLB = searchIndex + 1
        }
        return searchIndex
        
    }
    func addFantomSchedule(rowIdx:Int) {
        if self.rowSet.contains(rowIdx) {
            fatalError()
        }
        self.rowSet.insert(rowIdx)
    }
    func dayItems() -> Array<BZVMWeekRowItem> {
        return self._dayItems
    }
    func add(item:BZVMWeekRowItem) {
        self._dayItems.append(item)
    }
//    // ロングイベント以外のイベント
//    // この日で完結するイベント。終日イベントかつ１日間のものは、ここのeventsに入っている
//    func events() -> Array<EKEvent> {
//        return self._events
//    }
//
//    func add(event:EKEvent) {
//        self._events.append(event)
//    }
    
    init(date: Date, isThisMonth:Bool = false) {
        self.date = date
        self.isThisMonth = isThisMonth
        self._dayItems = Array()
        
        let appCalendar = CalendarManager.shared().appCalendar()!
        let comps = appCalendar.dateComponents([.weekday], from: date)
        self.weekday = comps.weekday!
        
        let holidayManager = WorldCalendarManager.shared
        if let title = holidayManager.holidayTitle(at: date), title.isEmpty == false {
            self.isHoliday = true
            self.holidayTitle = title
        }
        
        super.init()
        
    }
    private override init() {
        fatalError("init() is not to be used")
    }
    
    
}

