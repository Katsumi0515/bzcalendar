//
//  CalendarExtension.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/25.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class CalendarExtension: NSManagedObject {

    @NSManaged var bgAlpha: NSNumber?
    @NSManaged var bgColorCode: String?
    @NSManaged var googleNotesIdentifeir: String?
    @NSManaged var identifier: String?
    @NSManaged var priority: NSNumber?
    @NSManaged var textColorCode: String?
    
}
