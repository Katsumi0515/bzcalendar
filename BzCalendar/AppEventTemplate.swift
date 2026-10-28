//
//  AppEventTemplate.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/31.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

@objc @objcMembers class AppEventTemplate: NSObject, NSCoding {
    
    var templateGroupName : String? = nil
    var templateName : String? = nil
    
    var title : String? = nil
    var allDay : Bool = false
    var location : String? = nil
    var notes : String? = nil
    var calendar : EKCalendar? = nil
    
    var alarms : Array<EKAlarm>? = nil
    var availability : EKEventAvailability? = nil
    
    var status : EKEventStatus?  = nil
    
    var attendees : Array<EKParticipant>? = nil
    var organizer : EKParticipant? = nil
    
    var startTimeComps : DateComponents? = nil
    var eventLengthComps : DateComponents? = nil
    
    var recurrenceRules : Array<EKRecurrenceRule>? = nil
    var timeZone: TimeZone? = nil
    
    var customColor : UIColor? = nil
    var customTextColor : UIColor? = nil

    fileprivate var _cdEventTemplate : CDEventTemplate? = nil

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.templateGroupName, forKey:"templateGroupName")
        aCoder.encode(self.templateName, forKey:"templateName")
        aCoder.encode(self.title, forKey:"title")
        aCoder.encode(self.allDay, forKey: "allDay")
        aCoder.encode(self.location, forKey:"location")
        aCoder.encode(self.notes, forKey:"notes")
        aCoder.encode(self.calendar, forKey:"calendar")
        aCoder.encode(self.alarms, forKey:"alarms")

        if let intValue = self.availability?.rawValue {
            aCoder.encode(intValue, forKey: "availability")
        }
        if let intValue = self.status?.rawValue {
            aCoder.encode(intValue, forKey: "status")
        }
        aCoder.encode(self.attendees, forKey: "attendees")
        //[encoder encodeObject:nil forKey:@"organizer"];
        aCoder.encode(self.recurrenceRules, forKey: "recurrenceRules")
        aCoder.encode(self.timeZone, forKey: "timeZone")

        
        if let color = self.customColor {
            let colorCd = ColorUtil.shared.colorCode(color: color)
            aCoder.encode(colorCd, forKey: "bgColorCode")
        }
        if let color = self.customTextColor {
            let colorCd = ColorUtil.shared.colorCode(color: color)
            aCoder.encode(colorCd, forKey: "textColorCode")
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        if let templateGroupName = aDecoder.decodeObject(forKey: "templateGroupName") as? String {
            self.templateGroupName = templateGroupName
        }
        if let templateName = aDecoder.decodeObject(forKey: "templateName") as? String {
            self.templateName = templateName
        }
        if let title = aDecoder.decodeObject(forKey: "title") as? String {
            self.title = title
        }
        self.allDay = aDecoder.decodeBool(forKey: "allDay")
        if let location = aDecoder.decodeObject(forKey: "location") as? String {
            self.location = location
        }
        if let notes = aDecoder.decodeObject(forKey: "notes") as? String {
            self.notes = notes
        }
        if let calendar = aDecoder.decodeObject(forKey: "notes") as? EKCalendar {
            self.calendar = calendar
        }
        if let alarms = aDecoder.decodeObject(forKey: "alarms") as? [EKAlarm] {
            self.alarms = alarms
        }
        if aDecoder.containsValue(forKey: "availability") {
            self.availability = EKEventAvailability(rawValue: aDecoder.decodeInteger(forKey: "availability"))
        }
        if aDecoder.containsValue(forKey: "status") {
            self.status = EKEventStatus(rawValue: aDecoder.decodeInteger(forKey: "status"))
        }
        if let attendees = aDecoder.decodeObject(forKey: "attendees") as? [EKParticipant] {
            self.attendees = attendees
        }
        if let recurrenceRules = aDecoder.decodeObject(forKey: "recurrenceRules") as? [EKRecurrenceRule] {
            self.recurrenceRules = recurrenceRules
        }
        if let timeZone =  aDecoder.decodeObject(forKey: "timeZone") as? TimeZone {
            self.timeZone = timeZone
        }
        if let colorCd = aDecoder.decodeObject(forKey: "bgColorCode") as? String {
            self.customColor = ColorUtil.shared.UIColorFromColorCode(colorCd)
        }
        if let colorCd = aDecoder.decodeObject(forKey: "textColorCode") as? String {
            self.customTextColor = ColorUtil.shared.UIColorFromColorCode(colorCd)
        }

    }

    override init() {
        super.init()
    }
    
    init(event:EKEvent) {
        super.init()
        self._cdEventTemplate = nil
        self.templateGroupName = ""
        
        self.templateName = event.title
        self.title =    event.title
        self.allDay =   event.isAllDay
        self.location = event.location
        self.notes =    event.notes
        self.calendar = event.calendar
        self.alarms =   event.alarms
        self.availability = event.availability
        self.status = event.status
        self.attendees = event.attendees
        self.organizer = event.organizer
        
        self.recurrenceRules = event.recurrenceRules
        
        self.timeZone = event.timeZone
        
        let appCalendar = CalendarManager.shared().appCalendar()!
        let unitFlag : Set<Calendar.Component> = [ .hour, .minute ]
        if self.allDay == false {
            self.startTimeComps   = appCalendar.dateComponents(unitFlag, from: event.startDate)
            self.eventLengthComps = appCalendar.dateComponents(unitFlag, from: event.startDate, to: event.endDate)
        } else {
            self.startTimeComps = nil
            self.eventLengthComps = nil
        }
        self.customColor = nil;
        self.customTextColor = nil;
        
        if let ext = BzEventExtensionService.shared().eventExtension(event: event) {
            if let code = ext.bgColorCode {
                self.customColor = ColorUtil.shared.UIColorFromColorCode(code)
            }
            if let code = ext.textColorCode {
                self.customTextColor = ColorUtil.shared.UIColorFromColorCode(code)
            }
        }

    }
    
    init(template other:AppEventTemplate) {
        super.init()
        self.setCDEventTemplate(cdTemplate: other.cdEventTemplate())
        self.templateGroupName = other.templateGroupName;
        self.templateName = other.templateName;
        self.title = other.title;
        self.allDay = other.allDay;
        self.location = other.location;
        self.notes = other.notes;
        self.calendar = other.calendar;
        self.alarms = other.alarms;
        self.availability = other.availability;
        self.status = other.status;
        self.attendees = other.attendees;
        self.organizer = other.organizer;
        self.recurrenceRules = other.recurrenceRules;
        self.timeZone = other.timeZone;
        self.startTimeComps = other.startTimeComps;
        self.eventLengthComps = other.eventLengthComps;
        
        self.customColor = other.customColor;
        self.customTextColor = other.customTextColor;
    }
    
    init(cdTemplate:CDEventTemplate) {
        super.init()

        let store = AppEventKit.shared.store()!

        self.setCDEventTemplate(cdTemplate: cdTemplate)
        
        self.templateGroupName = ""
        self.templateName = cdTemplate.templateName
        self.title = cdTemplate.title
        if let allday = cdTemplate.allDay {
            self.allDay = allday.boolValue

        }
        self.location = cdTemplate.location
        self.notes = cdTemplate.notes;
        
        if let calId = cdTemplate.calendarIdentifier {
            self.calendar = store.calendar(withIdentifier: calId)
        }
        
        if self.calendar == nil {
            self.calendar = store.defaultCalendarForNewEvents
        }
        if let alarmsData = cdTemplate.alarmsData {
            if let alarms = NSKeyedUnarchiver.unarchiveObject(with: alarmsData) as? [EKAlarm] {
                self.alarms = alarms
            }
        } else {
            self.alarms = nil;
        }
        if let rowInt = cdTemplate.availability?.intValue {
            self.availability = EKEventAvailability(rawValue: rowInt)
        }
        if let rowInt = cdTemplate.status?.intValue {
            self.status = EKEventStatus(rawValue: rowInt)
        }
        self.attendees = nil
        if let attendeesNSData = cdTemplate.attendeesData {
            let attendeesData = attendeesNSData as Data
            if let attendees = NSKeyedUnarchiver.unarchiveObject(with: attendeesData) as? [EKParticipant] {
                self.attendees = attendees
            }
        }
        self.organizer = nil
        if let organizerData = cdTemplate.organizerData {
            if let organizer = NSKeyedUnarchiver.unarchiveObject(with: organizerData as Data) as? EKParticipant {
                self.organizer = organizer
            }
        }
        self.recurrenceRules = nil
        if let recurrenceRulesData = cdTemplate.recurrenceRulesData {
            if let recurrenceRules = NSKeyedUnarchiver.unarchiveObject(with: recurrenceRulesData as Data) as? [EKRecurrenceRule] {
                self.recurrenceRules = recurrenceRules
            }
        }
        self.timeZone = nil
        if let timeZoneData = cdTemplate.timeZoneData {
            if let timeZone = NSKeyedUnarchiver.unarchiveObject(with:timeZoneData as Data) as? TimeZone {
                self.timeZone = timeZone
            }
        }
        self.startTimeComps = nil
        if let startTimeCompsData = cdTemplate.startTimeCompsData {
            if let startTimeComps = NSKeyedUnarchiver.unarchiveObject(with: startTimeCompsData as Data) as? DateComponents {
                self.startTimeComps = startTimeComps
            }
        }
        
        self.eventLengthComps = nil
        if self.allDay == false {
            if let eventLengthCompsData = cdTemplate.eventLengthCompsData {
                if let eventLengthComps =  NSKeyedUnarchiver.unarchiveObject(with: eventLengthCompsData as Data) as? DateComponents {
                    self.eventLengthComps = eventLengthComps
                }
            }
        }
        self.customColor = nil
        if let code = cdTemplate.bgColorCode {
            self.customColor = ColorUtil.shared.UIColorFromColorCode(code)
        }
        self.customTextColor = nil;
        if let code = cdTemplate.textColorCode {
            self.customTextColor = ColorUtil.shared.UIColorFromColorCode(code)
        }
    }
    
    // MARK: -
    
    fileprivate func setCDEventTemplate(cdTemplate:CDEventTemplate?) {
        self._cdEventTemplate = cdTemplate
    }
    
    func cdEventTemplate() -> CDEventTemplate? {
        return self._cdEventTemplate
    }

}
