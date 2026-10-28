//
//  ColorSetting.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/09.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class ColorSetting: NSManagedObject {

    @NSManaged var background: String?
    @NSManaged var holiday: String?
    @NSManaged var holidayBackground: String?
    @NSManaged var nonWork: String?
    @NSManaged var saturday: String?
    @NSManaged var selected: String?
    @NSManaged var sunday: String?
    @NSManaged var today: String?
    @NSManaged var weekday: String?

}
