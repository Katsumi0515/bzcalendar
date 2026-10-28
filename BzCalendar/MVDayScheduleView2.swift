//
//  MVDayScheduleView2.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2019/10/01.
//  Copyright © 2019 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class MVDayScheduleView2: UIView {

    fileprivate var textView: UITextField!
    

    var index : Int = 0 {
        didSet {
            
        }
    }
    var originalCellViewIndex: Int = 0 {
        didSet {
            
        }
    }
    var text : String? {
        didSet {
            self.textView.text = text
        }
    }
    var font : UIFont? {
        didSet {
            self.textView.font = font
        }
    }
    var cornerRadius : CGFloat = 3 {
        didSet {
            self.textView.layer.cornerRadius = cornerRadius
        }
    }
    override var backgroundColor: UIColor? {
        didSet {
            
        }
    }
    var textBackgroundColor: UIColor? {
        didSet {
            self.textView.backgroundColor = textBackgroundColor
        }
    }
    
    override var frame: CGRect {
        didSet {
            if textView == nil {
                var fm = frame
                let marginY : CGFloat = 0.1
                fm.origin.y = marginY
                fm.size.height = frame.size.height - (marginY * 2)
                textView = UITextField(frame: fm)
                textView.isEnabled = false
                textView.textAlignment = .center
                if( cornerRadius == 0 ) {
                    cornerRadius = fm.size.height / 3.0
                }
                textView.layer.cornerRadius = cornerRadius

                textView.clipsToBounds = true
                self.addSubview(textView)
                return
            }
            var fm = textView.frame
            let marginY : CGFloat = 0.1
            fm.origin.y = marginY
            fm.size.height = frame.size.height - (marginY * 2)
            textView.frame = fm
            if( cornerRadius == 0 ) {
                cornerRadius = fm.size.height / 3.0
            }
            textView.layer.cornerRadius = cornerRadius
        }
    }
    override init(frame: CGRect) {
        //UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
        
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension MVDayScheduleView2 {
    fileprivate func clearRect(rect: CGRect) {
        
    }
    

}
