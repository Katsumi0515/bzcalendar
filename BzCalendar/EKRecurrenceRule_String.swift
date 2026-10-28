//
//  File.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/09.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import Foundation

extension EKRecurrenceRule {
   

//    func daysStringValue() -> String {
//        var str : String = ""
//        
//        // ToDo: あちこちのクラスにある同じ週指定の文言を１クラスに集約したい
//        
//        let weekNumStringList : Array<String> = [
//            NSLocalizedString("Common_Event_RecurrenceDateByWeekday_First", comment:"第１"),
//            NSLocalizedString("Common_Event_RecurrenceDateByWeekday_Second", comment:"第２"),
//            NSLocalizedString("Common_Event_RecurrenceDateByWeekday_Third", comment:"第３"),
//            NSLocalizedString("Common_Event_RecurrenceDateByWeekday_Fourth", comment:"第４"),
//            NSLocalizedString("Common_Event_RecurrenceDateByWeekday_Last", comment:"最終")
//        ]
//        
//        let weekdayStringList = CalendarManager.shared().weekdaySymbols()!
//        
//        switch (self.frequency) {
//        case .daily:
//            break
//        case .weekly:
//            if let daysOfTheWeek = self.daysOfTheWeek {
//                for dayOfWeek in daysOfTheWeek {
//                    let weekdayRow = dayOfWeek.dayOfTheWeek.rawValue - 1
//                    if let weekdayStr = weekdayStringList[weekdayRow] as? String {
//                        str = str.appendingFormat("%@ ", weekdayStr)
//                    }
//
//                }
//            }
//            break
//        case .monthly:
//            if let daysOfTheMonth = self.daysOfTheMonth {
//                if daysOfTheMonth.count > 0 {
//                    let day = daysOfTheMonth.first!
//                    if day.intValue == -1 {
//                        str = NSLocalizedString("Common_ExactWord_EndOfMonth", comment:"月末")
//                    } else {
//                        str = day.stringValue
//                        for i in 1..<daysOfTheMonth.count {
//                            let num = daysOfTheMonth[i]
//                            str = str.appending(",")
//                            str = str.appending(num.stringValue)
//                            
//                        }
//                        
//                    }
//                }
//            } else if let daysOfTheWeek = self.daysOfTheWeek, let dayOfWeek = daysOfTheWeek.first {
//
//                var weekNumRow = dayOfWeek.weekNumber - 1
//                let weekdayRow = dayOfWeek.dayOfTheWeek.rawValue - 1
//            
//                if weekNumRow == -1  {
//                    weekNumRow = 4
//                }
//                str = weekNumStringList[weekNumRow]
//                if let weekdayStr = weekdayStringList[weekdayRow] as? String {
//                    str = str.appending(weekdayStr)
//                }
//            
//            }
//            break;
//            
//        case .yearly:
//            break;
//        default:
//            break;
//        }
//        
//        return str;
//    } // daysStringValue()
}
