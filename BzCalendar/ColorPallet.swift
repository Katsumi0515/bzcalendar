//
//  ColorPallet.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/10.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class ColorPallet: NSManagedObject {

    @NSManaged var index: NSNumber
    @NSManaged var lang: String
    @NSManaged var palletID: String
    @NSManaged var palletName: String

}
