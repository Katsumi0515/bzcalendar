//
//  JPHolidayDatabaseCreate.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/06/20.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class JPHolidayDatabaseCreate: NSObject {
    fileprivate var contextManager : BzWritableHolidayMOCManager!
    
    fileprivate func documentDirectoryPath(year:Int) -> String {
        let fileManager = FileManager.default
        let fileName : String = String(year) + ".csv"
        let dbPath = try! fileManager
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("jpHolidays")
            .appendingPathComponent("csv")
            .appendingPathComponent(fileName)
            .path
        return dbPath
    }
    
    fileprivate var enTitleDict : Dictionary<String, String> = [
        "元日" : "New Year's Day",
        "成人の日" : "Coming-of-age Day",
        "建国記念の日" : "National Foundation Day",
        "春分の日" : "Vernal Equinox Day",
        "昭和の日" : "Showa Day",
        "憲法記念日" : "Constitution Memorial Day",
        "みどりの日" : "Greenery Day",
        "こどもの日" : "Children's Day",
        "振替休日" : "Substitute Holiday",
        "海の日" : "Marine Day",
        "山の日" : "Mountain Day",
        "敬老の日" : "Respect for the Aged Day",
        "秋分の日" : "Autumnal Equinox Day",
        "体育の日" : "Health-Sports Day",
        "文化の日" : "Culture Day",
        "勤労感謝の日" : "Labour Thanksgiving Day",
        "天皇誕生日" : "Emperor's Birthday",
        "休日" : "Holiday"
    ]
    override init() {
        super.init()
        
        self.contextManager = BzWritableHolidayMOCManager()
        
        let context = contextManager.context()
        let entity = NSEntityDescription.entity(forEntityName: "WorldHoliday", in: context)
        
        let appCalendar = NSCalendar.current //CalendarManager.shared().appCalendar()!
        var comp = DateComponents()
        comp.year = 2019
        comp.month = 1
        comp.day = 1
        let dt = appCalendar.date(from: comp)!
        
        do {
            
            print(context.hasChanges)
                        
            var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WorldHoliday")

            let identifier : String = "Japanese Holidays"
            fetchRequest.predicate = NSPredicate(format: "identifier == %@ and date >= %@", identifier, dt as NSDate)
            
            if let result = try context.fetch(fetchRequest) as? [WorldHoliday] {
                print("need to delete result: ", result.count)
                
                for item in result {
                    print("item", item.secondTitle)
                    context.delete(item)
                }
            }
            
            try context.save()
            
            
            for year in 2019...2030 {

                let csvPath = self.documentDirectoryPath(year: year)
                //CSVファイルのデータを取得する。
                let csvData = try String(contentsOfFile:csvPath, encoding:String.Encoding.utf8)

                //改行区切りでデータを分割して配列に格納する。
                var dataList = csvData.components(separatedBy: "\n")
                let csvDataCount = dataList.count
                dataList.removeFirst()
                for rowString in dataList {
                    if rowString.isEmpty {
                        continue
                    }
                    guard let holiday = NSManagedObject(entity: entity!, insertInto: context) as? WorldHoliday else {
                        return
                    }

                    let cols = rowString.components(separatedBy: ",")
                    let year = Int(cols[0])
                    let month = Int(cols[1])
                    let day = Int(cols[2])
                    let holidayTitle = cols[7].components(separatedBy: .whitespacesAndNewlines).joined()

                    var comp = DateComponents()
                    comp.year = year
                    comp.month = month
                    comp.day = day
                    guard let dt = appCalendar.date(from: comp) else {
                        return
                    }
                    
                    holiday.date = dt
                    holiday.title = holidayTitle
                    holiday.identifier = identifier
                    if let enTitle = self.enTitleDict[holidayTitle], enTitle.isEmpty == false {
                        holiday.secondTitle = enTitle
                    } else {
                        holiday.secondTitle = ""
                    }

                } // for
                try context.save()

                var fromComp = DateComponents()
                fromComp.year = year
                fromComp.month = 1
                fromComp.day = 1
                let fromDt = appCalendar.date(from: fromComp)!

                var toComp = DateComponents()
                toComp.year = year
                toComp.month = 12
                toComp.day = 31
                let toDt = appCalendar.date(from: toComp)!


            }
            contextManager.exportToDocumentDir()
            
        }
        catch {
            print("error", error)
        }
    }
    
//    func rokuyo(from:Date, to: Date) -> Bool {
//        let calendar = NSCalendar.current
//
//        let dayCountUnit : Set<Calendar.Component> = [ .day ]
//        let dayCountComp = calendar.dateComponents(dayCountUnit, from: from, to:to)
//
//        let expectedCount = dayCountComp.day! + 1
//
//        let unitFlag : Set<Calendar.Component> = [ .year, .month, .day ]
//
//
//        var compFrom = calendar.dateComponents(unitFlag, from: from)
//        compFrom.hour = 0
//        compFrom.minute = 0
//        compFrom.second = 0
//
//        let fromDt = calendar.date(from: compFrom)!
//
//        var compTo = calendar.dateComponents(unitFlag, from: to)
//        compTo.hour = 0;
//        compTo.minute = 0;
//        compTo.second = 0;
//        let toDt = calendar.date(from: compTo)!
//        let context = self.contextManager.context()
//
//        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Rokuyo")
//
//        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date <= %@", fromDt as NSDate, toDt as NSDate)
//
//        let result = try! context.fetch(fetchRequest)
//
//        if expectedCount != result.count {
//            print("missing: ", expectedCount - result.count)
//            return false
//        } else {
//            return true
//        }
//        //
//        //    //NSArray* rtnArray = [[context executeFetchRequest:request error:&error] copy];
//        //    NSArray* rtnArray = [context executeFetchRequest:request error:&error];
//        //
//        //
//        //
//        //    return rtnArray;
//
//    }

}
