//
//  BZIFRokuyoReader.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/25.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BZIFRokuyoReader: NSObject {

    static var shared : BZIFRokuyoReader = BZIFRokuyoReader()
    
    var contextManager : BzHolidayManagedObjectContextManager
    
    fileprivate override init() {
        self.contextManager = BzHolidayManagedObjectContextManager.shared
        super.init()
    }
//    rokuyoDict = [[NSMutableDictionary alloc] initWithCapacity:1000];

    func rokuyoTitleAt(date:Date) -> String {
        
        let units : Set<Calendar.Component> = [ .day, .year, .month ]
        let appCalendar = CalendarManager.shared().appCalendar()!
        
        var comp = appCalendar.dateComponents(units, from: date)
        comp.hour = 0
        comp.minute = 0
        comp.second = 0
        
        let dt = appCalendar.date(from: comp)!
        

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Rokuyo")
        request.predicate = NSPredicate(format: "date == %@", dt as NSDate)

        let context = self.contextManager.sharedContext()
        
        do {
            if let array = try context.fetch(request) as? Array<Rokuyo> {
                if let item = array.first {
                    if let title = item.title {
                        return title
                    } else {
                        return ""
                    }
                }
            }

        }
        catch {
            
        }
        return ""
    }
    func rokuyo(from:Date, to:Date) -> Array<Rokuyo> {
        
        let units : Set<Calendar.Component> = [ .day, .year, .month ]
        let appCalendar = CalendarManager.shared().appCalendar()!

        var compFrom = appCalendar.dateComponents(units, from: from)
        compFrom.hour = 0
        compFrom.minute = 0
        compFrom.second = 0
        
        let fromDt = appCalendar.date(from: compFrom)!

        
        var compTo = appCalendar.dateComponents(units, from: to)
        compTo.hour = 0
        compTo.minute = 0
        compTo.second = 0
        
        let toDt = appCalendar.date(from: compTo)!
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Rokuyo")
        request.predicate = NSPredicate(format: "date >= %@ and date <= %@", fromDt as NSDate, toDt as NSDate)
        
        let context = self.contextManager.sharedContext()
        
        
        
        do {
            if let array = try context.fetch(request) as? Array<Rokuyo> {
                return array
            }
            
        }
        catch {
            
        }
        return Array()
    }
}
