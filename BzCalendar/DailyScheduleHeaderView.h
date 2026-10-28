//
//  DailyScheduleHeaderView.h
//  GSystemT0
//
//  Created by 小林 活水 on 10/08/22.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EKEvent;

@interface DailyScheduleHeaderView : UIView {

	NSInteger allDayCount;
	
	CGFloat allDayScheduleHeight;
	
	NSMutableArray* scheduleArray;
	NSMutableArray* scheduleViewArray;
}

- (void)setEventHeight:(CGFloat)height;

- (void)addEvents:(NSMutableArray*)array;
- (void)addEvent:(EKEvent*)event;
- (void)clearEvents;

@end
