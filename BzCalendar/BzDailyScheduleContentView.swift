//
//  BzDailyScheduleContentView.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/06/01.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzDailyScheduleContentView: UIView {

    fileprivate let minimalDulationTimeInHour : CGFloat = 0.25
    
    fileprivate var targetDate : Date = Date()
    
    func setDate(date:Date) {
        self.targetDate = date
    }
    @IBOutlet weak internal var topMarginView : UIView!
    @IBOutlet weak internal var bottomMarginView : UIView!
    @IBOutlet weak internal var scaleView : ScheduleScaleView!
    @IBOutlet weak internal var timeView : TimeScaleView!
    
    fileprivate var oneHourHeight : CGFloat = 0
    fileprivate var xOffset : CGFloat = 45
    fileprivate var nonActiveColor : UIColor = UIColor.lightGray
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    fileprivate let kTopMargin : CGFloat = 5

    var displaySize: CGSize = CGSize(width: 0, height: 0)
    
    fileprivate var currentStartFloat : CGFloat = -1
    fileprivate var currentEndFloat : CGFloat = 0
    
    fileprivate var scheduleViewArray : Array<DayViewScheduleView> = Array()
    
    func clearSchedules() {
    
        for  view in self.scheduleViewArray {
            if let _ = view.superview {
                view.removeFromSuperview()
            }
        }
        self.scheduleViewArray.removeAll()
        self.currentStartFloat = -1.0
        self.currentEndFloat = 0.0
    }

    override init(frame: CGRect) {
        self.displaySize = frame.size
        super.init(frame: frame)
        self.clearSchedules()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.displaySize = frame.size
        self.clearSchedules()
    }
    
    func requiredContentHeight() -> CGFloat {
        let viewHeight = self.displaySize.height

        let basicAppSettingMgr = CalendarManager.shared().basicSettingManager()!
        
        let defaultStartTime = basicAppSettingMgr.activeTimeFromFloat()
        let defaultEndTime   = basicAppSettingMgr.activeTimeToFloat()
        let totalHoursToShow = defaultEndTime - defaultStartTime
        let oneHourHeight = viewHeight / totalHoursToShow

//        return (oneHourHeight * CGFloat(24)) + self.topMarginView.frame.height + self.bottomMarginView.frame.height
        return (oneHourHeight * CGFloat(24)) + self.kTopMargin + self.bottomMarginView.frame.height
    }
    
    func contentOffset() -> CGPoint {
        let viewHeight = self.displaySize.height
        
        let basicAppSettingMgr = CalendarManager.shared().basicSettingManager()!
        
        let defaultStartTime = basicAppSettingMgr.activeTimeFromFloat()
        let defaultEndTime   = basicAppSettingMgr.activeTimeToFloat()
        let totalHoursToShow = defaultEndTime - defaultStartTime
        let oneHourHeight = viewHeight / totalHoursToShow

//        let y = (oneHourHeight * defaultStartTime) + self.topMarginView.frame.height + self.kTopMargin
        let y = (oneHourHeight * defaultStartTime) + self.kTopMargin

        return CGPoint(x: 0, y: y)
    }
    override func layoutSubviews() {
        let nonActiveColorWithAlpha = self.nonActiveColor.withAlphaComponent(0.2)
        self.bottomMarginView.backgroundColor = nonActiveColorWithAlpha
                
        let viewHeight = self.displaySize.height
        
        let basicAppSettingMgr = CalendarManager.shared().basicSettingManager()!
        
        let defaultStartTime = basicAppSettingMgr.activeTimeFromFloat()
        let defaultEndTime   = basicAppSettingMgr.activeTimeToFloat()
        let totalHoursToShow = defaultEndTime - defaultStartTime
        self.oneHourHeight = viewHeight / totalHoursToShow
        
        let activeTimeStart = (defaultStartTime * oneHourHeight) + self.kTopMargin
        let activeTimeEnd   = activeTimeStart + (totalHoursToShow * oneHourHeight)
        self.scaleView.setNonActiveColor(self.nonActiveColor)
        self.scaleView.setTopMargin(self.kTopMargin)
        self.scaleView.setActiveTimeStart(activeTimeStart)
        self.scaleView.setActiveTimeEnd(activeTimeEnd)
        self.scaleView.setHourHeight(oneHourHeight)
        self.timeView.setTopMargin(self.kTopMargin)
        self.timeView.setHourHeight(oneHourHeight)
                
        self.scaleView.setNeedsLayout()
        self.timeView.setNeedsLayout()
        self.scaleView.setNeedsDisplay()
    }
}

extension BzDailyScheduleContentView {
    
