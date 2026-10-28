//
//  BzCalendarExtensionManager.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/31.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzCalendarExtensionManager: NSObject {

    static var shared : BzCalendarExtensionManager = BzCalendarExtensionManager()

    fileprivate var cacheInProcess : Bool = false
    fileprivate var _extensionDict : Dictionary<String, CalendarExtension> = Dictionary()
    fileprivate var _privateMoc : NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    fileprivate override init() {
        super.init()
        self.clearCache()
    }
    
    func setPrivateContext(_ privateContext: NSManagedObjectContext) {
        self._privateMoc = privateContext
        self.clearCache() {
            error in
            
        }
    }
    
    func addExtensionTo(calendar:EKCalendar, callback:@escaping ((CalendarExtension)->Void)) {
        if let ext = self.getExtensionOf(calendar: calendar) {
            callback( ext )
            return
        }
        
        var newExtension : CalendarExtension!
        self._privateMoc.perform {
            
            newExtension = NSEntityDescription.insertNewObject(forEntityName: "CalendarExtension", into: self._privateMoc) as! CalendarExtension
            newExtension.identifier = calendar.calendarIdentifier
            self._extensionDict[newExtension.identifier!] = newExtension
            callback( newExtension )
            return
        }

    }
    func getExtensionOf(calendar:EKCalendar) -> CalendarExtension? {
        if self.cacheInProcess == true {
            return nil
        }
        return self._extensionDict[calendar.calendarIdentifier]
    }

    func clearCache(completionHandler:((_ : Error?) -> Swift.Void)? = nil) {
        
        self.cacheInProcess = true
        
        self._privateMoc.perform {

            let context = self._privateMoc
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName:"CalendarExtension")
            let asyncRequest = NSAsynchronousFetchRequest(fetchRequest: request) {
                asyncFetchResult in
                if let error = asyncFetchResult.operationError {
                    if let handler = completionHandler {
                        handler(error)
                    }
                    self.cacheInProcess = false
                    return
                }
                self._extensionDict = Dictionary()
                if let array = asyncFetchResult.finalResult as? [CalendarExtension] {
                    for calExt in array {
                        if let identifier = calExt.identifier {
                            self._extensionDict[identifier] = calExt
                        }
                    }
                }
                self.cacheInProcess = false
                if let handler = completionHandler {
                    handler(nil)
                }
                return
            }
            
            do {
                try context.execute(asyncRequest)
            }
            catch {
                print("error", error)
                if let handler = completionHandler {
                    handler(error)
                }
                return
            }            

        }
                    

    }
    
    func saveAllChangesInContext(completionHandler:((_ : Error?) -> Swift.Void)? = nil) {
        self._privateMoc.perform {
            do {
                try self._privateMoc.save()
                if let parentMoc = self._privateMoc.parent {
                    try parentMoc.save()
                }
                self.clearCache() {
                    error in
                    if let handler = completionHandler {
                        handler(error)
                    }
                    return
                }
            }
            catch {
                if let handler = completionHandler {
                    handler(error)
                }
                return
            }
            
            
        }
        

    }
    
}
