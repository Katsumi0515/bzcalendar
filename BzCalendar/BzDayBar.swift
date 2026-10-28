//
//  BzDayBar.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/21.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzDayBar: UIView {

    @IBOutlet weak var yearMonthLabel: UILabel!
    
    @IBOutlet weak var dayWeekdayLabel: UILabel!
    @IBOutlet weak var holidayLabel: UILabel!
    @IBOutlet weak var rokuyoLabel: UILabel!

    fileprivate var dateFormatter_yearMonth : DateFormatter = DateFormatter()
    fileprivate var detailDateFormatter : DateFormatter = DateFormatter()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.dateFormatter_yearMonth = CalendarManager.shared().dateFormatter_yMMMM()
        
        let locale = NSLocale.current
        self.detailDateFormatter = DateFormatter()
        self.detailDateFormatter.locale = locale
        self.detailDateFormatter.calendar = CalendarManager.shared().appCalendar()
        self.detailDateFormatter.dateFormat = NSLocalizedString("DayView_DateFormat_DayAndWeekday", comment:"dd (EE)")

        //self.tintColor =
        self.backgroundColor = BzAppThemeService.shared.themeColor()
        self.textColor = BzAppThemeService.shared.themeTextColor()

    }

    override var backgroundColor: UIColor? {
        didSet {
            if self.yearMonthLabel != nil {
                self.yearMonthLabel.backgroundColor = backgroundColor
                self.holidayLabel.backgroundColor = backgroundColor
                self.dayWeekdayLabel.backgroundColor = backgroundColor
                self.rokuyoLabel.backgroundColor = backgroundColor
            }
        }
    }
    
    var textColor: UIColor = UIColor.white {
        didSet {
        }
    }
    
    
    fileprivate func detailTextColor(color:UIColor) {
        self.dayWeekdayLabel.textColor = color;
        self.holidayLabel.textColor = color;
    }
    var date : Date = Date() {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    func rokuyoTitle(title:String) {
        self.rokuyoLabel.text = title
    }

    override func layoutSubviews() {
        self.backgroundColor = BzAppThemeService.shared.themeColor()
        self.textColor = BzAppThemeService.shared.themeTextColor()

        let colorMgr : ColorSettingManager = CalendarManager.shared().appSettingColorManager()
        let holidayMgr : WorldCalendarManager = WorldCalendarManager.shared
        
        self.yearMonthLabel.text = self.dateFormatter_yearMonth.string(from: date)
        self.dayWeekdayLabel.text = self.detailDateFormatter.string(from: date)
                
        var isHoliday = false
        if let holidayText = holidayMgr.holidayTitle(at: date), holidayText.isEmpty == false {
            self.holidayLabel.text = holidayText
            isHoliday = true
        }
        
        let isCustomHoliday = CustomHolidayCalendarManager.shared.eventExists(on: date)
        if isCustomHoliday {
            if let colorCode = colorMgr.nonWork() {
                let color = ColorUtil.shared.UIColorFromColorCode(colorCode)
                self.dayWeekdayLabel.textColor = color;
                self.holidayLabel.textColor = color;
            }
        } else if isHoliday == true  {
            if let colorCode = colorMgr.holiday() {
                let color = ColorUtil.shared.UIColorFromColorCode(colorCode)
                self.dayWeekdayLabel.textColor = color;
                self.holidayLabel.textColor = color;
            }
        } else {
            self.holidayLabel.text = ""
            
            let appCalendar = CalendarManager.shared().appCalendar()!
            let comps = appCalendar.dateComponents([.weekday], from: date)
            let weekday = comps.weekday;
            
            if weekday == 1 {
                if let colorCode = colorMgr.sunday() {
                    let color = ColorUtil.shared.UIColorFromColorCode(colorCode)
                    self.dayWeekdayLabel.textColor = color;
                }
            } else if  weekday == 7  {
                if let colorCode = colorMgr.saturday() {
                    let color = ColorUtil.shared.UIColorFromColorCode(colorCode)
                    self.dayWeekdayLabel.textColor = color;
                }
                
            } else {
                self.dayWeekdayLabel.textColor = BzAppThemeService.shared.themeTextColor()
            }
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
