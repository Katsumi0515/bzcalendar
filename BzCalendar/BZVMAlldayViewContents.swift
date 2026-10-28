//
//  BZVMAlldayViewContents.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/06/12.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit
import EventKit

class BZVMAlldayViewContents: NSObject {
    fileprivate var rows : Array<BZVMRowComponent> = Array()
    var alldayRows : Array<BZVMRowComponent> {
        return self.rows
    }
    fileprivate var maxRowsLimite : Int = 0 // 0 : no limit
    var rowCount : Int {
        get {
            return rows.count
        }
    }
    func add(event:EKEvent, index:Int, length:Int = 1) {

        let item = BZVMRowItem(event: event, index: index, length:length)
        for alldayRow in self.rows {
            if alldayRow.canAddItem(item) == true {
                alldayRow.add(item)
                return
            }
        }
        
        let rowComponent = BZVMRowComponent()
        rowComponent.add(item)
        self.rows.append(rowComponent)
    }
}
