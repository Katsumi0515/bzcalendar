//
//  EventUtil.m
//  GSystemT0
//
//  Created by 小林 活水 on 10/01/09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EventUtil.h"
#import <EventKit/EventKit.h>
#import "CalendarManager.h"

@implementation EventUtil

+(BOOL) isLongEvent:(NSObject*) obj{
	
	NSDate* startDate;
	NSDate* endDate;
	
	if ([obj isMemberOfClass:[EKEvent class]] == TRUE) {
		
		EKEvent* event = (EKEvent*) obj;
		startDate = event.startDate;
		endDate = event.endDate;
		
		NSTimeInterval interval_sec = [endDate timeIntervalSinceDate:startDate];
		double interval_day = interval_sec / (60.0*60.0*24.0);
		
		if( interval_day > 1 ) {
			return YES;
		}
		
	}		
	return NO;
}

+(int) eventLengthByDay:(NSObject*)obj {
	
	NSCalendar* appCalender = [[CalendarManager sharedManager] appCalendar];

	int rtn_days = 0;
	NSDate* startDate;
	NSDate* endDate;
	NSUInteger unitFlag = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
	
	if ([obj isMemberOfClass:[EKEvent class]] == TRUE) {
		EKEvent* event = (EKEvent*)obj;
		startDate = event.startDate;
		endDate = event.endDate;

		
		NSDateComponents* comps = [appCalender components:unitFlag fromDate:startDate];
		NSUInteger sec = [comps second];
		NSUInteger min = [comps minute];
		NSUInteger hour = [comps hour];
		
		NSTimeInterval interval_sec = [endDate timeIntervalSinceDate:startDate];
		interval_sec += (sec + min * 60 + hour * 60 * 60);
		double interval_day = interval_sec / (60.0 * 60.0 * 24.0);
		rtn_days = ceil(interval_day);
	} else {
		// エラーとはしない
		rtn_days = 0;
	}
	
	return rtn_days;
}
+(int) eventLength:(NSObject*)obj fromDate:(NSDate*)fromDate {
	
	NSCalendar* appCalender = [[CalendarManager sharedManager] appCalendar];
	
	int rtn_days = 0;
	NSDate* startDate;
	NSDate* endDate;
	NSUInteger unitFlag = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
	
	if ([obj isMemberOfClass:[EKEvent class]] == TRUE) {
		EKEvent* event = (EKEvent*)obj;
		startDate = fromDate;
		endDate = event.endDate;
		
		
		NSDateComponents* comps = [appCalender components:unitFlag fromDate:startDate];
		NSUInteger sec = [comps second];
		NSUInteger min = [comps minute];
		NSUInteger hour = [comps hour];
		
		NSTimeInterval interval_sec = [endDate timeIntervalSinceDate:startDate];
		interval_sec += (sec + min * 60 + hour * 60 * 60);
		double interval_day = interval_sec / (60.0 * 60.0 * 24.0);
		rtn_days = ceil(interval_day);
	} else {
		// エラーとはしない
		rtn_days = 0;
	}
	
	return rtn_days;
}

@end
