//
//  BzAppThemeService.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/17.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import Foundation

class BzAppThemeColor {
    let colorName: String
    let colorCode: String
    let color: UIColor
    
    init(name:String, code:String, color:UIColor) {
        self.colorName = name
        self.colorCode = code
        self.color = color
    }
}
@objc @objcMembers class BzAppThemeService : NSObject {
    
    static let shared : BzAppThemeService = BzAppThemeService()
    class func sharedObject() -> BzAppThemeService {
        return BzAppThemeService.shared
    }
    fileprivate let BzAppThemeServiceKey_UserDefaultName : String = "BzCalendarAppTheme"
    fileprivate let BzAppThemeServiceKey_ThemeColorCode  : String = "ThemeColorCode"
    fileprivate let BzAppThemeServiceKey_ThemeTextColorCode : String = "ThemeTextColorCode"

    fileprivate let _defaultColor : UIColor = .orange
    fileprivate let _defaultTextColor : UIColor = .white
    
    fileprivate var _themeColorCode: String? = nil
    fileprivate var _themeColor: UIColor = .black 

    fileprivate var _themeTextColorCode: String? = nil
    fileprivate var _themeTextColor: UIColor = .white
    
    fileprivate var _barButtonItemTintColor: UIColor? = nil
    
    fileprivate func iCloudCapable() -> Bool {
        
        if let _ = FileManager.default.url(forUbiquityContainerIdentifier: nil) {
            return true
        }
        return false
    }

    fileprivate override init() {
        self._themeColorCode = nil
        super.init()
        self._themeColor = self._defaultColor
        self.loadTheme()
    }

    func themeColorList() -> Array<BzAppThemeColor> {
        var array : Array<BzAppThemeColor> = Array()

        var code = ColorUtil.shared.colorCode(color: .black)
        array.append( BzAppThemeColor(name: "Black", code: code, color:.black))
        
        code = ColorUtil.shared.colorCode(color: .orange)
        array.append( BzAppThemeColor(name: "Orange", code: code, color:.orange))
        

        if let color = ColorUtil.shared.UIColorFromColorCode("#800000") {
            array.append( BzAppThemeColor(name: "Maroon", code: "#800000", color:color))
        }
        
        if let color = ColorUtil.shared.UIColorFromColorCode( "#008800") {
            array.append( BzAppThemeColor(name: "Green", code: "#008800", color:color))
        }
        if let color = ColorUtil.shared.UIColorFromColorCode( "#008080") {
            array.append( BzAppThemeColor(name: "Teal", code: "#008080", color:color))
        }
        if let color = ColorUtil.shared.UIColorFromColorCode("#000080") {
            array.append( BzAppThemeColor(name: "Navy", code: "#000080", color:color))
        }
        if let color = ColorUtil.shared.UIColorFromColorCode("#800080") {
            array.append( BzAppThemeColor(name: "Purple", code: "#800080", color:color))
        }
        
        code = ColorUtil.shared.colorCode(color: .darkGray)
        array.append( BzAppThemeColor(name: "DarkGray", code: code, color:.darkGray))
        
        code = ColorUtil.shared.colorCode(color:  .blue)
        array.append( BzAppThemeColor(name: "Blue", code: code, color:.blue))
        
        if let color = ColorUtil.shared.UIColorFromColorCode( "#ff00ff") {
            array.append( BzAppThemeColor(name: "Fuchsia", code: "#ff00ff", color:color))
        }
         code = ColorUtil.shared.colorCode(color:  .red)
        array.append( BzAppThemeColor(name: "Red", code: code, color:.red))
        
        
//        open class var cyan: UIColor { get } // 0.0, 1.0, 1.0 RGB
//        open class var magenta: UIColor { get } // 1.0, 0.0, 1.0 RGB
//
        return array
    }
    func setThemeColor(code:String?) {
        if let code = code {
            self._themeColorCode = code
            self._themeColor = ColorUtil.shared.UIColorFromColorCode(code)!
        } else {
            self._themeColorCode = nil
            self._themeColor = self._defaultColor
        }
    }
    
    func setThemeTextColor(code:String?) {
        if let code = code {
            self._themeTextColorCode = code
            self._themeTextColor = ColorUtil.shared.UIColorFromColorCode(code)!
        } else {
            self._themeTextColorCode = nil
            self._themeTextColor = self._defaultTextColor
        }
    }

