//
//  ColorUtil.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/24.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import Foundation

@objc @objcMembers class ColorUtil : NSObject {
    static var shared : ColorUtil = ColorUtil()

    fileprivate var colorDict : Dictionary<String, UIColor> = Dictionary()

    fileprivate override init() {
        super.init()
    }
    
    
    func colorCode(color:UIColor) -> String {

        var colorCode : String = ""
        let num = color.cgColor.numberOfComponents

        if num >= 3 {
            let components = color.cgColor.components!
            let r = components[0]
            let g = components[1]
            let b = components[2]
            // Intにしてフォーマット
            colorCode = String(format: "#%02x%02x%02x", Int(r * 255), Int(g * 255), Int(b * 255))
        } else {
            let components = color.cgColor.components!
            let grayInt = Int(components[0] * 255)
            
            // Intからフォーマット
            colorCode = String(format: "#%02x%02x%02x", grayInt, grayInt, grayInt)
        }
 
        return colorCode
    }
    
    func UIColorFromColorCode(_ code: String) -> UIColor? {
        
        if let color = self.colorDict[code] {
            return color
        }
        if code.count < 7 {
            return nil
        }
        var range = NSRange()
        range.length = 2
        
        var redUInt   : UInt32 = 0
        var greenUInt : UInt32 = 0
        var blueUInt  : UInt32 = 0

        range.location = 1
        if let codeRange = Range(range, in: code) {
            let codeString : String = code.substring(with: codeRange)
            let scanner = Scanner(string: codeString)
            scanner.scanHexInt32(&redUInt)
        }
        
        range.location = 3
        if let codeRange = Range(range, in: code) {
            let codeString : String = code.substring(with: codeRange)
            let scanner = Scanner(string: codeString)
            scanner.scanHexInt32(&greenUInt)
        }

        range.location = 5
        if let codeRange = Range(range, in: code) {
            let codeString : String = code.substring(with: codeRange)
            let scanner = Scanner(string: codeString)
            scanner.scanHexInt32(&blueUInt)
        }


        let tmpColor = UIColor(red: CGFloat(redUInt)/255,
                               green: CGFloat(greenUInt)/255,
                               blue: CGFloat(blueUInt)/255,
                               alpha: CGFloat(1))
        
        self.colorDict[code] = tmpColor

        return tmpColor
    }
    
    func UIColorFromEKEvent(_ event: EKEvent) -> UIColor {
        let cal : EKCalendar = event.calendar

        if let color = self.colorDict[cal.calendarIdentifier] {
            return color
        }
        
        let cgColorRef : CGColor = cal.cgColor
        
        let newColor = UIColor(cgColor: cgColorRef)

        self.colorDict[cal.calendarIdentifier] = newColor
        

        return newColor
    }

}
