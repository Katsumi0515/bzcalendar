//
//  BzSystemActivityManager.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/29.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

@objc @objcMembers class BzSystemActivityManager: NSObject {
    static var shared : BzSystemActivityManager = BzSystemActivityManager()

    fileprivate var context : NSManagedObjectContext
    fileprivate var _systemActivity : SystemActivity? = nil 

    fileprivate override init() {
        self.context = BzManagedObjectContextManager.shared.parentMOC()
        super.init()
        self.context.performAndWait() {

            let request = NSFetchRequest<NSFetchRequestResult>(entityName:"SystemActivity")
            
            do {
                let array = try self.context.fetch(request)
                if let item = array.first as? SystemActivity {
                    self._systemActivity = item
                    if item.installDate == nil {
                        item.installDate = Date()
                        try self.context.save()
                    }
                } else {
                    if let activity = NSEntityDescription.insertNewObject(forEntityName: "SystemActivity", into: self.context) as? SystemActivity {
                        activity.isTring_iCloud = NSNumber(value:false)
                        activity.installDate = Date()
                        self._systemActivity = activity
                        try self.context.save()
                    }
                }
            }
            catch {
                print("error", error)
            }
        }
    }
    
    // MARK: - パブリック
    func isTring_iCloud() -> Bool {
        return false
        //        var rtnVal = false
//        /*
//         if( self._systemActivity && self._systemActivity.isTring_iCloud ) {
//         rtnVal = [self._systemActivity.isTring_iCloud boolValue];
//         }
//         */
//        /*
//         if( [_registerdObjects count] > 0 ) {
//         rtnVal = TRUE;
//         }
//         */
//        return rtnVal
    }
    func lastDisplayMode() -> AppCalendarDisplayMode {
        
        var mode : AppCalendarDisplayMode = AppCalendarDisplayModeDaily
        if let systemActivity = self._systemActivity, let lastDisplayMode = systemActivity.lastDisplayMode {
            mode = AppCalendarDisplayMode(rawValue: AppCalendarDisplayMode.RawValue(lastDisplayMode.intValue))
        }        
        return mode;
    }
    
    func saveCurrentDisplayMode(mode:AppCalendarDisplayMode) {
        guard let systemActivity = self._systemActivity else {
            return
        }
        if mode != AppCalendarDisplayModeKeepPreviousMode {
            let modeNum = NSNumber(value:Int(mode.rawValue))
            systemActivity.lastDisplayMode = modeNum
            try! self.context.save()
        }
    }

    //-(void) _setTring_iCloud:(BOOL)bl {
    //    LOG_METHOD;
    //    [self.context performBlock:^{
    //        if( self._systemActivity ) {
    //            LOG(@"setting isTring_iCloud value:%d", bl);
    //
    //            NSNumber* num = [NSNumber numberWithBool:bl];
    //            self._systemActivity.isTring_iCloud = num;
    //            NSError* error = nil;
    //            [self.context save:&error];
    //            if( error ) {
    //                LOG(@"error: %@", error);
    //            }
    //        }
    //    }];
    //}

}
