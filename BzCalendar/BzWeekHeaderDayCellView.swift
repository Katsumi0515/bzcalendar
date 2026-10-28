//
//  BzWeekHeaderDayCellView.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/25.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzWeekHeaderDayCellView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var bzDate : BZVMWeeklyViewDayContents? = nil {
        didSet {
            self.setText(by: bzDate!.date)
        }
    }
    
    fileprivate var dateFormat : DateFormatter = DateFormatter()

    fileprivate var currentFontSize : CGFloat = 17
    fileprivate var textLabel : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.dateFormat.dateFormat = NSLocalizedString("WeekView_DateFormat_DayHeader", comment:"dd (EE)")
        self.dateFormat.locale = NSLocale.current
        

        let xMargin : CGFloat = 0.5
        let yMargin : CGFloat = 0.5
        let textHeight = frame.size.height - (yMargin * 2)
        let textWidth  = frame.size.width  - (xMargin * 2)
        let textFrame = CGRect(x: xMargin, y: yMargin, width: textWidth, height: textHeight)

        self.textLabel = UILabel(frame: textFrame)
//        self.textLabel.textAlignment = .center
        self.textLabel.adjustsFontSizeToFitWidth = true

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.dateFormat.dateFormat = NSLocalizedString("WeekView_DateFormat_DayHeader", comment:"dd (EE)")
        self.dateFormat.locale = NSLocale.current
        
        
        let xMargin : CGFloat = 0.5
        let yMargin : CGFloat = 0.5
        let textHeight = frame.size.height - (yMargin * 2)
        let textWidth  = frame.size.width  - (xMargin * 2)
        let textFrame = CGRect(x: xMargin, y: yMargin, width: textWidth, height: textHeight)
        
        self.textLabel = UILabel(frame: textFrame)
        self.textLabel.adjustsFontSizeToFitWidth = true
        self.textLabel.textColor = UIColor.black
        self.textLabel.layoutMargins = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        self.textLabel.font  = WeekViewSettingManager.shared().fontForWeekday()
//        self.textLabel.textAlignment = .center

        self.addSubview(self.textLabel)
        self.backgroundColor = UIColor.clear

    }
    fileprivate func setText(by date:Date) {
        let text = self.dateFormat.string(from: date)
        self.textLabel.text = text
    }
    
    override func layoutSubviews() {
        let frame = self.frame
        let xMargin : CGFloat = 0.5
        let yMargin : CGFloat = 0.5
        let textHeight = frame.size.height - (yMargin * 2)
        let textWidth  = frame.size.width  - (xMargin * 2)
        let textFrame = CGRect(x: xMargin, y: yMargin, width: textWidth, height: textHeight)
        self.textLabel.frame = textFrame

    }
}
