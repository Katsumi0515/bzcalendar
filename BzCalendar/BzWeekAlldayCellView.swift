//
//  BzWeekAlldayCellView.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/30.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzWeekAlldayCellView: UIView {

    fileprivate let ScheduleMarginX : CGFloat = 1.0
    fileprivate let ScheduleMarginY : CGFloat = 0.0
    
    fileprivate var scheduleViewArray : Array<UIView> = Array()
    fileprivate var usedIndexSet : Set<Int> = Set()
    fileprivate var scheduleHeight : CGFloat = 0
    
    // MARK: - インスタンス化
    override init(frame:CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.scheduleViewArray = Array()
        self.usedIndexSet = Set()
        self.scheduleHeight = WeekViewSettingManager.shared().heightForEventEntity()
    }
    func logicalHeight() -> CGFloat {
        return self.scheduleHeight + ScheduleMarginY
    }
    func add(event:EKEvent) {
        
        let rowIdx = self.nextIndex()
        
        let logicalHeight = self.logicalHeight()
        let tmpY : CGFloat = logicalHeight * CGFloat(rowIdx)
        
        var schedFrame = CGRect(x: ScheduleMarginX, y: tmpY, width: self.bounds.width, height: scheduleHeight - (ScheduleMarginY))
        let schedEnt = WVAllDayScheduleView(frame: schedFrame)
        schedEnt.clearColor = UIColor.white
        schedEnt.font = WeekViewSettingManager.shared().fontForEventEntity()
        schedEnt.verticalAlignment = VerticalAlignmentMiddle
        schedEnt.index = rowIdx
        schedEnt.text = event.title
        schedEnt.backgroundColor = event.bgColor()
        
        self.addSubview(schedEnt)
        self.scheduleViewArray.append(schedEnt)
        self.usedIndexSet.insert(rowIdx)
        
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension BzWeekAlldayCellView {
    fileprivate func nextIndex() -> Int {
        var found = false
        var searchIndex = 0
        
        while found == false {
            if self.usedIndexSet.contains(searchIndex) {
                searchIndex += 1
            } else {
                found = true
            }
        }
        return searchIndex
    }

}
