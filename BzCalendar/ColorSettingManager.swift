//
//  ColorSettingManager.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/25.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

@objc @objcMembers class ColorSettingManager: NSObject {

    static var shared : ColorSettingManager = ColorSettingManager()
    fileprivate var context : NSManagedObjectContext

    fileprivate let entityName = "ColorSetting"
    fileprivate var appSettingColor: ColorSetting? = nil
    
    
    fileprivate func setup() {
        self.context.performAndWait {
            
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
            do {
                if let array = try context.fetch(request) as? Array<ColorSetting> {
                    if let item = array.first {
                        self.appSettingColor = item
                    }
                }
                
            }
            catch {
                print("error: ", error)
            }
        }
    }
    
    fileprivate override init() {
        self.context = BzManagedObjectContextManager.shared.parentMOC()
        super.init()
        self.setup()
    }
    
    fileprivate func _save() {
        self.context.perform {
            do {
                try self.context.save()
            }
            catch {
                print("error:", error)
            }
        }
    
    }

    func today() -> String? {
        if let settingColor = self.appSettingColor {
            return settingColor.today
        }
        return nil
    }
    func selected() -> String? {
        if let settingColor = self.appSettingColor {
            return settingColor.selected
        }
        return nil
    }
    func sunday() -> String? {
        if let settingColor = self.appSettingColor {
            return settingColor.sunday
        }
        return nil
    }
    func saturday() -> String? {
        if let settingColor = self.appSettingColor {
            return settingColor.saturday
        }
        return nil
    }
    func holiday() -> String? {
        if let settingColor = self.appSettingColor {
            return settingColor.holiday
        }
        return nil
    }
    func nonWork() -> String? {
        if let settingColor = self.appSettingColor {
            return settingColor.nonWork
        }
        return nil
    }
    // Change Color Code Methods  直ぐにコミットします
    func changeTodayColorCode(_ code:String) {
        if let settingColor = self.appSettingColor {
            settingColor.today = code
            self._save()
        }
    }
    func changeSelectedColorCode(_ code:String) {
        if let settingColor = self.appSettingColor {
            settingColor.selected = code
            self._save()
        }
    }
    func changeSundayColorCode(_ code:String) {
        if let settingColor = self.appSettingColor {
            settingColor.sunday = code
            self._save()
        }
    }
    func changeSaturdayColorCode(_ code:String) {
        if let settingColor = self.appSettingColor {
            settingColor.saturday = code
            self._save()
        }
    }
    func changeHolidayColorCode(_ code:String) {
        if let settingColor = self.appSettingColor {
            settingColor.holiday = code
            self._save()
        }
    }
    func changeNonWorkColorCode(_ code:String) {
        if let settingColor = self.appSettingColor {
            settingColor.nonWork = code
            self._save()
        }
    }

}