    func save(themeColorCode:String?, themeTextColorCode:String? = nil) -> Bool {
        self.setThemeColor(code: themeColorCode)
        self.setThemeTextColor(code: themeTextColorCode)
        self.applyTheme()
        
        if self.iCloudCapable() == true {
            if let code = self._themeColorCode, code.isEmpty == false {
                NSUbiquitousKeyValueStore.default.set(code, forKey: BzAppThemeServiceKey_ThemeColorCode)
            } else {
                NSUbiquitousKeyValueStore.default.removeObject(forKey: BzAppThemeServiceKey_ThemeColorCode)
            }
            NSUbiquitousKeyValueStore.default.set(self._themeTextColorCode, forKey: BzAppThemeServiceKey_ThemeTextColorCode)
            return NSUbiquitousKeyValueStore.default.synchronize()
        }
        if let userDefaults = UserDefaults(suiteName: BzAppThemeServiceKey_UserDefaultName) {
            userDefaults.set(self._themeTextColorCode, forKey: BzAppThemeServiceKey_ThemeColorCode)
            userDefaults.set(self._themeTextColorCode, forKey: BzAppThemeServiceKey_ThemeTextColorCode)

            return userDefaults.synchronize()
        }
        return false
    }
    fileprivate func loadTheme() {
        self._themeColorCode = nil
        self._themeColor = self._defaultColor
        self._themeTextColorCode = nil
        self._themeTextColor = self._defaultTextColor
        
        if self.iCloudCapable() == true {
            if let code = NSUbiquitousKeyValueStore.default.string(forKey: BzAppThemeServiceKey_ThemeColorCode) {
                self.setThemeColor(code: code)
                if let code = NSUbiquitousKeyValueStore.default.string(forKey: BzAppThemeServiceKey_ThemeTextColorCode) {
                    self.setThemeTextColor(code: code)
                }
                if let userDefaults = UserDefaults(suiteName: BzAppThemeServiceKey_UserDefaultName) {
                    userDefaults.removeObject(forKey: BzAppThemeServiceKey_ThemeColorCode)
                    userDefaults.removeObject(forKey: BzAppThemeServiceKey_ThemeTextColorCode)
                    userDefaults.synchronize()
                }
                return
            }
        }
        
        if let userDefaults = UserDefaults(suiteName: BzAppThemeServiceKey_UserDefaultName) {
            if let code = userDefaults.string(forKey: BzAppThemeServiceKey_ThemeColorCode) {
                self.setThemeColor(code: code)
                if let code = userDefaults.string(forKey: BzAppThemeServiceKey_ThemeTextColorCode) {
                    self.setThemeTextColor(code: code)
                }
            }
        }
    }
    
    func themeColorCode() -> String? {
        if let code = self._themeColorCode {
            return code
        }
        return nil
    }
    func themeColor() -> UIColor {
        return self._themeColor
    }
    func themeTintColor() -> UIColor {
        return self._themeTextColor
    }
    func themeTextColor() -> UIColor {
        return self._themeTextColor
    }
    func mainBackgroundColor() -> UIColor {
        return self._themeTextColor
    }
    func scheduleBackgoundColor() -> UIColor {
        return self._themeTextColor
    }
    func barButtonItemTintColor() -> UIColor {
        if let color = self._barButtonItemTintColor {
            return color
        }
        return self._themeTextColor
    }

    func applyTheme() {
        
        // まず、全体のtintColorの変更　（デフォルトはブルー）
        //[[UIView appearance] setTintColor: [designManager mainTintColor]];
        
        // ナビゲーションバー
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = self.themeColor()
        UINavigationBar.appearance().tintColor = self.themeTextColor()
        
//        [[UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[MFMailComposeViewController class]]] setBarTintColor:[UIColor whiteColor]];
        
        
        // タブバー
        UITabBar.appearance().barTintColor = self.themeColor()
        //[[UITabBar appearance] setSelectedImageTintColor:[UIColor blueColor]];
        UITabBar.appearance().tintColor = self.themeTintColor()
        UITabBar.appearance().unselectedItemTintColor = nil
        
        // ツールバー
        UIToolbar.appearance().barTintColor = self.themeColor()
        
        
        //[[UIBarButtonItem appearanceWhenContainedIn:
        //[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationItem class]]];
        
        UIBarButtonItem.appearance().tintColor = self.barButtonItemTintColor()
        
        
        BzMonthBar.appearance().backgroundColor = self.themeColor()
        BzDayBar.appearance().backgroundColor = self.themeColor()
        BzWeekBar.appearance().backgroundColor = self.themeColor()
        
        
    }
}
