//
//  ColorUtil+attributedString.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/04/10.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import Foundation
import UIKit

extension ColorUtil {
    func atributedColorCode(code:String, useColorCodeAsTextColor:Bool) -> NSAttributedString {
        let mono = UIFont(name: "Menlo-Regular", size: 14)
//        let shadow = NSShadow()
//        shadow.shadowOffset = CGSize(width: 0.5, height: 0.5)
//        shadow.shadowBlurRadius = 2.0
//        shadow.shadowColor = UIColor.white
        
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: self.UIColorFromColorCode(code) as Any,
            NSAttributedString.Key.strokeColor: self.UIColorFromColorCode(code) as Any,
            NSAttributedString.Key.strokeWidth: -1.0,
            //NSShadowAttributeName: shadow,
            NSAttributedString.Key.font: mono as Any,
        ]
        
        let attributeText = NSMutableAttributedString(string: code)
        let textSize = attributeText.string.count
        
        attributeText.addAttributes(attributes, range: NSRange(location: 0, length: textSize))
        
        return attributeText

    }
    func atributedColorCode(code:String, noShadow:Bool = false) -> NSAttributedString {
        let attributeText = NSMutableAttributedString(string: code)
        
        let textSize = attributeText.string.count
        
        var attributes = baseAttributes

        if noShadow == true {
            var mono : UIFont!
            if #available(iOS 13.0, *) {
                mono = UIFont.monospacedSystemFont(ofSize: 14.0, weight: .regular)
            } else {
                mono = UIFont(name: "Menlo-Regular", size: 14)
            }

            attributes = [
                NSAttributedString.Key.font: mono,
            ]
            
        }
        attributeText.addAttributes(attributes, range: NSRange(location: 0, length: textSize))
        
        return attributeText
    }
    
    fileprivate var baseAttributes: [NSAttributedString.Key: Any] {
        var mono : UIFont!
        if #available(iOS 13.0, *) {
            mono = UIFont.monospacedSystemFont(ofSize: 14.0, weight: .regular)
        } else {
            mono = UIFont(name: "Menlo-Regular", size: 14)
        }
        //let mono = UIFont(name: "Menlo-Regular", size: 14)
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 0.5, height: 0.5)
        shadow.shadowBlurRadius = 2.0
        shadow.shadowColor = UIColor.white
        
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1),
            NSAttributedString.Key.strokeColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
            NSAttributedString.Key.strokeWidth: -1.0,
            NSAttributedString.Key.shadow: shadow,
            NSAttributedString.Key.font: mono,
            //NSFontAttributeName: UIFont(name: "AmericanTypewriter-CondensedBold", size: 40.0)!,
            //NSKernAttributeName: -2.0,
            //NSObliquenessAttributeName: 0.4, // 文字を斜めにする
        ]
        
        return attributes
    }

}
