//
//  BZVMRowItem.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/06/12.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit
import EventKit

class BZVMRowItem: NSObject {
    let event: EKEvent
    let startDayIndex: Int
    let endDayIndex: Int
    let isLongEvent: Bool
    
    var length : Int {
        get {
            return (self.endDayIndex - self.startDayIndex + 1)
        }
    }
    init(event:EKEvent, index:Int, length:Int = 1) {
        guard length > 0 else {
            fatalError("length must be more than 0")
        }
        self.event = event
        self.startDayIndex = index
        self.endDayIndex = index + length - 1
        self.isLongEvent = length > 1
        super.init()
    }
    private override init() {
        fatalError("init() not supported")
    }
}
