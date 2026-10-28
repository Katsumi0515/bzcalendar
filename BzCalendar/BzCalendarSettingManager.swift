//
//  BzCalendarSettingManager.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/06/26.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit
import EventKit

protocol BZSelectedCalendarReader {
    func selectedEKCalendars() -> Array<EKCalendar>
    func selectEKCalendars(_ calendars: Array<EKCalendar>)
    
    func getEKCalendarWithIdentifier(ekIdentifier:String) -> EKCalendar?
    
}

@objc @objcMembers class BzCalendarSettingManager: NSObject, BZSelectedCalendarReader {
    

    static let shared : BZSelectedCalendarReader = BzCalendarSettingManager(moc: BzManagedObjectContextManager.shared.parentMOC())

    class func sharedManager() -> BzCalendarSettingManager {
        return self.shared as! BzCalendarSettingManager
    }
    
    
    fileprivate var context : NSManagedObjectContext
    fileprivate var _selectedEKCalendars: Array<EKCalendar> = Array()
    fileprivate let entityName = "CalendarSetting"

    
    // MARK: - パブリック
    // selectEKCalendars
    // セットする
    func selectEKCalendars(_ calendars: Array<EKCalendar>) {
        //CalendarSettingManager.shared().select(calendars)
        let appSetting_Calendar_List = self.allCoreData_CalendarSetting()
        
        let calendarSet : Set<EKCalendar> = Set(calendars)
        
        for cal in appSetting_Calendar_List {
            guard let calIdentifier = cal.identifier else {
                continue
            }
            if let ekCal = self.getEKCalendarWithIdentifier(ekIdentifier: calIdentifier) {
                if calendarSet.contains(ekCal) {
                    cal.selected = NSNumber(value:true)
                } else {
                    cal.selected = NSNumber(value:false)
                }
            }
        }
        let (_, error) = self.saveAllChangesInContext()
        if let error = error {
            print("error: ", error)
        }
        
    }
    
    fileprivate func saveAllChangesInContext() -> (Bool, Error?) {
        do {
            try self.context.save()
            self.loadSelectedEKCalendars()
            return (true, nil)
        }
        catch {
            print("error: ", error)
            return (false, error)
        }
    }

    // selectedEKCalendars
    // 取得する
    func selectedEKCalendars() -> Array<EKCalendar> {
        //return CalendarSettingManager.shared().selectedEKCalendars()
        
        // ToDo: キャッシュを返す　（設定を変更した側の通知で再設定しておく
        self.loadSelectedEKCalendars()
//        [self performSelectorOnMainThread:@selector(loadSelectedEKCalendars) withObject:nil waitUntilDone:YES];
        
        
        //    let store : EKEventStore = AppEventKit.shared().store()
        //    let arr = store.calendars(for: .event)
        //
        //    guard let calMgr = CalendarSettingManager.shared() else {
        //        fatalError()
        //    }
        //    var mutSet : Set<EKCalendar> = Set() //NSMutableSet(capacity:10)
        //
        //    if let appSetting_Calendar_List = calMgr.allCoreData_CalendarSetting() {
        //        for cal in appSetting_Calendar_List {
        //            if let calSetting = cal as? CalendarSetting {
        //                if calSetting.selected.boolValue == true  {
        //                    if let ekCal = calMgr.getEKCalendar(withIdentifier: calSetting.identifier) {
        //                        if arr.contains(ekCal) {
        //                            mutSet.insert(ekCal)
        //
        //                        }
        //                    }
        //                }
        //            }
        //        }
        //    }
        //    let selectableCalendars : Array<EKCalendar> = Array(mutSet)
        
        return self._selectedEKCalendars

    }
    
    func getEKCalendarWithIdentifier(ekIdentifier: String) -> EKCalendar? {
        //return CalendarSettingManager.shared().getEKCalendar(withIdentifier: ekIdentifier)
        
//        var rtnVal : EKCalendar? = nil
        
        guard let store = AppEventKit.shared.store() else {
            return nil
        }
//        let allEKCalendars = store.calendars(for: .event) //[store calendarsForEntityType:EKEntityTypeEvent];
        
        return store.calendar(withIdentifier: ekIdentifier)
//        for cal in allEKCalendars {
//            if cal.calendarIdentifier == ekIdentifier {
//                return cal
//            }
//        }

    }
    

    // MARK: - プライベート
    fileprivate func userSelectedCalendars() -> Array<CalendarSetting> {
//        NSEntityDescription* entity;
//        NSPredicate* predicate;
//        NSError* error = nil;
        var selectedCalendars: Array<CalendarSetting> = Array()

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        request.predicate = NSPredicate(format: "selected == YES")
        
        do {
            if let array = (try self.context.fetch(request) as? [CalendarSetting]) {
                selectedCalendars = array
            }
        }
        catch {
            print("error", error)
        }
        
        // upto here
        
        if( selectedCalendars.count == 0 ) {
            
            guard let store = AppEventKit.shared.store() else {
                return selectedCalendars
            }
            let ekAllCalendars = store.calendars(for: .event)
            
            for cal in ekAllCalendars {
                var isSelected = true
                if cal.title == "Birthdays" {
                    isSelected = false
                }
                self.addCalender(calendar: cal, selected: isSelected)
            }
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
            
            request.predicate = NSPredicate(format: "selected == YES")
            
            do {
                if let array = try context.fetch(request) as? Array<CalendarSetting> {
                    selectedCalendars = array
                }
                
            }
            catch {
                
            }
            //[[context executeFetchRequest:request error:&error] mutableCopy];
            
        }
        
        return selectedCalendars;

    }
    
