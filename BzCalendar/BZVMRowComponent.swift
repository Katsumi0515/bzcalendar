//
//  BZVMRowComponent.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/06/12.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BZVMRowComponent: NSObject {
    fileprivate var rowItems : Array<BZVMRowItem> = Array()
    var items : Array<BZVMRowItem> {
        get {
            return self.rowItems
        }
    }
    fileprivate var freeSpace : Set<Int> = Set()
    fileprivate let startDayIndex : Int
    fileprivate let endDayIndex : Int
    
    func hasFreeSpace(from:Int, length:Int = 1) -> Bool {
        let to : Int = from + length - 1
        for idx in from...to {
            if self.freeSpace.contains(idx) == false {
                return false
            }
        }
        return true
    }
    func canAddItem(_ item: BZVMRowItem) -> Bool {
        let length = item.endDayIndex - item.startDayIndex + 1
        if self.hasFreeSpace(from: item.startDayIndex, length:length) {
            return true
        }
        return false
    }
    func add(_ item: BZVMRowItem) {
        let from : Int = item.startDayIndex
        let to : Int = item.endDayIndex
        for idx in from...to {
            if let _ = self.freeSpace.remove(idx) {
                self.rowItems.append(item)
            } else {
                
            }
        }
    }
    override init() {
        self.startDayIndex = 0
        self.endDayIndex = 6
        self.freeSpace = Set()
        for idx in self.startDayIndex...self.endDayIndex {
            self.freeSpace.insert(idx)
        }
        super.init()
    }
}
