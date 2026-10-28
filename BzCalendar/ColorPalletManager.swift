//
//  ColorPalletManager.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/28.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

// MARK: -
// TODO: - 使われるのは色の設定時のみ。CoreDataで扱う必要性は薄い
class ColorPalletManager: NSObject {
    static var shared : ColorPalletManager = ColorPalletManager()
    
    fileprivate var context : NSManagedObjectContext
    fileprivate var _orderedPallet : Array<ColorPallet> = Array()
    fileprivate var _colorDict : Dictionary<String, Array<ColorName>> = Dictionary()
    fileprivate var languageCode : String
    
    fileprivate override init() {
        self.context = BzManagedObjectContextManager.shared.parentMOC()
        self._orderedPallet = Array()
        self._colorDict = Dictionary()
        let locale = NSLocale.current
        if let langCode = (locale as NSLocale).object(forKey: .languageCode) as? String {
            self.languageCode = langCode
        } else {
            self.languageCode = "ja"
        }
        super.init()
        
        self.setupData()
    }
    func palletName(at index:Int) -> String {
        var rtnStr = ""
        if index < self.palletCount() {
            let pallet = self._orderedPallet[index]
            rtnStr = pallet.palletName
        }
        return rtnStr;
    }
    func palletData(at index:Int) -> Array<ColorName> {
        if index < self.palletCount() {
            let pallet = self._orderedPallet[index]
            let key = pallet.palletID
            if let array = self._colorDict[key] {
                return array
            }
        }
        return Array()
    }
    func palletCount() -> Int {
        return self._orderedPallet.count
    }

    // MARK: -
    fileprivate func setupData() {
        let locale = NSLocale.current
        if let langCode = (locale as NSLocale).object(forKey: .languageCode) as? String {
            self.languageCode = langCode
        }
        
        self._setupOrderedPallets()

        for pallet in self._orderedPallet {
            let elementObject = self._getPalletData(palletID: pallet.palletID)
            self._colorDict[pallet.palletID] = elementObject
        }
    }
    
    fileprivate func _setupOrderedPallets() {
        let locale = NSLocale.current

        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"ColorPallet")
        if let langCode = (locale as NSLocale).object(forKey: .languageCode) as? String {
            request.predicate = NSPredicate(format:"lang = %@", langCode)
        }

        do {
            if let array = try self.context.fetch(request) as? [ColorPallet] {
                let sortedArray = array.sorted {
                    $0.index.intValue < $1.index.intValue
                }
                self._orderedPallet = sortedArray
            } else {
                self._orderedPallet = Array()
            }
        }
        catch {
            print("error", error)
            self._orderedPallet = Array()
        }
    }

    fileprivate func _getPalletData(palletID: String) -> Array<ColorName> {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"ColorPallet_Item")
        request.predicate = NSPredicate(format:"palletID = %@", palletID)
    
        do {
            if let array = try self.context.fetch(request) as? [ColorPallet_Item] {
            
                let sortedArray = array.sorted {
                    $0.itemNo.intValue < $1.itemNo.intValue
                }

                var rtnArray : Array<ColorName> = Array()
                for item in sortedArray {
                    let colorCode = ColorName()
                    colorCode.colorCode = item.colorCode
                    colorCode.colorName = self._getColorName(item: item)
                    rtnArray.append( colorCode )
                }
                return rtnArray
            }
        }
        catch {
            print("error:", error)
        }
        return Array()

    }

    fileprivate func _getColorName(item: ColorPallet_Item) -> String {
        var rtnStr = ""

        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"ColorCode")
        request.predicate = NSPredicate(format:"palletID = %@ and colorCode = %@ and lang = %@", item.palletID,
                                        item.colorCode,
                                        self.languageCode)


        do {
            let array = try self.context.fetch(request)
            if let colorCode = array.first as? ColorCode, let name = colorCode.colorName {
                return name
            } else if let name = item.defaultColorName {
                return name
            }
        }
        catch {
            print("error" , error)
        }
    
        return rtnStr
    
    }

}
