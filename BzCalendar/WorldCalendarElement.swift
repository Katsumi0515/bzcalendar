//
//  WorldCalendarElement.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/31.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

@objc @objcMembers class WorldCalendarElement: NSObject {

    let identifier : String
    let iCalName : String
    let displayName : String
    let urlString : String
    let countryCode : String
    let secondDisplayName : String
    let hasSecondHolidayTitle : Bool 

    required init(element:String,
                  name displayName:String,
                  iCalName:String,
                  urlString:String,
                  secondDisplayName:String,
                  countryCode:String,
                  hasSecondHolidayTitle:Bool = false) {
        
        self.identifier = element
        self.iCalName = iCalName
        self.displayName = displayName
        self.urlString = urlString
        self.countryCode = countryCode
        self.secondDisplayName = secondDisplayName
        self.hasSecondHolidayTitle = hasSecondHolidayTitle
        super.init()
    }
    
    class func element(_ element:String,
                                 name displayName:String,
                                 iCalName:String,
                                 urlString:String,
                                 secondDisplayName:String,
                                 countryCode:String,
                                 hasSecondHolidayTitle:Bool = false) -> WorldCalendarElement {
    
        return WorldCalendarElement(element: element,
                             name: displayName,
                             iCalName: iCalName,
                             urlString: urlString,
                             secondDisplayName: secondDisplayName
            , countryCode: countryCode, hasSecondHolidayTitle: hasSecondHolidayTitle)
        
    }

    fileprivate override init() {
        fatalError("use init with parameters")
    }
}
