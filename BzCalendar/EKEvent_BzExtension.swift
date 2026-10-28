//
//  File.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/03.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import Foundation
import EventKit

@objc extension EKEvent {

    func bgColor() -> UIColor {
    
        if let ext = BzEventExtensionService.shared().eventExtension(event: self), let code = ext.bgColorCode {
            if let color = ColorUtil.shared.UIColorFromColorCode(code) {
                return color
            }
        }
        return self.calendar.bgColor()
    }
    
    func textColor() -> UIColor {
        if let textColorCode = BzEventExtensionService.shared().eventExtension(event: self)?.textColorCode,
            textColorCode.isEmpty == false {
            if let rtnVal = ColorUtil.shared.UIColorFromColorCode(textColorCode) {
                return rtnVal
            }
        }
        return self.calendar.textColor()
    }

}
