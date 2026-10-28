//
//  BzWeekBar.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/06/05.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzWeekBar: UIView {

    @IBOutlet weak var yearMonthLabel: UILabel!
    @IBOutlet weak var weekdayLabel: UILabel!
    
    fileprivate var dateFormatter_yearMonth : DateFormatter = DateFormatter()
    fileprivate var detailDateFormatter : DateFormatter = DateFormatter()
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.dateFormatter_yearMonth = CalendarManager.shared().dateFormatter_yMMMM()
        
        let locale = NSLocale.current
        self.detailDateFormatter = DateFormatter()
        self.detailDateFormatter.locale = locale
        self.detailDateFormatter.calendar = CalendarManager.shared().appCalendar()
        self.detailDateFormatter.dateFormat = NSLocalizedString("WeekView_DateFormat_DayAndWeekday", comment:"dd (EE)の週")

        //self.tintColor =
        self.backgroundColor = BzAppThemeService.shared.themeColor()
        self.textColor = BzAppThemeService.shared.themeTextColor()

    }

    override var backgroundColor: UIColor? {
        didSet {
            if self.yearMonthLabel != nil {
                self.yearMonthLabel.backgroundColor = backgroundColor
                self.weekdayLabel.backgroundColor = backgroundColor
            }
        }
    }
    
    var textColor: UIColor = UIColor.white {
        didSet {
        }
    }
    
//    fileprivate func detailTextColor(color:UIColor) {
//        self.weekdayLabel.textColor = color;
//    }
    
    var date : Date = Date() {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        self.backgroundColor = BzAppThemeService.shared.themeColor()
        self.textColor = BzAppThemeService.shared.themeTextColor()

        self.yearMonthLabel.text = self.dateFormatter_yearMonth.string(from: date)
        self.weekdayLabel.text = self.detailDateFormatter.string(from: date)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
