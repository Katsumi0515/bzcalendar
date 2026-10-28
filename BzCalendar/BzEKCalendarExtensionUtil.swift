//
//  File.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/03.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import Foundation

class BzEKCalendarExtensionUtil : NSObject {
    class func calendarBgColorOf(calendar:EKCalendar) -> UIColor {

        if let code = BzEventExtensionService.shared().calendarExtension(calendar: calendar)?.bgColorCode {
            return ColorUtil.shared.UIColorFromColorCode(code)!
        } else {
            return UIColor(cgColor: calendar.cgColor)
        }
    }

    class func calendarTextColorOf(calendar:EKCalendar) -> UIColor {
    
        if let code = BzEventExtensionService.shared().calendarExtension(calendar: calendar)?.textColorCode {
            return ColorUtil.shared.UIColorFromColorCode(code)!
        } else {
            return UIColor.white
        }
    }

    class func calendarDefaultBgColor(calendar:EKCalendar) -> UIColor {
        return UIColor(cgColor: calendar.cgColor)
    }
    
    class func calendarDefaultTextColor(calendar:EKCalendar) -> UIColor {
        return UIColor.white
    }

}
