//
//  BzCloudManager.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/04/18.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

@objc public extension NSNotification {
    public static var BzCalendar_iCloudData_Ready: NSString {
        return "BzCalendar_iCloudData_Ready"
    }
}

// MARK: - iCloud上のみに保存するデータをまとめて管理している
// TODO: -
// 本来、データをどこで保存するかで１つのクラスにまとめる必要はないので、永続化とデータモデルの切り離しが必要
//
//

@objc @objcMembers class BzEventExtensionService: NSObject {

    fileprivate static var singleton: BzEventExtensionService? = nil

    fileprivate var eventExtDict : Dictionary<String, EventExtension> = Dictionary()
    fileprivate var bzCloudManagedObjectContextManager : BzCloudMOCManagerProtocol?
        //= BzCloudManagedObjectContextManager.shared()
    
    fileprivate var calendarExtensionManager : BzCalendarExtensionManager? = nil
    fileprivate var eventExtensionManager : BzEventExtensionManager? = nil
    fileprivate var eventTamplateManager : BzEventTamplateManager? = nil
    
    fileprivate var cacheCalendarTimer : Timer? = nil
    fileprivate var cacheEventTimer : Timer? = nil
    fileprivate var cacheTemplateTimer : Timer? = nil

    class func shared() -> BzEventExtensionService {
        if let singleton = singleton {
            return singleton
        }
        
        singleton = BzEventExtensionService()
        guard let service = singleton else {
            fatalError()
        }
        service.switchContextManager() {
            (error) in
            if( error != nil ) {
                fatalError()
            }
        }
        return singleton!
    }
    
    @objc func clearCacheByNotification(note:Notification) {
        
        if let manager = self.calendarExtensionManager {
            if let timer = self.cacheCalendarTimer {
                if timer.isValid == true {
                    timer.invalidate()
                }
            }
            self.cacheCalendarTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {
                (timer) in
                manager.clearCache() {
                    (error) in
                    
                }
            }
        }

//        if let manager = self.eventExtensionManager {
//            if let timer = self.cacheEventTimer {
//                if timer.isValid == true {
//                    timer.invalidate()
//                }
//            }
//            self.cacheEventTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {
//                (timer) in
//                manager.clearCache() {
//                    (error) in
//                    
//                }
//            }
//        }
        
        if let manager = self.eventTamplateManager {
            if let timer = self.cacheTemplateTimer {
                if timer.isValid == true {
                    timer.invalidate()
                }
            }
            self.cacheTemplateTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {
                (timer) in
                manager.clearCache() {
                    (error) in
                    
                }
            }
        }
        
    }

    fileprivate override init() {
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(clearCacheByNotification(note:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSPersistentStoreCoordinatorStoresDidChange,
                                               object: nil,
                                               queue: nil) {
                                                (note) in
                                                self.clearCacheByNotification(note: note)

        }

    }
    
    func iCloudReadyToUser() -> Bool {
        // ToDo: iCloudが準備オッケーかどうかのロジックのちゃんとした実装
        guard let contextManager = self.bzCloudManagedObjectContextManager else {
            return false
        }
        return contextManager.isReadyToUse()
    }
    func processPendingChanges() {
        guard let contextManager = self.bzCloudManagedObjectContextManager else {
            return
        }
        return contextManager.processPendingChanges()
    }
    // MARK: - iCloudを永続化に使うかどうかの切り替え
    
    fileprivate func createNewPrivateContext(parentContext:NSManagedObjectContext) -> NSManagedObjectContext {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.automaticallyMergesChangesFromParent = true
        privateContext.parent = parentContext
        return privateContext
    }
    
    fileprivate func setupContextManager(contextManager:BzCloudMOCManagerProtocol?) {
        self.bzCloudManagedObjectContextManager = contextManager
        
        if let contextManager = contextManager {
            self.calendarExtensionManager = BzCalendarExtensionManager.shared
            self.eventExtensionManager = BzEventExtensionManager.shared()
            self.eventTamplateManager = BzEventTamplateManager.shared()
            if let parentContext = contextManager.bzCloudContext() {
                self.calendarExtensionManager?.setPrivateContext(self.createNewPrivateContext(parentContext: parentContext))
                self.eventExtensionManager?.setPrivateContext(self.createNewPrivateContext(parentContext: parentContext))
                self.eventTamplateManager?.setPrivateContext(self.createNewPrivateContext(parentContext: parentContext))
            }

        } else {
            self.calendarExtensionManager = nil
            self.eventExtensionManager = nil
            self.eventTamplateManager = nil
        }
    }
    
    fileprivate func switchContextManager(completionHandler: @escaping (_ error:Error?)->Void) {
        // Disable at once
        self.calendarExtensionManager = nil
        self.eventExtensionManager = nil
        self.eventTamplateManager = nil

        if self.iCloudAvailable() == true {
            BzCloudManagedObjectContextManager.createContextManager {
                (contextManager, error) in
                
                if let error = error {
                    print("createContextManager error: ", error)
                    completionHandler(error)
                    return
                }
                guard let contextManager = contextManager else {
                    fatalError()
                    //return
                }
                self.setupContextManager(contextManager: contextManager)
                completionHandler(nil)
            }
        } else {
            self.setupContextManager(contextManager: nil)
            completionHandler(nil)

            return;
//            BzFallbackManagedObjectContextManager.createContextManager {
//                (contextManager, error) in
//                if let error = error {
//                    print("createContextManager error: ", error)
//                    completionHandler(error)
//                    return
//                }
//                guard let contextManager = contextManager else {
//                    fatalError()
//                    //return
//                }
//                self.setupContextManager(contextManager: contextManager)
//                completionHandler(nil)
//            }
            
        }
    }
    
    func preferToUseICloud(preferICloud:Bool, completionHandler: @escaping (_ error:Error?)->Void) {
        guard let _ = self.bzCloudManagedObjectContextManager else {
            completionHandler(nil)
            return
        }
        if preferICloud == true {
            if self.iCloudAvailable() == false {
                completionHandler(nil)
                return
            }
        }
        self.switchContextManager(completionHandler: completionHandler)
        
    }
    
    // MARK:-
    fileprivate func iCloudAvailable() -> Bool {
        return CalendarManager.shared().iCloudEnabledByUserAndSystem()
    }
    
}

// MARK: - カレンダーExtension
extension BzEventExtensionService {
    func calendarExtension(calendar:EKCalendar) -> CalendarExtension? {
        if let manager = self.calendarExtensionManager {
            return manager.getExtensionOf(calendar: calendar)
        }
        return nil
    }
    func createExtention(calendar:EKCalendar, callback:@escaping ((CalendarExtension?) -> Void)) {
        if let manager = self.calendarExtensionManager {
            manager.addExtensionTo(calendar:calendar) {
                ext in
                callback( ext )
            }
        }
        callback( nil )
    }
    
//    func addExtension(calendar:EKCalendar) -> CalendarExtension? {
//        // ToDo:
//        // 空のCalendarExtensionを返さないで、生成に必要なパラメータを受け取って生成。
//        
//        if let manager = self.calendarExtensionManager {
//            return manager.addExtensionTo(calendar:calendar)
//        }
//        return nil
//    }
    
