//
//  BzHolidayManagedObjectContextManager.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/09.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import Foundation

class BzHolidayManagedObjectContextManager : NSObject {
    static let shared: BzHolidayManagedObjectContextManager = BzHolidayManagedObjectContextManager()
    
    fileprivate var persistentStoreCoordinator : NSPersistentStoreCoordinator
    fileprivate var managedObjectContext : NSManagedObjectContext
    
    func sharedContext() -> NSManagedObjectContext {
        return self.managedObjectContext
    }
    
    fileprivate override init() {
        // Holiday.momdのコンテキスト
        self.persistentStoreCoordinator = BzHolidayManagedObjectContextManager._localPersistentStoreCoordinator()
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        super.init()
    }
    
    fileprivate class func _localPersistentStoreCoordinator() -> NSPersistentStoreCoordinator {
        
        
        guard let holidayStorePath = Bundle.main.path(forResource: "Holiday", ofType: "sqlite") else {
            fatalError()
        }
        
        let storeURL = URL(fileURLWithPath: holidayStorePath)
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: BzHolidayManagedObjectContextManager.managedObjectModel())

        let sqliteOption : NSDictionary = [
            "journal_mode" : "DELETE"
        ]
        
        let options : [AnyHashable : Any] = [
            NSMigratePersistentStoresAutomaticallyOption: NSNumber(value: true),
            NSInferMappingModelAutomaticallyOption: NSNumber(value: true),
            NSReadOnlyPersistentStoreOption: NSNumber(value: true),
            NSSQLitePragmasOption:  sqliteOption 
        ]
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                      configurationName: nil,
                                                      at: storeURL,
                                                      options: options)
            
            return persistentStoreCoordinator
        }
        catch {
            fatalError()
        }

    }
    
    fileprivate class func managedObjectModel() -> NSManagedObjectModel {
    
        let path = Bundle.main.path(forResource: "Holiday", ofType: "momd")!
        let momURL : URL = URL(fileURLWithPath: path)

        return NSManagedObjectModel(contentsOf: momURL)!

    }
    

}
