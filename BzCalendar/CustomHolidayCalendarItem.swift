//
//  CustomHolidayCalendarItem.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/25.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class CustomHolidayCalendarItem: NSManagedObject {

    @NSManaged var bgAlpha: NSNumber?
    @NSManaged var bgColorCode: String?
    @NSManaged var calendarIdentifier: NSData?
    @NSManaged var date: Data?
    @NSManaged var textColorCode: String?
    @NSManaged var title: String?

}
