//
//  EventExtension.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/25.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class EventExtension: NSManagedObject {

    @NSManaged var bgAlpha: String?
    @NSManaged var bgColorCode: String?
    @NSManaged var calendarIdentifier: String?
    @NSManaged var identifier: String?
    @NSManaged var templateName: String?
    @NSManaged var textColorCode: String?

}
