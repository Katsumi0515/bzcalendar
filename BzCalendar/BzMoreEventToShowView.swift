//
//  BzMoreEventToShowView.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/09.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzMoreEventToShowView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.darkGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.darkGray
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.black
        UIColor.white.setFill()
        
        self.alpha = 0.9
        let path = UIBezierPath()
        
        let margin : CGFloat = 2.0
        
        path.move(to: CGPoint(x: margin, y: margin + 1))
        path.addLine(to: CGPoint(x: rect.size.width - margin, y: margin + 1))
        path.addLine(to: CGPoint(x: rect.size.width/2.0, y: rect.size.height - margin))
        path.close()

        path.fill()

    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
