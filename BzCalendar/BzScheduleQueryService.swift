//
//  BzScheduleQueryService.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/26.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzScheduleQueryService: NSObject {

    static var shared : BzScheduleQueryService = BzScheduleQueryService()
    
    fileprivate override init() {
        super.init()
    }
    
    func daySchedule(targetDate date: Date) -> BzDayScheduleComponent {
        
        let component = DayScheduleComponent(date: date)
        
        // ToDo: キャッシュする。イベントストアから更新の通知を受け取った場合全てのキャッシュを無効化する
        // load data
        let fromTime = component.fromTime
        let toTime   = component.toTime
        
        //let calMgar = CalendarSettingManager.shared()! //BzCalendarSettingManager.shared
        let calMgar = BzCalendarSettingManager.shared

        let targetCals = calMgar.selectedEKCalendars()
        
        let events = AppEventKit.shared.events(from: fromTime, to: toTime, calendars: targetCals)
        if events.count > 0 {
            component.add(events: events)
        }

        let layoutMgr = CalendarManager.shared().basicSettingManager()!
        if layoutMgr.isRokuyoOn() == true {
            let rokuyoMgr : BZIFRokuyoReader =  BZIFRokuyoReader.shared
            component.rokuyoTitle = rokuyoMgr.rokuyoTitleAt(date: date)
        } else {
            component.rokuyoTitle = ""
        }

        return component
    }
    
    func weekSchedule(containsDate date: Date) -> BZVMWeeklyViewContents {
        
        let component = WeekScheduleComponent(containsDate: date)
        
        return component
    }
    
    func monthSchedule(containsDate date: Date) -> BZVMMonthlyViewContents {
        let component = MonthScheduleComponent(containsDate: date)
        
        return component
    }
}


