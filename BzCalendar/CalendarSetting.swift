//
//  CalendarSetting.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/10.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class CalendarSetting: NSManagedObject {

    @NSManaged var color: String?
    @NSManaged var identifier: String?
    @NSManaged var selected: NSNumber?
    @NSManaged var title: String?

}
