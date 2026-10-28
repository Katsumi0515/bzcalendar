//
//  BasicAppSetting.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/10.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BasicAppSetting: NSManagedObject {

    @NSManaged var activeTimeFromHour: NSNumber
    @NSManaged var activeTimeFromMinute: NSNumber
    @NSManaged var activeTimeToHour: NSNumber
    @NSManaged var activeTimeToMinute: NSNumber
    
    @NSManaged var customHolidayCalendarID: String
    @NSManaged var customWorkCalendarID: String
    @NSManaged var defaultCalendarID: String
    
    @NSManaged var defaultDisplayMode: NSNumber
    
    @NSManaged var designTheme: String
    
    @NSManaged var fontSizeForDay: NSNumber
    @NSManaged var fontSizeForMonth: NSNumber
    @NSManaged var fontSizeForWeek: NSNumber
    @NSManaged var isAutoHolidayDetect: NSNumber
    @NSManaged var isDayDetailOnForMonth: NSNumber
    @NSManaged var isRokuyoOn: NSNumber
    @NSManaged var weekStartWeekday: NSNumber
    
}
