//
//  WorldHoliday.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/09.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class WorldHoliday: NSManagedObject {

    @NSManaged var title: String?
    @NSManaged var secondTitle: String?
    @NSManaged var identifier: String?
    @NSManaged var date: Date?

}
