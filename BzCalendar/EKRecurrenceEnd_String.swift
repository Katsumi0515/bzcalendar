//
//  File.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/09.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import Foundation

extension EKRecurrenceEnd {
    
    func stringValue() -> String {
        var str : String = ""
        
        if let endDate = self.endDate {
            if let dateFormatter = CalendarManager.shared().dateFormatter_fullStyle() {
                str = dateFormatter.string(from: endDate)
            }
        } else {
            str = str.appendingFormat("%d%@", self.occurrenceCount, NSLocalizedString("SelectRecurrenceEnd_Times", comment:"回"))
        }
        return str
    }

}