    fileprivate func loadSelectedEKCalendars() {

        self._selectedEKCalendars.removeAll()
        guard let store = AppEventKit.shared.store() else {
            return
        }
        
        let selectecCales = self.userSelectedCalendars()
        
        let allEKCalendars = store.calendars(for: .event)
        
        for cal in allEKCalendars {
            for appCal in selectecCales {
                if cal.calendarIdentifier == appCal.identifier {
                    var isNewItem = true
                    for tmpCal in _selectedEKCalendars {
                        if tmpCal.calendarIdentifier == cal.calendarIdentifier {
                            isNewItem = false
                            break;
                        }
                    }
                    if isNewItem == true {
                        _selectedEKCalendars.append(cal)
                    }
                    continue
                }
            }
        }
    }

    fileprivate init(moc:NSManagedObjectContext) {
        self.context = moc
        self._selectedEKCalendars = Array()
        super.init()
        
        self.loadSelectedEKCalendars()
        
        //self.colorDict = [NSMutableDictionary dictionaryWithCapacity:10];

    }
    fileprivate override init() {
        fatalError()
    }

    fileprivate func addCalender(calendar:EKCalendar, selected:Bool) {
    
        let entity = NSEntityDescription.insertNewObject(forEntityName: self.entityName, into: self.context)
        
        guard let setting_calendar = entity as? CalendarSetting else {
            return
        }
    
        setting_calendar.identifier = calendar.calendarIdentifier;
        setting_calendar.title = calendar.title
        setting_calendar.selected = NSNumber(booleanLiteral: selected)

        let cgColor : CGColor = calendar.cgColor
        guard let colorSpace = cgColor.colorSpace else {
            return
        }
        
        var red   : CGFloat = CGFloat(1.0)
        var green : CGFloat = CGFloat(1.0)
        var blue  : CGFloat = CGFloat(1.0)
        
        
        switch ( colorSpace.model ) {
        case .monochrome:        //　whiteColorやblackColorはこちらになる
            if let comps = cgColor.components {
                red = comps[0] * 255
                green = red
                blue = red
            }
        case .rgb:
            if let comps = cgColor.components {
                red = comps[0]   * 255
                green = comps[1] * 255
                blue = comps[2]  * 255
            }
        default:
            break
        }
        let colorString = String(format:"#02x%02x%02x", Int(red), Int(green), Int(blue))
        setting_calendar.color = colorString
    
        do {
            try self.context.save()
        }
        catch {
            print("error", error)
        }
    }

    // コアデータのモデル配列の取得
    fileprivate func allCoreData_CalendarSetting() -> Array<CalendarSetting> {

        var iCloudCapable = false
        
        if let _ = FileManager.default.url(forUbiquityContainerIdentifier: nil) {
            iCloudCapable = true
        }
        
        self.syncCalendarList()

        let request = NSFetchRequest<NSFetchRequestResult>(entityName:self.entityName)
        
        do {
            guard let array = try self.context.fetch(request) as? [CalendarSetting] else {
                return Array()
            }
//            if( allCalendars != nil ) {
//                [allCalendars removeAllObjects];
//            }
            guard let store = AppEventKit.shared.store() else {
                return Array()
            }
            var toBeDeteledCals : Set<CalendarSetting> = Set()

            for calSetting in array  {
                if iCloudCapable == true, let calIdentifier = calSetting.identifier {
                    if let foundCal = store.calendar(withIdentifier: calIdentifier) {
                        if foundCal.source.sourceType == .local {
                            toBeDeteledCals.insert(calSetting)
                        }
                    }
                }
            }
            var rtnArray = array
            for cal in toBeDeteledCals {
                if let index = rtnArray.index(of: cal) {
                    rtnArray.remove(at: index)
                }
            }
            return rtnArray
        }
        catch {
            
            return Array()
        }

    }

    fileprivate func syncCalendarList() {
        guard let store = AppEventKit.shared.store() else {
            return
        }
        
        let allEKCalendars = store.calendars(for: .event)
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:self.entityName)
        
        do {
            guard let tmpCalenders = try self.context.fetch(request) as? [CalendarSetting] else {
                return
            }
            
            for ekCal in allEKCalendars {
                var found = false
                //var checkedCalendars : Array<CalendarSetting> = Array()
                var checkSet : Set<CalendarSetting> = Set(tmpCalenders)
                
                for cal in tmpCalenders {
                    if cal.identifier == ekCal.calendarIdentifier {
                        found = true
                        checkSet.remove(cal)
                        break
                    }
                }
                if found == false {
                    if ekCal.source.sourceType != .birthdays {
                        self.addCalender(calendar: ekCal, selected: true)
                    } else {
                        self.addCalender(calendar: ekCal, selected: false)
                    }
                }
                for cal in checkSet {
                    self.context.delete(cal)
                }
                try self.context.save()
                
            }
        }
        catch {
            print("error", error)
        }

    } // suncCalendarList
    
}
