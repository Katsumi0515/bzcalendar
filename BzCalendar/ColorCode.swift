//
//  ColorCode.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/09.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class ColorCode: NSManagedObject {

    @NSManaged var colorCode: String?
    @NSManaged var colorName: String?
    @NSManaged var lang: String?
    @NSManaged var palletID: String?

}
