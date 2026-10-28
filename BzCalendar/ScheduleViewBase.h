//
//  ScheduleViewBase.h
//  GSystemT0
//
//  Created by 小林 活水 on 10/12/20.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum VerticalAlignment {
    VerticalAlignmentTop,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;


@interface ScheduleViewBase : UIView {
    VerticalAlignment verticalAlignment_;
	NSTextAlignment textAlignment;
	NSLineBreakMode lineBreakMode;
	NSInteger numberOfLines;
    
	NSString* text;
	UIFont* font;
	UIColor* textColor;
	UIColor* clearColor;
	
	NSInteger index;
	NSInteger originalCellViewIndex;
	CGFloat radius;
	
	
	CGFloat xMargin;
	CGFloat xOffsetFromXMargin;
	CGFloat yTopMargin;
	CGFloat yBottomMargin;
	
}
@property(nonatomic) NSTextAlignment textAlignment;
@property(nonatomic) NSLineBreakMode lineBreakMode;
@property(nonatomic) NSInteger numberOfLines;
@property(nonatomic, copy) NSString* text;
@property(nonatomic, retain) UIFont* font;
@property(nonatomic, retain) UIColor* textColor;
@property(nonatomic, retain) UIColor* clearColor;

@property (nonatomic, assign) VerticalAlignment verticalAlignment;

@property NSInteger index;
@property NSInteger originalCellViewIndex;

-(void)drawTextInRect:(CGRect)contextRect withContext:(CGContextRef)ctx;
-(void) clearRect:(CGRect)rect;

@end