    //saveAllChangesInContext
    func saveAllChangesInCalendarExtentions(completionHandler: @escaping (_ error:Error?)->Void) {
        guard let manager = self.calendarExtensionManager else {
            completionHandler(nil)
            return
        }
        
        manager.saveAllChangesInContext() {
            error in
            completionHandler(error)
        }
    }

}

// MARK: - イベントテンプレート
extension BzEventExtensionService {
    // 取得系
    //-(NSArray*)getEventTemplatesOfDefaultGroup; // 現状はデフォルトグループのみサポート
    func eventTemplate() -> Array<AppEventTemplate> {
        
        if let manager = self.eventTamplateManager {
            if let array = manager.getEventTemplatesOfDefaultGroup() as? Array<AppEventTemplate> {
                return array
            }
        }
        return Array()
    }
    
    // 変更系
    //-(void) addNewTemplate:(AppEventTemplate*) eventTemplate;   // 即永続化
    func add(eventTemplate:AppEventTemplate, completionHandler: @escaping (_ error:Error?)->Void){
        if let manager = self.eventTamplateManager {
            manager.addNewTemplate(eventTemplate) {
                error in
                completionHandler(error)
            }
        } else {
            fatalError("eventTeamplateManager is nil")
        }
        
    }
    //-(void) updateTemplate:(AppEventTemplate*) eventTemplate;   // 即永続化
    func update(eventTemplate:AppEventTemplate, completionHandler: @escaping (_ error:Error?)->Void){
        if let eventTamplateManager = self.eventTamplateManager {
            eventTamplateManager.update(eventTemplate) {
                error in
                completionHandler(error)
            }
        } else {
            fatalError("BzEventTamplateManager is nil")
        }
    }
    //-(void) deleteTemplate:(AppEventTemplate*) eventTemplate;   // 即永続化
    func delete(eventTemplate:AppEventTemplate) {
        if let eventTamplateManager = self.eventTamplateManager {
            eventTamplateManager.delete(eventTemplate)
        }
        // ToDo: エラー処理
    }
    

}

// MARK: - イベントExtension
// TODO: このクラスの削除
// EKEventのエクステンションは、数が増えると検索処理が重くなる
// 検索処理を早くするにはDateでのインデックス等、データベースの再設計やチューニングが必須となる
// そのため現在は過去のデータの取得のみとする
// CoreDataのiCloud上での保存方法が、iOSのAPIとして将来性が見えない事もこの決定の理由の１つ
//
extension BzEventExtensionService {
    
//    func allEventIdentifiers() -> Array<Any> {
//        if let bzEventExtensionManager = self.eventExtensionManager {
//            return bzEventExtensionManager.getAllIdentifiers()
//        }
//        return Array()
//    }
    
    func eventExtension(event:EKEvent) -> EventExtension? {
        if let bzEventExtensionManager = self.eventExtensionManager {
            return bzEventExtensionManager.getExtensionOf(event)
        }
        return nil
    }
    
//    func addExtension(event:EKEvent) -> EventExtension? {
//        // ToDo:
//        // 生成はプライベートスレッドでいい
//        if let manager = self.eventExtensionManager {
//            return manager.addExtension(to:event)
//        }
//        return nil
//    }
    
//    func deleteAndSave(eventExtension:EventExtension, completionHandler: @escaping (_ error:Error?)->Void) {
//        if let manager = self.eventExtensionManager {
//            manager.delete(eventExtension)
//            manager.saveAllChanges(inContext: completionHandler)
//        } else {
//            // ToDo: エラー
//            completionHandler(nil)
//        }
//    }
    
    func saveAllChangesInEventExtensions(completionHandler: @escaping (_ error:Error?)->Void) {
        if let manager = self.eventExtensionManager {
            manager.saveAllChanges(inContext: completionHandler)
        }
        completionHandler(nil)
    }

}
