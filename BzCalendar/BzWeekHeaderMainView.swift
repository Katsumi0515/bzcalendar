//
//  BzWeekHeaderMainView.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/24.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzWeekHeaderMainView: UIView {
    
    @IBOutlet weak internal var weekAlldayStackView: BzWeekAlldayView!
    
    @IBOutlet weak internal var dayCellTitleWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var dayLabelStack: UIStackView!
    
    @IBOutlet weak var rokuyoRowView: UIStackView!
    @IBOutlet weak var rokuyoLabelStack: UIStackView!
    
    @IBOutlet weak internal var dayCellView1 : BzWeekHeaderDayCellView!
    @IBOutlet weak internal var dayCellView2 : BzWeekHeaderDayCellView!
    @IBOutlet weak internal var dayCellView3 : BzWeekHeaderDayCellView!
    @IBOutlet weak internal var dayCellView4 : BzWeekHeaderDayCellView!
    @IBOutlet weak internal var dayCellView5 : BzWeekHeaderDayCellView!
    @IBOutlet weak internal var dayCellView6 : BzWeekHeaderDayCellView!
    @IBOutlet weak internal var dayCellView7 : BzWeekHeaderDayCellView!

    @IBOutlet weak internal var rokuyo1Label : UILabel!
    @IBOutlet weak internal var rokuyo2Label : UILabel!
    @IBOutlet weak internal var rokuyo3Label : UILabel!
    @IBOutlet weak internal var rokuyo4Label : UILabel!
    @IBOutlet weak internal var rokuyo5Label : UILabel!
    @IBOutlet weak internal var rokuyo6Label : UILabel!
    @IBOutlet weak internal var rokuyo7Label : UILabel!

    @IBOutlet weak internal var alldayTitleLabel : UILabel!
    
    override var bounds: CGRect {
        didSet {
            print("bounds", bounds)
            self.weekAlldayStackView.setNeedsLayout()
            
        }
    }

    func add(alldayContents:BZVMAlldayViewContents) {
        self.weekAlldayStackView.add(alldayContents: alldayContents)

    }
    func suggestedAlldayViewHeight() -> CGFloat {
     
        return self.weekAlldayStackView.suggestedAlldayViewHeight()
    }
    
    func offsetX() -> CGFloat {
        
        return 40.0
    }
    
    func setTitleAreaWidth(width:CGFloat) {
        self.dayCellTitleWidthConstraint.constant = width
        self.updateConstraints()
    }
    
    fileprivate var dayCellArray : Array<BzWeekHeaderDayCellView> = Array()
    fileprivate var dateFormat : DateFormatter!
    fileprivate var rokuyoLabalArray : Array<UILabel> = Array()


//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        // ToDo: 日付フォーマットに関しては集中管理すべきリファクタリング
//        self.dateFormat = DateFormatter()
//        self.dateFormat.dateFormat = NSLocalizedString("WeekView_DateFormat_DayHeader", comment:"dd (EE)")
//        self.dateFormat.locale = NSLocale.current
//
//    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        

        // ToDo: 日付フォーマットに関しては集中管理すべきリファクタリング
        self.dateFormat = DateFormatter()
        self.dateFormat.dateFormat = NSLocalizedString("WeekView_DateFormat_DayHeader", comment:"dd (EE)")
        self.dateFormat.locale = NSLocale.current
        
        
    }
 
    fileprivate func dayCells() -> Array<BzWeekHeaderDayCellView> {
        if self.dayCellArray.count == 7 {
            return self.dayCellArray
        }
        self.alldayTitleLabel.textColor = UIColor.black;
        
        self.alldayTitleLabel.text = NSLocalizedString("Common_ExactWord_AllDay", comment:"終日")

        self.dayCellArray = [
            self.dayCellView1,
            self.dayCellView2,
            self.dayCellView3,
            self.dayCellView4,
            self.dayCellView5,
            self.dayCellView6,
            self.dayCellView7
        ]
        
        return self.dayCellArray
    }
    
    fileprivate func rokuyoLabals() -> Array<UILabel> {
        if self.rokuyoLabalArray.count == 7 {
            return self.rokuyoLabalArray
        }
        self.rokuyoLabalArray = [
            self.rokuyo1Label,
            self.rokuyo2Label,
            self.rokuyo3Label,
            self.rokuyo4Label,
            self.rokuyo5Label,
            self.rokuyo6Label,
            self.rokuyo7Label
        ]
        for label in self.rokuyoLabalArray {
            label.textColor = .black;
        }
        return self.rokuyoLabalArray
    }
    fileprivate var _weekDates : Array<BZVMWeeklyViewDayContents> = Array()
    
    func setWeekDates(dayDataArray array: Array<BZVMWeeklyViewDayContents>) {
        guard array.count == 7 else {
            fatalError("day data array should be 7")
        }
        self._weekDates = array
        let dayCellArray = self.dayCells()
        
        
        for idx in 0..<7 {
            let bzDate = array[idx]
            let dayCell = dayCellArray[idx]
            dayCell.bzDate = bzDate
            dayCell.setNeedsLayout()
        }
        self.setNeedsLayout()

    }
