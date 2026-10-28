//
//  File.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/06/22.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import Foundation

protocol BZVMWeeklyViewDayContents: BzDate {
    
    var isSelectedDate: Bool { get }
    var eventComponents : Array<BZVMTimedComponent> { get }
    
}
