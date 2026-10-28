//
//  BzWeekScheduleComponentLongEvent.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/06/07.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit
import EventKit

protocol BzWeekScheduleComponentLongEvent {
    var event : EKEvent { get }

    var startIndex      : Int { get }
    var endIndex        : Int { get }
    var daysInThisWeek  : Int { get }
}


// BzWeekScheduleComponentLongEventの実装
class WeekScheduleComponentLongEvent : NSObject, BzWeekScheduleComponentLongEvent {
    var startIndex: Int
    var event: EKEvent
    var daysInThisWeek : Int
    var endIndex: Int
    
    init(event:EKEvent, startIndex:Int, daysInThisWeek:Int) {
        self.startIndex = startIndex
        self.event = event
        self.daysInThisWeek = daysInThisWeek
        if daysInThisWeek > 0 {
            self.endIndex = startIndex + daysInThisWeek - 1
            if self.endIndex > 6 {
                self.endIndex = 6
            }
        } else {
            self.endIndex = startIndex
        }
        super.init()
    }
    private override init() {
        fatalError()
    }
}

