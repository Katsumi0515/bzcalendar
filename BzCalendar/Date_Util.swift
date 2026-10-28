//
//  Date_Util.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/24.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import Foundation

extension Date {
    
    func dayCountInMonth() -> Int {
        if let range = NSCalendar.current.range(of: .day, in: .month, for: self) {
            return range.count
        }
        return 0
    }

}
