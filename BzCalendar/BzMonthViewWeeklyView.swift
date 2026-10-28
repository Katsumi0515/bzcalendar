//
//  BzMonthViewWeeklyView.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/06/08.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

fileprivate extension Date {
    
    func isToday() -> Bool {
        let unit : Set<Calendar.Component> = [.year, .month, .day ]
        let appCalendar = CalendarManager.shared().appCalendar()!
        let compToday = appCalendar.dateComponents(unit, from: Date())
        let comp = appCalendar.dateComponents(unit, from: self)
        
        return compToday.day! == comp.day! && compToday.month! == comp.month! && compToday.year! == comp.year!
    }
}

class BzMonthViewWeeklyView: UIView {

    fileprivate let longEventMarginX : CGFloat = 1
    fileprivate let longEventMarginY : CGFloat = 0.1

    var selectedDateDelegate: BzMonthViewSelectedDateChangeDelegate? = nil
    
    fileprivate var longEventViews : Array<UIView> = Array()
    fileprivate var dayCellViews : Array<DayCellView> = Array()
    
    // MARK: - インスタンス化
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        var frame = self.bounds
        let width = frame.width / CGFloat(7)
        frame.size.width = width
        self.dayCellViews = Array()
        for idx in 0..<7 {
            frame.origin.x = width * CGFloat(idx)
            let dayCellView = DayCellView(frame: frame)
            self.addSubview(dayCellView)
            self.dayCellViews.append(dayCellView)
        }
        
        let singleTapRec = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        singleTapRec.numberOfTapsRequired = 1
        self.addGestureRecognizer(singleTapRec)
        
        let doubleTapRec = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapRec.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapRec)

    }
    
    fileprivate var weekData : BZVMWeekRowComponent! // = nil
    
    func setWeekData(data:BZVMWeekRowComponent) {
        var needToUpdate = false
        if let weekData = self.weekData {
            needToUpdate = weekData.fromDate.compare(data.fromDate) != .orderedSame
        }
        self.weekData = data
        if needToUpdate {
            self.setNeedsLayout()
        }
    }
    
    
    // ToDo: 論理描画位置はlayoutSubviewsより前に決定しておく
    //  ロングイベントを始め、描画のための位置（それぞれの週のどの日のどのRowから描画するのか）
    //  DayCellViewのswift化と合わせてリファクタリングか？
    // ToDo:    パフォーマンスチューニング
    // UIパーツの生成は、setDateの時にしてしまい、
    // layoutSubviewsでは位置の調整のみ行うようにする
    override func layoutSubviews() {
        print("BzMonthViewWeeklyView.layoutSubviews: ", self)
        
        super.layoutSubviews()
        
        
        var isRokuyoOn = false

        if let basicMgr = CalendarManager.shared().basicSettingManager() {
            isRokuyoOn = basicMgr.isRokuyoOn()
        }

        for vv in self.longEventViews {
            if vv.superview != nil {
                vv.removeFromSuperview()
            }
        }
        self.longEventViews.removeAll()
        for idx in 0..<7 {
            let dayCellView = self.dayCellViews[idx]
            dayCellView.clear() // clearView
        }
        if self.weekData == nil {
            return
        }
        var frame = self.bounds
        let width = frame.width / CGFloat(7)
        frame.size.width = width

        for idx in 0..<7 {
            let dayCellView = self.dayCellViews[idx]

            let dayData = self.weekData.dayData(index: idx)
            
            dayCellView.date = dayData.date

            frame.origin.x = width * CGFloat(idx)
            dayCellView.frame = frame
            
            dayCellView.setOptionText("")
            if isRokuyoOn {
                if let rokuyoTitle = dayData.rokuyoTitle {
                    dayCellView.setOptionText(rokuyoTitle)
                }
            }
            dayCellView.setDisabled( (dayData.isThisMonth == false) )
            
            if dayData.isThisMonth == true {
                
                if dayData.isSunday() {
                    if let colorCode = CalendarManager.shared().appSettingColorManager().sunday() {
                        let color = ColorUtil.shared.UIColorFromColorCode(colorCode)
                        dayCellView.backgroundColor = color
                    }
                } else if dayData.isSaturday() {
                    if let colorCode = CalendarManager.shared().appSettingColorManager().saturday() {
                        let color = ColorUtil.shared.UIColorFromColorCode(colorCode)
                        dayCellView.backgroundColor = color
                    }
                    
                }
                if dayData.isHoliday {
                    if let colorCode = CalendarManager.shared().appSettingColorManager().holiday() {
                        let color = ColorUtil.shared.UIColorFromColorCode(colorCode)
                        dayCellView.backgroundColor = color
                    }
                }
                if dayData.isCustomHoliday {
                    if let colorCode = CalendarManager.shared().appSettingColorManager().nonWork() {
                        let color = ColorUtil.shared.UIColorFromColorCode(colorCode)
                        dayCellView.backgroundColor = color
                    }
                    
                }
                // 本日の場合の色
                if dayData.date.isToday() {
                    if let colorCode = CalendarManager.shared().appSettingColorManager().today() {
                        let color = ColorUtil.shared.UIColorFromColorCode(colorCode)
                        dayCellView.backgroundColor = color
                    }
                }
                // 選択日の場合の色
                
                if dayData.isSelectedDate == true {
                    if let colorCode = CalendarManager.shared().appSettingColorManager().selected() {
                        let color = ColorUtil.shared.UIColorFromColorCode(colorCode)
                        dayCellView.backgroundColor = color
                    }
                }
            
            }
            for item in dayData.dayItems() {
                if let dayItem = item as? BZVMWeekRowDayItem {
                    if dayItem.isLongEvent {
                        self._addLongEventView(rowItem: dayItem)
                    } else {
                        dayCellView.add(dayItem)
                    }
                } else if let holidayItem = item as? BZVMWeekRowHolidayItem {
                    dayCellView.addHolidayEntity(holidayItem.title(), rowIndex:holidayItem.rowIndex)
                }
            }

            dayCellView.showShedules()
            dayCellView.setNeedsLayout()
        }
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    fileprivate func _addLongEventView(rowItem:BZVMWeekRowDayItem) {
        
        let rowIdx = rowItem.rowIndex
        
        let cellView = self.dayCellViews[rowItem.startDayIndex]
        let cellWidth = self.bounds.width / CGFloat(7)
        
        let width = cellWidth * CGFloat(rowItem.daysInThisWeek) - (self.longEventMarginX * CGFloat(2))
        
        let originX = cellView.frame.origin.x + self.longEventMarginX
        
        let originY = cellView.originY(forRowIndex: rowIdx) + self.longEventMarginY
        let height = MonthViewSettingManager.shared().heightForEventEntity() - (self.longEventMarginY)
        
        let frame = CGRect(x: originX, y: originY, width: width, height: height)
        
        let entity = BzMVLongScheduleView(frame: frame)
        
        entity.font = MonthViewSettingManager.shared().fontForEventEntity()
        entity.text = rowItem.event.title
        entity.textColor = rowItem.event.textColor()
        entity.backgroundColor = rowItem.event.bgColor()
        
        self.longEventViews.append(entity)
                
        self.addSubview(entity)
        
    }

}

