//
//  BzManagedObjectContextManager.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/25.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

@objc @objcMembers class BzManagedObjectContextManager: NSObject {

    static let shared: BzManagedObjectContextManager = BzManagedObjectContextManager()
   
    fileprivate var persistentStoreCoordinator : NSPersistentStoreCoordinator
    fileprivate var managedObjectContext : NSManagedObjectContext
    fileprivate static var copiedFromFile = false

    func sharedContext() -> NSManagedObjectContext {
        return self.managedObjectContext
    }

    fileprivate override init() {

        BzManagedObjectContextManager.copiedFromFile = false
        self.persistentStoreCoordinator = BzManagedObjectContextManager._localPersistentStoreCoordinator()
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        super.init()
        // 初めて起動した時は日本文化以外のユーザーの設定をする（六曜のオフ）
        if BzManagedObjectContextManager.copiedFromFile == true {
            let locale = Locale.current as NSLocale
            
            guard let countryCode = locale.object(forKey: .countryCode) as? String,
                let langCode    = locale.object(forKey: .languageCode) as? String,
                countryCode == "JP", langCode == "ja" else {
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BasicAppSetting")
                    do {
                        if let basicAppSetting = try self.managedObjectContext.fetch(request).first as? BasicAppSetting {
                            basicAppSetting.isRokuyoOn = NSNumber(booleanLiteral: false)
                            try self.managedObjectContext.save()
                        }
                    }
                    catch {
                        
                    }

                    return
            }

        }

    }
    
    // パブリック
    func parentMOC() -> NSManagedObjectContext {
        return self.managedObjectContext
    }

    func save() -> Error? {
        do {
            try self.managedObjectContext.save()
        }
        catch {
            return error
        }
        return nil
    }

    
    // MARK: - プライベート
    
    fileprivate class func _localPersistentStoreCoordinator() -> NSPersistentStoreCoordinator {
        

        let fileManager = FileManager.default
    
        let fileName : String = "BzCalendar.sqlite"
        let applicationDocumentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!

        let storePath = (applicationDocumentsDirectory as NSString).appendingPathComponent(fileName)
        
        if fileManager.fileExists(atPath: storePath) == false {
            // storePathが存在しない（＝インストール後の初回起動時）の場合でフォルトストアからコピーする
            //        guard let storePath = Bundle.main.path(forResource: "BzCalendar", ofType: "sqlite") else {
            //            fatalError()
            //        }

            let defaultStorePath = Bundle(for: BzManagedObjectContextManager.self).path(forResource: "BzCalendar", ofType: "sqlite")!
            do {
                try fileManager.copyItem(atPath: defaultStorePath, toPath: storePath)
                BzManagedObjectContextManager.copiedFromFile = true
            }
            catch {
                print("BzCalendar.sqliteのコピーに失敗 error:", error)
            }
        }

        let storeURL = URL(fileURLWithPath: storePath)
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: BzManagedObjectContextManager.managedObjectModel())
        
//        let sqliteOption : NSDictionary = [
//            "journal_mode" : "DELETE"
//        ]
        
        let options : [AnyHashable : Any] = [
            NSMigratePersistentStoresAutomaticallyOption: NSNumber(value: true),
            NSInferMappingModelAutomaticallyOption: NSNumber(value: true),
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
        
        let path = Bundle.main.path(forResource: "BzCalendar", ofType: "momd")!
        let momURL : URL = URL(fileURLWithPath: path)
        
        return NSManagedObjectModel(contentsOf: momURL)!
        
    }

}
