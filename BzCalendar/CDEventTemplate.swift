//
//  File.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/25.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import Foundation

class CDEventTemplate : NSManagedObject {
    
    @NSManaged var alarmsData: Data?
    @NSManaged var allDay: NSNumber?
    @NSManaged var attendeesData: NSData?
    @NSManaged var availability: NSNumber?
    @NSManaged var bgAlpha: String?
    @NSManaged var bgColorCode: String?
    @NSManaged var calendarIdentifier: String?
    @NSManaged var endTimeCompsData: NSData?
    @NSManaged var eventLengthCompsData: NSData?
    @NSManaged var location: String?
    
    @NSManaged var notes: String?
    @NSManaged var organizerData: NSData?
    @NSManaged var recurrenceRulesData: NSData?
    @NSManaged var startTimeCompsData: NSData?
    @NSManaged var status: NSNumber?
    @NSManaged var templateGroupName: String?
    @NSManaged var templateName: String?
    @NSManaged var textColorCode: String?
    @NSManaged var timeZoneData: NSData?
    @NSManaged var title: String?

}