//    func setWeekDates(array dateArray:Array<Date>) {
//
//        guard dateArray.count == 7 else {
//            fatalError()
//        }
//        self._weekDates = dateArray
//        let dayCellArray = self.dayCells()
//
//
//        for idx in 0..<7 {
//            let date = dateArray[idx]
//            let dayCell = dayCellArray[idx]
//            dayCell.setText(by: date)
//            dayCell.setNeedsLayout()
//        }
//        self.setNeedsLayout()
//    }
    
    fileprivate func drawLine(context:CGContext, x0:CGFloat, y0:CGFloat, x1:CGFloat, y1:CGFloat) {
        context.setStrokeColor([0.7, 0.7, 0.7, 0.5])
        let pattern : Array<CGFloat> = [3.0, 2.0]
        
        context.setLineWidth(1.0)
        context.setLineDash(phase: 0, lengths: pattern)
        context.setLineCap(.butt)
        context.move(to: CGPoint(x: x0, y: y0))
        context.addLine(to: CGPoint(x: x1, y: y1))
        context.strokePath()
        
    }
    fileprivate func setLineWidth(context:CGContext, width:Float) {
        var width = width
        if width < 0.0 {
            width = 0.0
        }
        context.setLineWidth(CGFloat(width))
        
    }
    
//    func add(longEvent: BzWeekScheduleComponentLongEvent, viewIndex:Int) {
//        self.weekAlldayStackView.add(longEvent: longEvent, viewIndex: viewIndex)
//    }
//    func add(alldayEvent event: EKEvent, viewIndex:Int) {
//        self.weekAlldayStackView.add(event: event, viewIndex: viewIndex)
//    }
//    func add(endOnOtherDayEvent: EKEvent) {
//        
//    }
//    func add(shordEvent event: EKEvent) {
//        
//    }
    func clearSubViews() {
        self.weekAlldayStackView.clearAllScheduleViews()
    }
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        let fillCGColor = UIColor.white.cgColor
        
        let startY : CGFloat = 0
        var currentY : CGFloat = startY
        let offsetX = self.dayLabelStack.frame.origin.x
        
        context.clear(rect)
        context.saveGState()
        context.setFillColor(fillCGColor)
        context.fill(rect)
        
        self.drawLine(context: context, x0: offsetX, y0: currentY, x1: self.frame.size.width, y1: currentY)
        currentY = self.dayLabelStack.frame.origin.y + self.dayLabelStack.frame.size.height
        self.drawLine(context: context, x0: offsetX, y0: currentY, x1: self.frame.size.width, y1: currentY)

        let basicMgr = CalendarManager.shared().basicSettingManager()!
        
        if basicMgr.isRokuyoOn() {
            currentY = self.rokuyoRowView.frame.origin.y + self.rokuyoRowView.frame.size.height
            self.drawLine(context: context, x0: offsetX, y0: currentY, x1: self.frame.size.width, y1: currentY)
        }
        
        let dayCellArray = self.dayCells()
        
        var curX = offsetX
        let xStep = self.dayCellView1.frame.size.width
        let contentHeight = rect.size.height
        for y in 0..<7 {
            self.drawLine(context: context, x0: curX, y0: startY, x1: curX, y1: contentHeight)
            curX += xStep
        }
        
        context.restoreGState()
        
        context.setStrokeColor([0.7, 0.7, 0.7, 0.5])
        let lineWidth : CGFloat = 0.5
        let endX : CGFloat = rect.size.width
        let posY : CGFloat = rect.size.height - lineWidth
        context.move(to: CGPoint(x: 0, y: posY))
        context.addLine(to: CGPoint(x: endX, y: posY))
        context.strokePath()
        
    }

    override func layoutSubviews() {
        let colorMgr = CalendarManager.shared().appSettingColorManager()!
        let basicMgr = CalendarManager.shared().basicSettingManager()!
        
        if basicMgr.isRokuyoOn() {
            self.rokuyoRowView.isHidden = false
        } else {
            self.rokuyoRowView.isHidden = true
        }
        let appCalendar = CalendarManager.shared().appCalendar()!
        var comps = appCalendar.dateComponents([.day, .month, .year], from: Date())
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        
        let today = appCalendar.date(from: comps)!
        
        var idx : Int = 0
        for dayCell in self.dayCells() {
            let dayData = self._weekDates[idx]
            idx += 1
            
            if let bzDate = dayCell.bzDate {
                // 基本
                if bzDate.isSunday() {
                    if let colorCode = colorMgr.sunday() {
                        let color = ColorUtil.shared.UIColorFromColorCode(colorCode)
                        dayCell.backgroundColor = color

                    }
                } else if bzDate.isSaturday() {
                    if let colorCode = colorMgr.saturday() {
                        let color = ColorUtil.shared.UIColorFromColorCode(colorCode)
                        dayCell.backgroundColor = color
                    }
                } else {
                    dayCell.backgroundColor = UIColor.clear
                }
                // 休日
                if bzDate.isCustomHoliday {
                    if let colorCode = colorMgr.nonWork() {
                        let color = ColorUtil.shared.UIColorFromColorCode(colorCode)
                        dayCell.backgroundColor = color
                    }
                } else if bzDate.isHoliday {
                    if let colorCode = colorMgr.holiday() {
                        let color = ColorUtil.shared.UIColorFromColorCode(colorCode)
                        dayCell.backgroundColor = color
                    }
                }
                if bzDate.date.compare(today) == .orderedSame {
                    if let colorCode = colorMgr.today() {
                        let color = ColorUtil.shared.UIColorFromColorCode(colorCode)
                        dayCell.backgroundColor = color
                    }
                }
                if dayData.isSelectedDate {
                    if let colorCode = colorMgr.selected() {
                        let color = ColorUtil.shared.UIColorFromColorCode(colorCode)
                        dayCell.backgroundColor = color
                    }
                }
                
            }
        }
        for idx in 0..<7 {
            let rokuyoLabel = self.rokuyoLabals()[idx]
            if let bzDate = self.dayCells()[idx].bzDate, let title = bzDate.rokuyoTitle {
                rokuyoLabel.text = title
            }
        }
        self.setNeedsDisplay()
    }
}
