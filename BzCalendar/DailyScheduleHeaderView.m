//
//  DailyScheduleHeaderView.m
//  GSystemT0
//
//  Created by 小林 活水 on 10/08/22.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "DailyScheduleHeaderView.h"
#import <EventKit/EventKit.h>
#import "DayViewScheduleView.h"
#import "AppConstants.h"

#import "BzCalendar-Swift.h"

@implementation DailyScheduleHeaderView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		scheduleArray = [[NSMutableArray alloc] initWithCapacity:5];
		scheduleViewArray = [[NSMutableArray alloc] initWithCapacity:5];
		
		allDayCount = 0;
		allDayScheduleHeight = Default_AllDay_Schedule_Height;
		// ToDo: setup background color
		self.backgroundColor = self.superview.backgroundColor;
		self.backgroundColor = [UIColor whiteColor];
		
    }
    return self;
}

// Storyboardで結びつけるため
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if( self ) {
        scheduleArray = [[NSMutableArray alloc] initWithCapacity:5];
        scheduleViewArray = [[NSMutableArray alloc] initWithCapacity:5];
        
        allDayCount = 0;
        allDayScheduleHeight = Default_AllDay_Schedule_Height;
        // ToDo: setup background color
        self.backgroundColor = self.superview.backgroundColor;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void) setEventHeight:(CGFloat)height {
	allDayScheduleHeight = height;
}

- (void) addEvents:(NSMutableArray*) array {
	for(EKEvent* event in array) {
		[self addEvent:event];
	}
}
- (void) addEvent:(EKEvent *)event {
	[scheduleArray addObject:event];
	
	CGRect scheduleRect;
	scheduleRect.origin.x = 0;
	scheduleRect.origin.y = allDayCount * allDayScheduleHeight;
	scheduleRect.size.width = self.frame.size.width;
	scheduleRect.size.height = allDayScheduleHeight;
		
	DayViewScheduleView* schdView;
		
	schdView = [[DayViewScheduleView alloc] initWithFrame:scheduleRect];
	//schdView.textAlignment = UITextAlignmentCenter;
		
	[schdView setFillColor:[event bgColor]];
	[schdView setTextColor:[event textColor]];
	
	[schdView setEvent:event];
	//[schdView setTitle:event.title];
	
	[scheduleViewArray addObject:schdView];
	[self addSubview:schdView];
	
    
	allDayCount++;
	
	CGRect newFrame = self.frame;
	newFrame.size.height = allDayCount * allDayScheduleHeight;
	[self setFrame:newFrame];
}

- (void) layoutSubviews {
	LOG_METHOD;
	CGRect newFrame = self.frame;
	CGFloat headerViewHeight = allDayScheduleHeight * [scheduleArray count];
	CGFloat headerViewWidth = newFrame.size.width;
	newFrame.size.height = headerViewHeight;
	[self setFrame:newFrame];

	CGRect schedRect;
	int schedIndex = 0;
	for(DayViewScheduleView* schedView in scheduleViewArray) {
		schedRect.origin.x = 0;
		schedRect.origin.y = schedIndex * allDayScheduleHeight;
		schedRect.size.height = allDayScheduleHeight;
		schedRect.size.width = headerViewWidth;			// 一番最初はwidthが０であるため明示的にセットする
		schedView.frame = schedRect;
		schedIndex++;
	}
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
	if( scheduleArray != nil )
		scheduleArray =nil;
	if( scheduleViewArray != nil )
		scheduleViewArray =nil;
	
    
}

- (void)clearEvents {
	[scheduleArray removeAllObjects];
	for(DayViewScheduleView* view in scheduleViewArray) {
		[view removeFromSuperview];
	}
	[scheduleViewArray removeAllObjects];
	allDayCount = 0;
}

@end
