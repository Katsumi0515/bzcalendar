//
//  File.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/09.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import Foundation

extension EKAlarm {
    
    func stringValue() -> String {
        
        if let absoluteDate = self.absoluteDate {
            if let dateFormatter = CalendarManager.shared().dateFormatter_fullStyle() {
                return dateFormatter.string(from: absoluteDate)
            } else {
                return ""
            }
        }
        
        let interval = self.relativeOffset
        if interval == 0  {
            return NSLocalizedString("Common_Event_Alarm_OnEventTime", comment:"同日時")
        }
        let isAfter : Bool = (interval >= 0)

        var str : String = ""
        
        var remain : Int = abs(Int(interval))

        let dayInt  : Int = (remain/(60*60*24))
        remain = (remain % (60*60*24))
        let hourInt : Int = (remain/(60*60))
        remain = (remain % (60*60))

        let minInt  : Int = (remain / 60)
        
    
    
        if dayInt > 0 {
            let dayStr = NSLocalizedString("Common_Event_EKAlarm_Days", comment:"日")
            str = str.appendingFormat("%d%@", dayInt, dayStr)
        }
        if hourInt > 0 {
            let hourStr = NSLocalizedString("Common_Event_EKAlarm_Hours", comment:"時間")
            str = str.appendingFormat("%d%@", hourInt, hourStr)
        }
        if minInt > 0 {
            let minStr = NSLocalizedString("Common_Event_EKAlarm_Minutes", comment:"分")
            str = str.appendingFormat("%d%@", minInt, minStr)
        }
    
        if isAfter == true {
            str = str.appending( NSLocalizedString("Common_Event_EKAlarm_After", comment:"後") )
        } else {
            str = str.appending( NSLocalizedString("Common_Event_EKAlarm_Before", comment:"前") )
        }
    
        return str
    }
    

}
