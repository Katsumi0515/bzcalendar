//
//  SystemActivity.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/10.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class SystemActivity: NSManagedObject {

    @NSManaged var isTring_iCloud: NSNumber?
    @NSManaged var lastDisplayMode: NSNumber?
    @NSManaged var activityCount: NSNumber?
    @NSManaged var installDate: Date?

}
