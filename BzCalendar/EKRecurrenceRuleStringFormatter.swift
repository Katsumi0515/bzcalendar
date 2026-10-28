//
//  EKRecurrenceRuleString.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/15.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import Foundation

class EKRecurrenceRuleStringFormatter {
    fileprivate var weekdayStringList : Array<String> = Array()
    fileprivate var weekNumStringList : Array<String> = Array()
    
    init() {
        if let array = CalendarManager.shared().weekdaySymbols() {
            for idx in 0..<array.count {
                if let item = array[idx] as? String {
                    self.weekdayStringList.append(item)
                }
            }
        }
        self.weekNumStringList = [
            NSLocalizedString("Common_Event_RecurrenceDateByWeekday_First", comment:"第１"),
            NSLocalizedString("Common_Event_RecurrenceDateByWeekday_Second", comment:"第２"),
            NSLocalizedString("Common_Event_RecurrenceDateByWeekday_Third", comment:"第３"),
            NSLocalizedString("Common_Event_RecurrenceDateByWeekday_Fourth", comment:"第４"),
            NSLocalizedString("Common_Event_RecurrenceDateByWeekday_Last", comment:"最終")
        ]
    }
    
    func string(recurrenceRules : [Any]?) -> String {
        if let recurrenceRules = recurrenceRules as? [EKRecurrenceRule] {
            return self.string(recurrenceRules: recurrenceRules)
        } else {
            return NSLocalizedString("Common_Event_RecurrenceRule_None", comment:"なし");
        }
    }
    func string(recurrenceRules : [EKRecurrenceRule]?) -> String {
        if let recurrenceRules = recurrenceRules, let recurrenceRule = recurrenceRules.first {
            return self.string(recurrenceRule: recurrenceRule)
        } else {
            return NSLocalizedString("Common_Event_RecurrenceRule_None", comment:"なし")
        }
    }
    func string(recurrenceRule: EKRecurrenceRule?) -> String {
        
        guard let recurrenceRule = recurrenceRule else {
            return NSLocalizedString("Common_Event_RecurrenceRule_None", comment:"なし")
        }
        var str = ""
        switch (recurrenceRule.frequency) {
        case .daily:
            if recurrenceRule.interval == 1 {
                str = NSLocalizedString("Common_ExactWord_EveryDay", comment:"毎日")
            } else {
                str = str.appendingFormat("%d", recurrenceRule.interval)
                str = str.appending(NSLocalizedString("Common_Event_Recurrence_ByDayInterval", comment:"日ごと"))
                //str = [str stringByAppendingString:@" "];
            }
        case .weekly:
            if recurrenceRule.interval == 1 {
                str = NSLocalizedString("Common_ExactWord_EveryWeek", comment:"毎週")
            } else {
                str = str.appendingFormat("%d", recurrenceRule.interval)
                str = str.appending(NSLocalizedString("Common_Event_Recurrence_ByWeekInterval", comment:"週ごと"))
                if let daysOfTheWeek = recurrenceRule.daysOfTheWeek, daysOfTheWeek.count > 0 {
                    str = str.appending(" ")
                    let dayOfWeek : EKRecurrenceDayOfWeek = daysOfTheWeek[0]
                    let weekdayIdx = dayOfWeek.dayOfTheWeek.rawValue - 1
                    str = str.appending( self.weekdayStringList[weekdayIdx] )
                }
            }
        case .monthly:
            if recurrenceRule.interval == 1  {
                str = NSLocalizedString("Common_ExactWord_EveryMonth", comment:"毎月")
            } else {
                str = str.appendingFormat("%d", recurrenceRule.interval)
                str = str.appending(NSLocalizedString("Common_Event_Recurrence_ByMonthInterval", comment:"ヶ月ごと"))
                
                if let daysOfTheWeek = recurrenceRule.daysOfTheWeek, daysOfTheWeek.count > 0 {
                    //str = [str stringByAppendingString:@" "];
                    str = str.appending(" ")
                    let dayOfWeek = daysOfTheWeek[0] //EKRecurrenceDayOfWeek
                    let weekNum = dayOfWeek.weekNumber
                    let weekday = dayOfWeek.dayOfTheWeek.rawValue
                    let weekdayIdx = weekday - 1
                    var weekNumIdx : Int = 0
                    
                    if( weekNum == 0 ) {
                        weekNumIdx = 4
                    } else {
                        weekNumIdx = weekNum - 1
                    }
                    str = str.appending(self.weekNumStringList[weekNumIdx])
                    str = str.appending(self.weekdayStringList[weekdayIdx])
                }
            }
            if let daysOfTheMonth = recurrenceRule.daysOfTheMonth, daysOfTheMonth.count > 0 {
                let dayNum = daysOfTheMonth[0]
                if dayNum.intValue == -1 {
                    str = str.appending(NSLocalizedString("Common_ExactWord_EndOfMonth", comment:"月末"))
                } else {
                    str = str.appendingFormat("%d", dayNum.intValue)
                    str = str.appending(NSLocalizedString("Common_Event_Recurrence_Day", comment:"日"))
                }
                for idx in 1..<daysOfTheMonth.count {
                    let dayNum = daysOfTheMonth[idx]
                    if dayNum.intValue == -1 {
                        str = str.appendingFormat(", %@", NSLocalizedString("Common_ExactWord_EndOfMonth", comment:"月末"))
                    } else {
                        str = str.appendingFormat(", %d", dayNum.intValue)
                        str = str.appending(NSLocalizedString("Common_Event_Recurrence_Day", comment:"日"))
                    }
                }
            } else if let daysOfTheWeek = recurrenceRule.daysOfTheWeek, daysOfTheWeek.count > 0 {
                let dayOfWeek : EKRecurrenceDayOfWeek = daysOfTheWeek[0]
                let weekNum = dayOfWeek.weekNumber
                let weekday = dayOfWeek.dayOfTheWeek.rawValue
                var weekNumIdx : Int = 0
                let weekdayIdx = weekday - 1
                if( weekNum == -1 ) {
                    weekNumIdx = 4;
                } else {
                    weekNumIdx = weekNum - 1
                }
                str = str.appending(self.weekNumStringList[weekNumIdx])
                str = str.appending(self.weekdayStringList[weekdayIdx])
            }
        case .yearly:
            if recurrenceRule.interval == 1  {
                str = NSLocalizedString("Common_ExactWord_EveryYear", comment:"毎年")
            } else {
                str = ""
            }
        }
        return str
        
    }

}
