//
//  AppSettingCalendarManager.h
//  GSystemT0
//
//  Created by 小林 活水 on 11/01/02.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import <UIKit/UIKit.h>

@interface CalendarSettingManager : NSObject {
	
	NSMutableArray* selectedEKCalendars;
	NSMutableArray* allCalendars;
	NSArray* selectedCalendars;
	
    
    NSMutableDictionary* colorDict;
	
}

+(CalendarSettingManager*)sharedManager;

// EKCalendar
// 表示選択しているEKCalendarの配列
-(NSArray<EKCalendar*>*) selectedEKCalendars;
-(void)selectEKCalendars:(NSArray<EKCalendar*>*)calendars;

-(EKCalendar*) getEKCalendarWithIdentifier:(NSString*) ekIdentifier;


@end
