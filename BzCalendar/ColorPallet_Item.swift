//
//  ColorPallet_Item.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/09.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class ColorPallet_Item: NSManagedObject {

    @NSManaged var colorCode: String
    @NSManaged var defaultColorName: String?
    @NSManaged var itemNo: NSNumber
    @NSManaged var palletID: String

}
