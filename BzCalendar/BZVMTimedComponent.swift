//
//  BVVMTimedComponent.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/06/12.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit
import EventKit

class BZVMTimedComponent: NSObject {
    fileprivate var startDate: Date
    fileprivate var endDate: Date
    fileprivate var ekEvents : Array<EKEvent> = Array()

    var from : Date {
        get {
            return self.startDate
        }
    }
    var to : Date {
        get {
            return self.endDate
        }
    }
    
    var events : Array<EKEvent> {
        get {
            return self.ekEvents
        }
    }
    
    // MARK: - インスタンス
    init(event:EKEvent) {
        self.startDate = event.startDate
        self.endDate = event.endDate
        self.ekEvents = Array()
        self.ekEvents.append(event)
        super.init()
    }
    
    private override init() {
        fatalError("use init(fromDate:toDate)")
    }
    
    // MARK: -
    func isEventTimeOverlap(event:EKEvent) -> Bool {
        // 1) event.startDate >= self.endDate
        //  普通の人は時間が重複する予定はあまり保持していない。
        //  startDateでソートされたEKEventを順次に処理している場合、通常は1)にあてはまる
        if event.startDate.compare(self.endDate) != .orderedAscending {
            return false
        }
        // 2) self.startDate <= event.startDate ( 1のelseなので event.startDate < self.endDate  )
        if event.startDate.compare(self.startDate) != .orderedAscending {
            return true
        }
        // この時点で、event.startDate < self.startDateなのでevent.startDateでの判断はできない
        //  startDateでソートされたEKEventを順次に処理している場合、ここに来ることはない

        // 3) event.endDate <= self.startDate
        if event.endDate.compare(self.startDate) != .orderedDescending {
            return false
        }
        // ここにくると、event.startDate < self.startDate && self.startDate < event.endDate
        // event.endDateが、self.endDateと比較した値に関わらず、オーバラップする
        return true
    }
    
    func add(event:EKEvent, allowsChangeFromDate : Bool = false)  {
        self.ekEvents.append(event)
        
        if event.endDate.compare(self.endDate) == .orderedDescending {
            self.endDate = event.endDate
        }
        if event.startDate.compare(self.startDate) == .orderedAscending {
            if allowsChangeFromDate == true {
                self.startDate = event.startDate
            } 
        }
    }
    
}
