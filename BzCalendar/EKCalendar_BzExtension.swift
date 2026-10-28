//
//  File.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/03.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import Foundation
import EventKit

extension EKCalendar {
    
    func originalColor() -> UIColor {
        return UIColor(cgColor: self.cgColor)
    }
    
    func bgColor() -> UIColor {
        
        if let ext = BzEventExtensionService.shared().calendarExtension(calendar: self), let code = ext.bgColorCode {
            if let color = ColorUtil.shared.UIColorFromColorCode(code) {
                return color
            }
        }
        
        return UIColor(cgColor: self.cgColor)
        
        
    }
    
    func textColor() -> UIColor {
    
        if let ext = BzEventExtensionService.shared().calendarExtension(calendar: self), let code = ext.textColorCode {
            if let color = ColorUtil.shared.UIColorFromColorCode(code) {
                return color
            }
        }

        return UIColor.white
        
        
    }

    func defaultBgColor() -> UIColor {
        return UIColor(cgColor: self.cgColor)
    }
    
    func defaultTextColor() -> UIColor {
        return UIColor.white
    }
    
}
