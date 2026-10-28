//
//  BzDateProtocol.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/06/06.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import Foundation

protocol BzDate {
    var date : Date { get }
    var weekday : Int! { get }
    
    var isHoliday : Bool { get }
    var holidayTitle: String? { get }
    var isCustomHoliday : Bool { get }
    
    func isSunday() -> Bool
    func isSaturday() -> Bool
    
    var rokuyoTitle : String? { get }
}
