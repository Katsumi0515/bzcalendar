//
//  BzWeekAlldayRowView.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/06/13.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit


class BzWeekAlldayRowView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
  
    var rowComponent : BZVMRowComponent? = nil {
        didSet {
            if let rowComponent = rowComponent {
                for item in rowComponent.items {
                    self.add(rowItem: item)
                }
                
            }
            self.setNeedsLayout()
        }
    }
    
    fileprivate func add(rowItem: BZVMRowItem) {
        let contentWidth = self.frame.width
        let oneDayWidth = contentWidth / CGFloat(7)
        let marginX : CGFloat = 1
        let marginY : CGFloat = 0.5

        let startDayIndex = rowItem.startDayIndex
        let tmpOriginX = oneDayWidth * CGFloat(startDayIndex) + marginX // +マージン
        let event = rowItem.event
        if rowItem.isLongEvent == true {
            let tmpWidth = oneDayWidth * CGFloat(rowItem.length) - (marginX * 2)

            let rect = CGRect(x: tmpOriginX, y: marginY, width: tmpWidth, height: (self.frame.height - marginY))
            
            let entity = BzWVLongScheduleView(frame:rect)
            entity.font = WeekViewSettingManager.shared().fontForEventEntity()
            entity.text = event.title
            entity.backgroundColor = event.bgColor()
            entity.textColor = event.textColor()
            
            self.addSubview(entity)
            
        } else {
            let tmpWidth = oneDayWidth - (marginX * 2)

            let rect = CGRect(x: tmpOriginX, y: marginY, width: tmpWidth, height: (self.frame.height - marginY))
            
            let entity = BzWVLongScheduleView(frame:rect)
            entity.font = WeekViewSettingManager.shared().fontForEventEntity()
            entity.text = event.title
            entity.backgroundColor = event.bgColor()
            entity.textColor = event.textColor()
            
            self.addSubview(entity)

        }

    }
    override func layoutSubviews() {
        
    }
    
    //
    //    func add(event:EKEvent, viewIndex:Int) {
    //        let cellView = self.cellView(index: viewIndex) // WeekAlldayCellView
    //        cellView.add(event)
    //    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */

}
