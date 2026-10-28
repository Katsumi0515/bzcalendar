//
//  Rokuyo.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/09.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class Rokuyo: NSManagedObject {
    @NSManaged var date: Date?
    @NSManaged var title: String?
    @NSManaged var titleEN: String?
}
