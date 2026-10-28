//
//  BzWritableHolidayMOCManager.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/06/20.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit
import CoreData

class BzWritableHolidayMOCManager: NSObject {

    fileprivate var _persistentStoreCoordinator : NSPersistentStoreCoordinator? = nil
    fileprivate var _managedObjectModel : NSManagedObjectModel? = nil
    fileprivate var managedObjectContext : NSManagedObjectContext? = nil

    override init() {
        super.init()
        let coordinator = self._localPersistentStoreCoordinator()
        // Holiday.momdのコンテキスト
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.managedObjectContext!.persistentStoreCoordinator = coordinator
        
    }
    
    func context() -> NSManagedObjectContext {
        return self.managedObjectContext!
    }
    func exportToDocumentDir() {
        let fileManager = FileManager.default
        let fromPath = self.applicationSupportDirectoryHolidayDBPath()
        let toPath = self.documentDirectoryExportDBPath()
        
        do {
            if fileManager.fileExists(atPath: toPath) {
                try fileManager.removeItem(atPath: toPath)
            }
            //if !fileManager.fileExists(atPath: dbPath) {
            try fileManager.copyItem(atPath: fromPath, toPath: toPath)
            //}
        }
        catch {
            print("error: ", error)
        }
    }
    
    fileprivate func applicationSupportDirectoryHolidayDBPath() -> String {
        let fileManager = FileManager.default
        let dbPath = try! fileManager
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("Holiday.sqlite")
            .path
        return dbPath
    }
    fileprivate func documentDirectoryExportDBPath() -> String {
        let fileManager = FileManager.default
        let dbPath = try! fileManager
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("Holiday.sqlite")
            .path
        return dbPath
    }
    fileprivate func resourceDBPath() -> String {
        let dbResourcePath = Bundle.main.path(forResource: "Holiday", ofType: "sqlite")!
        return dbResourcePath
    }
    fileprivate func _localPersistentStoreCoordinator() -> NSPersistentStoreCoordinator {
        if let coordinator = self._persistentStoreCoordinator {
            return coordinator
        }
        let fileManager = FileManager.default

        // 作業可能な場所
        let dbPath = self.applicationSupportDirectoryHolidayDBPath()


        let dbResourcePath = self.resourceDBPath()
        do {

            if fileManager.fileExists(atPath: dbPath) {
                try fileManager.removeItem(atPath: dbPath)
            }
            //if !fileManager.fileExists(atPath: dbPath) {
            try fileManager.copyItem(atPath: dbResourcePath, toPath: dbPath)
            //}
            let storeURL = URL(fileURLWithPath: dbPath)
            self._persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel())
            
            let options : [AnyHashable : Any] =  [NSSQLitePragmasOption : ["journal_mode" : "DELETE"] ]

            //        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
            //            [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
            //                                           [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
            //                                           nil];

            try self._persistentStoreCoordinator?.addPersistentStore(ofType:NSSQLiteStoreType , configurationName: nil, at: storeURL, options: options)
        }
        catch {
            print("error:", error)
            
        }
        
        return self._persistentStoreCoordinator!

    }
    
    fileprivate func managedObjectModel() -> NSManagedObjectModel {
    
        if let model = self._managedObjectModel {
            return model
        }
        let path = Bundle.main.path(forResource: "Holiday", ofType: "momd")!
        let momURL = URL(fileURLWithPath: path)
        self._managedObjectModel = NSManagedObjectModel(contentsOf: momURL)
    

        return self._managedObjectModel!
    }

}
