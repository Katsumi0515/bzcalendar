//
//  WVScheduleView.h
//  GSystemT0
//
//  Created by 小林 活水 on 11/03/19.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "ScheduleViewBase.h"

@interface WVScheduleView : ScheduleViewBase {
	NSDate* date;
	EKEvent* event;
}
@property (nonatomic, retain) NSDate* date;
@property (nonatomic, retain) EKEvent* event;

@end
