//
//  DayViewScheduleView.h
//  GSystemT0
//
//  Created by 小林 活水 on 11/01/17.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import <QuartzCore/CALayer.h>

@interface DayViewScheduleView : UIView {

    CALayer* bgLayer;
    
	EKEvent* _event;
	NSString* text;
	UIFont* font;
	UIColor* textColor;
	UIColor* fillColor;
	
	NSInteger index;
	NSInteger rowIndex;
	NSInteger originalCellViewIndex;
	CGFloat radius;
	
	CGSize shadowOffsetSize;
	
	BOOL isShadowOn;

	
}
@property(nonatomic, copy) NSString* text;
@property(nonatomic, retain) UIFont* font;
@property(nonatomic, retain) UIColor* textColor;
@property(nonatomic, retain) UIColor* fillColor;


@property NSInteger index;
@property NSInteger rowIndex;
@property NSInteger originalCellViewIndex;

@property BOOL isShadowOn;

-(void) clearRect:(CGRect)rect;


- (void) setEvent:(EKEvent*)newEvent;
- (EKEvent*) event;

@end