// MARK: - ジェルチャーのハンドリング
extension BzMonthViewWeeklyView {
    
    fileprivate func _dayDataSelectedByTapGestureRecognizer(gesture:UITapGestureRecognizer) -> BZVMWeekRowDayComponent? {
    
        let point = gesture.location(in: self)
        if point.y < 0 {
            return nil
        }
        if point.y > self.bounds.height {
            return nil
        }
        
        let dayWidth = (self.frame.width) / CGFloat(7)
        let idx = Int((point.x) / dayWidth)
        
        let dayData = self.weekData.dayData(index: idx)

        return dayData
    }
    
    @objc fileprivate func handleSingleTap(gesture:UITapGestureRecognizer) {
        if let dayData = self._dayDataSelectedByTapGestureRecognizer(gesture: gesture) {
            if dayData.isThisMonth {
                if let delegate = self.selectedDateDelegate {
                    delegate.selected(date: dayData.date)
                }
            } else {
                // 前月か来月に移動？
                if let delegate = self.selectedDateDelegate {
                    delegate.selected(date: dayData.date)
                }

            }
        }
    }
    
    @objc fileprivate func handleDoubleTap(gesture:UITapGestureRecognizer) {
        if let dayData = self._dayDataSelectedByTapGestureRecognizer(gesture: gesture) {
            CalendarManager.shared().selectedDate = dayData.date
            
//            let note = Notification.Name(rawValue: "BzWeekViewSelectedDateChanged")
//            NotificationCenter.default.post(name: note, object: nil)
            
            if let appDelegate = UIApplication.shared.delegate as? BzAppDelegate {
                appDelegate.topViewControllerDelegate().select(AppCalendarDisplayModeDaily)
            }
        }
    }

}