    fileprivate func _startYAndHeight(event:EKEvent) -> CGRect {
        var rect = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        let appCalendar = CalendarManager.shared().appCalendar()!
        
        let startDate = event.startDate!
        let endDate   = event.endDate!
        
        let midNightFlag : Set<Calendar.Component> = [ .year, .month, .day ]
        var midNightComp = appCalendar.dateComponents(midNightFlag, from: self.targetDate)
        midNightComp.hour = 0
        midNightComp.minute = 0
        midNightComp.second = 0
        
        let midNight = appCalendar.date(from: midNightComp)!
        
        let unitFlag : Set<Calendar.Component> = [ .hour, .minute, .day ]
        let startHourMinComp = appCalendar.dateComponents(unitFlag, from: midNight, to:startDate)
        
        guard var hourStart = startHourMinComp.hour, var minStart = startHourMinComp.minute else {
            return rect
        }
        if hourStart < 0 {
            hourStart = 0
        }
        if minStart < 0 {
            minStart = 0
        }

        let endHourMinComp = appCalendar.dateComponents(unitFlag, from: midNight, to: endDate)
        guard var hourEnd = endHourMinComp.hour, var minEnd = endHourMinComp.minute, let dayEnd = endHourMinComp.day else {
            return rect
        }
        if dayEnd > 0 {
            hourEnd = 24
            minEnd = 0
        } else if hourEnd == 0 && minEnd == 0 {
            // エンドが0時0分のものは前日の予定
            return rect
        }
        
        let startTimeInHour : CGFloat = ( CGFloat(hourStart) + (CGFloat(minStart) / CGFloat(60)) )
        let endTimeInHour   : CGFloat = ( CGFloat(hourEnd)   + (CGFloat(minEnd)   / CGFloat(60)) )
        let dulationTimeInHour : CGFloat = endTimeInHour - startTimeInHour
        let startFloat = startTimeInHour * self.oneHourHeight
        let endFloat   = endTimeInHour   * self.oneHourHeight
        
        var dulationFloat : CGFloat = 0
        if dulationTimeInHour < self.minimalDulationTimeInHour {
            dulationFloat = self.minimalDulationTimeInHour
        } else {
            dulationFloat = endFloat - startFloat
        }
        rect.origin.x = 0
        rect.origin.y = startFloat + self.kTopMargin //self.topMarginView.frame.height
        rect.size.width = 0
        rect.size.height = dulationFloat
        
//        if rect.size.height < minHeight {
//            rect.size.height = minHeight
//        }
        return rect
        
    }
    func add(events:Array<EKEvent>) {
        for event in events {
            self.add(event: event)
        }
    }
    func add(event:EKEvent) {
        if event.isAllDay == true {
            // ここには追加しない
            return
        }
        let viewWidth = self.frame.width
        
        let startDate = event.startDate
        let endDate   = event.endDate
        
        var scheduleRect = self._startYAndHeight(event: event)
        
        if scheduleRect.origin.y == 0 && scheduleRect.height == 0 {
            return
        }
        
        let startFloat = scheduleRect.origin.y
        let durationFloat = scheduleRect.size.height
        
        var schdView : DayViewScheduleView!
        
        if self.currentEndFloat <= startFloat {
            // 予定の時間が重ならない
            let initialWidth = viewWidth - self.xOffset - CGFloat(1)
            let tryRect = CGRect(x: self.xOffset, y: startFloat, width: initialWidth, height: durationFloat)
            schdView = DayViewScheduleView(frame: tryRect)
            self.scheduleViewArray.append(schdView)
            
            self.currentStartFloat = startFloat
            self.currentEndFloat = self.currentStartFloat + durationFloat //schdView.frame.size.height
        } else if (startFloat < self.currentEndFloat)       // スタートの時間がcurrentEnd時間よりも前
            && (startFloat >= self.currentStartFloat) {     // スタートの時間がcurrentStart時間以降
            // 予定の時間が重なる
            var doubleBookingArray : Array<DayViewScheduleView> = Array()
            for tempView in self.scheduleViewArray {
                if let tempEvent = tempView.event() {
                    if self._startTime(tryTime: event.startDate, withinEvent: tempEvent) {
                        doubleBookingArray.append(tempView)
                    }
                }
            }
            let eventCountInCGFloat = CGFloat(doubleBookingArray.count + 1)
            let newWidth = (viewWidth - xOffset - eventCountInCGFloat) / eventCountInCGFloat
            var startX = self.xOffset
            for idx in 0..<doubleBookingArray.count {
                let tempView = doubleBookingArray[idx]
                let currentWidth = tempView.frame.width
                if currentWidth > newWidth {
                    var newFrame = tempView.frame
                    newFrame.origin.x = startX
                    newFrame.size.width = newWidth
                    startX += (newWidth + 1)
                    tempView.frame = newFrame
                } else {
                    startX = startX + currentWidth + 1
                }
            }
            let remainingWidth = viewWidth - startX - 1
            
            scheduleRect.origin.x = startX
            scheduleRect.size.width = remainingWidth
            
            schdView = DayViewScheduleView(frame: scheduleRect)
            self.scheduleViewArray.append(schdView)
            
            let endFloat = self.currentEndFloat + scheduleRect.size.height
            if endFloat > currentEndFloat {
                currentEndFloat = endFloat
            }
        } else {
           // fatalError()
            return
        }
        schdView.setEvent(event)
        schdView.fillColor = event.bgColor()
        schdView.textColor = event.textColor()
        
        //self.addGestureRecognizersToEventView:schecView
        
        self.addSubview(schdView)
    }
    
    fileprivate func _startTime(tryTime: Date, withinEvent event: EKEvent) -> Bool {
        if tryTime.compare(event.startDate) != .orderedAscending &&
            tryTime.compare(event.endDate) != .orderedDescending {
            return true
        }
        return false
    }
    
    fileprivate func addGestureRecognizersToEventView(eventView:UIView) {
        //    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]
        //    initWithTarget:self
        //    action:@selector(enablePan:)];
        //    [eventView addGestureRecognizer:longPressGesture];
    }

}
