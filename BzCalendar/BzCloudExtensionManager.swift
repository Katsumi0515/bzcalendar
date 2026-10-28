//
//  BzCloudExtensionManager.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/29.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

@objc @objcMembers class BzCloudExtensionManager: NSObject {
    static var shared : BzCloudExtensionManager = BzCloudExtensionManager()
    
    fileprivate var context : NSManagedObjectContext
    fileprivate var _cloudExtension : CloudExtension? = nil
    
    fileprivate override init() {
        self.context = BzManagedObjectContextManager.shared.parentMOC()
        super.init()
        self.context.performAndWait() {
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName:"CloudExtension")
            
            do {
                let array = try self.context.fetch(request)
                if let item = array.first as? CloudExtension {
                    self._cloudExtension = item
                } else {
                    if let cloudExtension = NSEntityDescription.insertNewObject(forEntityName: "CloudExtension", into: self.context) as? CloudExtension {
                        cloudExtension.iCloudEnabled = NSNumber(value:false)
                        self._cloudExtension = cloudExtension
                        try self.context.save()
                    }
                }
            }
            catch {
                print("error", error)
            }
        }
    } // init
    
    func iCloudEnabled() -> Bool {
        var rtnVal = false
        if let cloudExtension = self._cloudExtension {
            rtnVal = cloudExtension.iCloudEnabled.boolValue
        }
        return rtnVal
    }

    func set_iCloudEnabled(_ enabled:Bool) {
        guard let cloudExtension = self._cloudExtension else {
            return
        }
        let curNum = cloudExtension.iCloudEnabled
        let newNum = NSNumber(value:enabled)
        self._set_CloudExtentionEnabled(enabled: enabled) {
            (error:Error?) in
            
            if let error = error {
                
            } else {
                if curNum.boolValue != newNum.boolValue {
                    BzEventExtensionService.shared().preferToUseICloud(preferICloud: enabled) {
                        error in
                        
                    }
                }
            }
        }
    }

    fileprivate func _set_CloudExtentionEnabled(enabled:Bool, completionBlock:@escaping(_ error:Error?) -> Void) {
        self.context.perform() {
            if let cloudExtension = self._cloudExtension {
            
                let newNum = NSNumber(value:enabled)
                cloudExtension.iCloudEnabled = newNum
                
                do {
                    try self.context.save()
                    completionBlock(nil)
                }
                catch {
                    completionBlock(error)
                }
            }
        }
    }
    
}
