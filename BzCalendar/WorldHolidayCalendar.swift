//
//  WorldHolidayCalendar.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/09.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class WorldHolidayCalendar: NSManagedObject {

    @NSManaged var countryCode: String?
    @NSManaged var title: String?
    @NSManaged var secondTitle: String?
    @NSManaged var identifier: String?    

}
