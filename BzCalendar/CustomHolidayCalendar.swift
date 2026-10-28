//
//  File.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/25.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import Foundation


// ToDo: 不要？
class CustomHolidayCalendar : NSManagedObject {
 
    @NSManaged var identifier: String?
    @NSManaged var title: String?
    @NSManaged var validFromDate: NSData?
    @NSManaged var validUntilDate: NSData?
    @NSManaged var yearNum: NSNumber?

}
