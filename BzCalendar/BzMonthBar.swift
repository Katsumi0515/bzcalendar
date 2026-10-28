//
//  BzMonthView.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/06/19.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzMonthBar: UIView {
    
    @IBOutlet weak var yearMonthLabel: UILabel!
    
    @IBOutlet weak var weekdayLabel1 : UILabel!
    @IBOutlet weak var weekdayLabel2 : UILabel!
    @IBOutlet weak var weekdayLabel3 : UILabel!
    @IBOutlet weak var weekdayLabel4 : UILabel!
    @IBOutlet weak var weekdayLabel5 : UILabel!
    @IBOutlet weak var weekdayLabel6 : UILabel!
    @IBOutlet weak var weekdayLabel7 : UILabel!

    fileprivate var shortWeekdaySymbols : Array<String> = Array()

    fileprivate var dateFormatter_yearMonth : DateFormatter = DateFormatter()
    
    fileprivate var weekdayLabelArray : [UILabel] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.dateFormatter_yearMonth = CalendarManager.shared().dateFormatter_yMMMM()
                
//        self.tintColor =
        self.backgroundColor = BzAppThemeService.shared.themeColor()
        self.textColor = BzAppThemeService.shared.themeTextColor()
        
    }
    
    override var backgroundColor: UIColor? {
        didSet {
            if self.yearMonthLabel != nil {
                self.yearMonthLabel.backgroundColor = backgroundColor
            }
            self.setNeedsLayout()
        }
    }
    
    var textColor: UIColor = UIColor.white {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    //    fileprivate func detailTextColor(color:UIColor) {
    //        self.weekdayLabel.textColor = color;
    //    }
    
    var date : Date = Date() {
        didSet {
            if let array = CalendarManager.shared().shortWeekdaySymbols() {
                for idx in 0..<array.count {
                    if let item = array[idx] as? String {
                        self.shortWeekdaySymbols.append(item)
                    }
                }
            }

            self.weekdayLabelArray = []
            self.weekdayLabelArray.append(weekdayLabel1)
            self.weekdayLabelArray.append(weekdayLabel2)
            self.weekdayLabelArray.append(weekdayLabel3)
            self.weekdayLabelArray.append(weekdayLabel4)
            self.weekdayLabelArray.append(weekdayLabel5)
            self.weekdayLabelArray.append(weekdayLabel6)
            self.weekdayLabelArray.append(weekdayLabel7)
            
            let appCalendar = CalendarManager.shared().appCalendar()!
            let firstWeekday = appCalendar.firstWeekday
            self.shortWeekdaySymbols = appCalendar.shortWeekdaySymbols
            
            for idx in 0..<self.weekdayLabelArray.count {
                let weekdayIdx = (firstWeekday + idx - 1) % 7
                
                let label = self.weekdayLabelArray[idx]
//                label.textAlignment = .center
                label.text = self.shortWeekdaySymbols[weekdayIdx]
            }
            
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        if self.yearMonthLabel != nil {
            self.yearMonthLabel.text = self.dateFormatter_yearMonth.string(from: date)
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

