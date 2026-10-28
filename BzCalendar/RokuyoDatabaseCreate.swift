//
//  RokuyoDatabaseCreate.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/06/20.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class RokuyoDatabaseCreate: NSObject {

    fileprivate var contextManager : BzWritableHolidayMOCManager!
    
    fileprivate func documentDirectoryPath(year:Int) -> String {
        let fileManager = FileManager.default
        let fileName : String = String(year) + ".csv"
        let dbPath = try! fileManager
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("csv")
            .appendingPathComponent(fileName)
            .path
        return dbPath
    }

    fileprivate var rokuyoENTitles : Dictionary<String, String> = [
        "先勝" : "Sensho",
        "友引" : "Tomobiki",
        "先負" : "Senbu",
        "仏滅" : "Butsumetsu",
        "大安" : "Taian",
        "赤口" : "Shakkou"
    ]
    override init() {
        super.init()
        
        self.contextManager = BzWritableHolidayMOCManager()
        
        let context = contextManager.context()
        let entity = NSEntityDescription.entity(forEntityName: "Rokuyo", in: context)
    
        
        let appCalendar = NSCalendar.current //CalendarManager.shared().appCalendar()!
        var comp = DateComponents()
        comp.year = 2018
        comp.month = 12
        comp.day = 31
        let dt = appCalendar.date(from: comp)!
        
        do {
            
            print(context.hasChanges)
            
            var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Rokuyo")
            
            //fetchRequest.predicate = NSPredicate(format: "date == %@", dt as NSDate)
            
            if let result = try context.fetch(fetchRequest) as? [Rokuyo] {
                //print("need to delete result: ", result)

                for item in result {
                    context.delete(item)
                }
            }

            
            
            for year in 2000...2030 {
                
                let csvPath = self.documentDirectoryPath(year: year)
                //CSVファイルのデータを取得する。
                let csvData = try String(contentsOfFile:csvPath, encoding:String.Encoding.utf8)
                
                //改行区切りでデータを分割して配列に格納する。
                var dataList = csvData.components(separatedBy: "\n")
                //dataList.removeFirst()
                let csvDataCount = dataList.count
                dataList.removeFirst()
                for rowString in dataList {
                    if rowString.isEmpty {
                        continue
                    }
                    guard let rokuyo = NSManagedObject(entity: entity!, insertInto: context) as? Rokuyo else {
                        return
                    }

                    let cols = rowString.components(separatedBy: ",")
                    let year = Int(cols[0])
                    let month = Int(cols[1])
                    let day = Int(cols[2])
                    let rokuyoTitle = cols[13]
                    let rokuyoENTitle = self.rokuyoENTitles[rokuyoTitle]
                    
                    var comp = DateComponents()
                    comp.year = year
                    comp.month = month
                    comp.day = day
                    let dt = appCalendar.date(from: comp)!
                    rokuyo.date = dt
                    rokuyo.title = rokuyoTitle
                    rokuyo.titleEN = rokuyoENTitle
                    
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
                
                if self.rokuyo(from: fromDt, to: toDt) == false {
                    print("year: ", year, " false!")
                }

            }
            contextManager.exportToDocumentDir()

        }
        catch {
            print("error", error)
        }
    }
    
    func rokuyo(from:Date, to: Date) -> Bool {
        let calendar = NSCalendar.current

        let dayCountUnit : Set<Calendar.Component> = [ .day ]
        let dayCountComp = calendar.dateComponents(dayCountUnit, from: from, to:to)

        let expectedCount = dayCountComp.day! + 1
        
        let unitFlag : Set<Calendar.Component> = [ .year, .month, .day ]
        
        
        var compFrom = calendar.dateComponents(unitFlag, from: from)
        compFrom.hour = 0
        compFrom.minute = 0
        compFrom.second = 0
        
        let fromDt = calendar.date(from: compFrom)!
    
        var compTo = calendar.dateComponents(unitFlag, from: to)
        compTo.hour = 0;
        compTo.minute = 0;
        compTo.second = 0;
        let toDt = calendar.date(from: compTo)!
        let context = self.contextManager.context()
        
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Rokuyo")

        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date <= %@", fromDt as NSDate, toDt as NSDate)

        let result = try! context.fetch(fetchRequest)
        
        if expectedCount != result.count {
            print("missing: ", expectedCount - result.count)
            return false
        } else {
            return true
        }
        //
//    //NSArray* rtnArray = [[context executeFetchRequest:request error:&error] copy];
//    NSArray* rtnArray = [context executeFetchRequest:request error:&error];
//
//
//
//    return rtnArray;
    
    }

}
