//
//  File.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/29.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import Foundation

// ToDo: - SwiftではextensionでNSCodingを実装できない？　required init?が使えないから
//          Swift4からはCodableが追加されていて、それが使えそう。ただし、階層構造をもっているオブジェクトなので要注意
//          イベントテンプレートのコーダー、デコーダーを作成する必要あり

//extension EKRecurrenceRule: Codable {
//
//}
//extension EKRecurrenceRule: NSCoding {
//
//    public func encode(with aCoder: NSCoder) {
//        aCoder.encode(self.frequency, forKey:"frequency")
//        aCoder.encode(self.interval, forKey:"interval")
//        aCoder.encode(self.daysOfTheMonth, forKey:"daysOfTheMonth")
//        aCoder.encode(self.daysOfTheWeek, forKey:"daysOfTheWeek")
//
//        aCoder.encode(self.monthsOfTheYear, forKey:"monthsOfTheYear")
//        aCoder.encode(self.weeksOfTheYear, forKey:"weeksOfTheYear")
//        aCoder.encode(self.daysOfTheYear, forKey:"daysOfTheYear")
//        aCoder.encode(self.setPositions, forKey:"setPositions")
//        aCoder.encode(self.recurrenceEnd, forKey:"recurrenceEnd")
//    }
//
//    public required init?(coder aDecoder: NSCoder) {
//        let frequency = aDecoder.decodeInteger(forKey: "frequency")
//
//        NSInteger frequency = [decoder decodeIntegerForKey:@"frequency"];
//        NSInteger interval = [decoder decodeIntegerForKey:@"interval"];
//        NSArray* daysOfTheMonth = [decoder decodeObjectForKey:@"daysOfTheMonth"];
//        NSArray* daysOfTheWeek = [decoder decodeObjectForKey:@"daysOfTheWeek"];
//        NSArray* monthsOfTheYear = [decoder decodeObjectForKey:@"monthsOfTheYear"];
//        NSArray* weeksOfTheYear = [decoder decodeObjectForKey:@"weeksOfTheYear"];
//        NSArray* daysOfTheYear = [decoder decodeObjectForKey:@"daysOfTheYear"];
//        NSArray* setPositions = [decoder decodeObjectForKey:@"setPositions"];
//        EKRecurrenceEnd* end = [decoder decodeObjectForKey:@"recurrenceEnd"];
//
//        self = [self initRecurrenceWithFrequency:frequency
//            interval:interval
//            daysOfTheWeek:daysOfTheWeek
//            daysOfTheMonth:daysOfTheMonth
//            monthsOfTheYear:monthsOfTheYear
//            weeksOfTheYear:weeksOfTheYear
//            daysOfTheYear:daysOfTheYear
//            setPositions:setPositions
//            end:end];
//
//
//        return self;
//
//    }
//
//
//}

