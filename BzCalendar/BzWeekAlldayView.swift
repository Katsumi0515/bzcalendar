//
//  BzWeekAlldayView.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/29.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzWeekAlldayView: UIStackView {


    //@IBOutlet weak internal var contentStackView: UIStackView!
    @IBOutlet weak internal var contentView: UIView!


   // fileprivate var rowCount : Int = 7
    fileprivate var dayCount : Int = 7
    fileprivate var rowSpace : CGFloat = 0  // 0  現時点ではスケジュールラベルの描画の方でYマージンが入るようにしている。
    fileprivate var rowHeight : CGFloat
    fileprivate var scheduleHeight: CGFloat
    fileprivate var alldayContents : BZVMAlldayViewContents? = nil
    
    fileprivate var alldayRowViewArray : Array<BzWeekAlldayRowView> = Array()
    
    required init(coder: NSCoder) {
        self.rowHeight = WeekViewSettingManager.shared().heightForEventEntity()
        self.scheduleHeight = WeekViewSettingManager.shared().heightForEventEntity()
        super.init(coder: coder)
        self.backgroundColor = .clear
    }
    override init(frame: CGRect) {
        fatalError("init(coder...from strobyboard should be used")
        //super.init(frame: frame)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func add(alldayContents:BZVMAlldayViewContents) {
        self.alldayContents = alldayContents
        
        // ToDo: 再利用
        for sub in self.alldayRowViewArray {
            if sub.superview != nil {
                sub.removeFromSuperview()
            }
        }
        self.alldayRowViewArray.removeAll()
        
        let alldayRows = alldayContents.alldayRows
        
        for alldayRow in alldayRows {
            // 1行生成
            let count = self.alldayRowViewArray.count
            
            let contentWidth = self.frame.size.width - self.contentView.frame.origin.x

            let rect = CGRect(x: 0, y: self.rowHeight * CGFloat(count), width: contentWidth, height: self.rowHeight)
            let rowView = BzWeekAlldayRowView(frame: rect)
            // その行にイベントビューの追加
            
            rowView.rowComponent = alldayRow
            self.contentView.addSubview(rowView)
            self.alldayRowViewArray.append(rowView)
//            switch count {
//            case 0:
//                rowView.backgroundColor = UIColor.red
//            case 1:
//                rowView.backgroundColor = UIColor.yellow
//            default:
//                rowView.backgroundColor = UIColor.green
//            }
            //self.contentStackView.insertArrangedSubview(rowView, at: self.contentStackView.arrangedSubviews.count)
        }
        
        
    }
    func clearAllScheduleViews() {
        
        
//        for view in self.longScheduleArray {
//            view.removeFromSuperview()
//        }
//        self.longScheduleArray.removeAll()
    }
    
    override func layoutSubviews() {
        
        print("BzWeekAlldayView frame; ", self.frame)
        
        self.rowHeight = WeekViewSettingManager.shared().heightForEventEntity() - self.rowSpace
        
        self.scheduleHeight = WeekViewSettingManager.shared().heightForEventEntity()
        
        let contentWidth = self.frame.size.width - self.contentView.frame.origin.x
        
        let scheduleViewWidth = contentWidth / CGFloat(7)

        
//        for entity in self.longScheduleArray {
//            let tmpWidth = scheduleViewWidth * CGFloat(entity.daysCount) // - (xMargin * 2);
//
//            let rowIndex = entity.index
//            var rect = entity.frame
//            rect.origin.y = self.scheduleHeight * CGFloat(rowIndex)
//            rect.size.height = self.scheduleHeight
//            rect.size.width = tmpWidth
//            entity.frame = rect
//
//            entity.font = WeekViewSettingManager.shared().fontForEventEntity()
//            entity.setNeedsLayout()
//        }
        
        var idx : Int = 0
        for alldayRowView in self.alldayRowViewArray {
            var rect = alldayRowView.frame
            rect.origin.x = 0
            rect.origin.y = (self.rowHeight + self.rowSpace) * CGFloat(idx)
            rect.size.width = contentWidth
            rect.size.height = self.rowHeight
            alldayRowView.frame = rect
            alldayRowView.setNeedsLayout()
            idx += 1
        }

    }
    
    func suggestedAlldayViewHeight() -> CGFloat {
        guard let alldayContents = self.alldayContents else {
            return self.scheduleHeight * CGFloat(1)
        }
        let count = alldayContents.rowCount > 0 ? alldayContents.rowCount : 1
        return self.scheduleHeight * CGFloat(count) + CGFloat(1)
    }
}


