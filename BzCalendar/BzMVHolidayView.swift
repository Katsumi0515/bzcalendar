//
//  BzMVHolidayView.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/09.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

// ToDo: UILabelのサブクラスに変更する

@objc @objcMembers class BzMVHolidayView: UIView {

    let _kScheduleFontName = "ArialMT"
    var xMargin : CGFloat
    var xOffsetFromXMargin : CGFloat

    var text : String
    var font : UIFont
    var textColor : UIColor
    var clearColor : UIColor? = nil
    
    var index: Int = 0

    override init(frame: CGRect) {
        self.xMargin = 0.2
        self.xOffsetFromXMargin = 1.0
        
        self.font = UIFont(name: self._kScheduleFontName, size: 10.0)! //[UIFont fontWithName:kScheduleFontName size:10.0f];
        self.textColor = UIColor.red
        self.text = ""
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.xMargin = 0.2
        self.xOffsetFromXMargin = 1.0
        
        self.font = UIFont(name: self._kScheduleFontName, size: 10.0)! //[UIFont fontWithName:kScheduleFontName size:10.0f];
        self.textColor = UIColor.red
        self.text = ""
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        ctx.saveGState()
        
        self.clearRect(rect: rect)
        
        var contextRect = rect

        let textRectSize = (self.text as NSString).boundingRect(with: rect.size,
                                             options: .usesLineFragmentOrigin,
                                             attributes: [NSAttributedString.Key.font:self.font],
                                             context: nil)
        
        
        contextRect.size = textRectSize.size;
        
        self.drawTextInRect(contextRect: contextRect, withContext: ctx)

        ctx.restoreGState()
        
    }

    func drawTextInRect(contextRect:CGRect, withContext ctx: CGContext) {
    
        
        let size = self.text.size(withAttributes: [NSAttributedString.Key.font: self.font])
        let textHeight = size.height
        let viewHeight = contextRect.size.height
        let x = self.xMargin + self.xOffsetFromXMargin;
        let y : CGFloat = (viewHeight - textHeight)/2.0
        let pt = CGPoint(x: x, y: y)
        
        ctx.saveGState();
        ctx.setFillColor(self.textColor.cgColor)
        let attributes : [NSAttributedString.Key: Any] = [ NSAttributedString.Key.font: self.font, NSAttributedString.Key.foregroundColor: self.textColor ]
        
        (self.text as NSString).draw(at: pt, withAttributes: attributes)
        
        ctx.restoreGState()
    }
    func clearRect(rect : CGRect) {
        if let superview = self.superview, let bgColor = superview.backgroundColor {
            self.clearColor = bgColor
            if let ctx = UIGraphicsGetCurrentContext() {
                ctx.setFillColor(bgColor.cgColor)
                ctx.fill(rect)
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
