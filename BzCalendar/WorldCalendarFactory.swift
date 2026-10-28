//
//  WorldCalendarFactory.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/31.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

@objc @objcMembers class WorldCalendarFactory: NSObject {
    
    static var shared : WorldCalendarFactory = WorldCalendarFactory()

    fileprivate let calendarList : Array<WorldCalendarElement>
    
    fileprivate override init() {
        self.calendarList = [
            WorldCalendarElement.element("Japanese Holidays",
                                         name:      "日本の祝日",
                                         iCalName:  "日本の祝祭日",
                                         urlString: "webcal://ical.mac.com/ical/Japanese32Holidays.ics",
                                         secondDisplayName: "Japanese Holidays",
                                         countryCode: "JP",
                                         hasSecondHolidayTitle: true),
            WorldCalendarElement.element("US Holidays",
                                         name:      "US Holidays",
                                         iCalName:  "US Holidays",
                                         urlString: "webcal://ical.mac.com/ical/US32Holidays.ics",
                                         secondDisplayName: "US Holidays",
                                         countryCode: "US",
                                         hasSecondHolidayTitle: false),
            WorldCalendarElement.element("Canadian Holidays",
                                         name:      "Canadian Holidays",
                                         iCalName:  "Canadian Holidays",
                                         urlString: "webcal://ical.mac.com/ical/Canadian32Holidays.ics",
                                         secondDisplayName: "Canadian Holiday",
                                         countryCode: "CA",
                                         hasSecondHolidayTitle: true),
            WorldCalendarElement.element("UK Holidays",
                                         name:      "UK Holidays",
                                         iCalName:  "UK Holidays",
                                         urlString: "webcal://ical.mac.com/ical/UK32Holidays.ics",
                                         secondDisplayName: "UK Holidays",
                                         countryCode: "GB",
                                         hasSecondHolidayTitle: false),
            WorldCalendarElement.element("Australian Holidays",
                                         name:      "Australian Holidays",
                                         iCalName:  "Australian Holidays",
                                         urlString: "webcal://ical.mac.com/ical/Australian32Holidays.ics",
                                         secondDisplayName: "Australian Holidays",
                                         countryCode: "AU",
                                         hasSecondHolidayTitle: false),
            WorldCalendarElement.element("French Holidays",
                                         name:      "Fêtes françaises",
                                         iCalName:  "Fêtes françaises",
                                         urlString: "webcal://ical.mac.com/ical/French32Holidays.ics",
                                         secondDisplayName: "French Holidays",
                                         countryCode: "FR",
                                         hasSecondHolidayTitle: true),
            WorldCalendarElement.element("German Holidays",
                                         name:      "Deutsche Feiertage",
                                         iCalName:  "Deutsche Feiertage 2",
                                         urlString: "webcal://ical.mac.com/ical/German32Holidays.ics",
                                         secondDisplayName: "German Holidays",
                                         countryCode: "DE",
                                         hasSecondHolidayTitle: true)
        ]
        
        super.init()
    }
    func sharedList() -> Array<WorldCalendarElement> {
        return self.calendarList
    }
    
}
