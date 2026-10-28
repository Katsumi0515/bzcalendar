//
//  DefaultEventSetting.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/09.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

// ToDo:
// 使われてない
class DefaultEventSetting: NSManagedObject {

    @NSManaged var allday: NSNumber?
    @NSManaged var calendarID: String?
    @NSManaged var calendarTitle: String?
    @NSManaged var durationHour: NSNumber?
    @NSManaged var durationMinute: NSNumber?
    @NSManaged var status: String?

}
