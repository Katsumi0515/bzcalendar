//
//  MVDayScheduleView.h
//  GSystemT0
//
//  Created by 小林 活水 on 11/03/15.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleViewBase.h"

@interface MVDayScheduleView : UIView {
//    VerticalAlignment verticalAlignment_;
//	NSTextAlignment textAlignment;
//	NSLineBreakMode lineBreakMode;
//	NSInteger numberOfLines;
    
//	NSString* text;
//	UIFont* font;
//	UIColor* textColor;
//	UIColor* clearColor;
	
//	NSInteger index;
//	NSInteger originalCellViewIndex;
//	CGFloat radius;
	
}

@property NSInteger index;

@property(nonatomic, copy) NSString* text;
@property(nonatomic, retain) UIFont* font;
@property(nonatomic, retain) UIColor* textColor;
@property(nonatomic, retain) UIColor* clearColor;


@end
