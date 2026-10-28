//
//  DayCellHeaderView.m
//  GSystemT0
//
//  Created by 小林 活水 on 11/02/11.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "DayCellHeaderView.h"
#import "MonthViewSettingManager.h"

@interface DayCellHeaderView()

@property(nonatomic, strong) UITextField* dayView;
@property(nonatomic, strong) UITextField* optionView;

@property(nonatomic, strong) NSString* dayString;
@property(nonatomic, strong) NSString* optionString;
@property(nonatomic, strong) UIColor* textColor;


@end


@implementation DayCellHeaderView {
    
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		self.textColor = [UIColor blackColor];

        CGFloat optionYmargin = 0.0f;

		CGRect dayFrame = self.bounds;
        dayFrame.origin.y = 0.0f;
        dayFrame.origin.x = 1;
		dayFrame.size.width = 20;
        dayFrame.size.height = frame.size.height - optionYmargin;
		self.dayView = [[UITextField alloc] initWithFrame:dayFrame];
		self.dayView.font = [[MonthViewSettingManager sharedManager] fontForHeader];
        self.dayView.textAlignment = NSTextAlignmentLeft;
//        self.dayView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.dayView.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        self.dayView.enabled = NO;
        
        self.dayView.textColor = UIColor.blackColor;
        
		[self addSubview:self.dayView];
		
		CGRect optionFrame = self.bounds;
		optionFrame.origin.x = dayFrame.origin.x + dayFrame.size.width;
		optionFrame.origin.y = optionYmargin;
		optionFrame.size.width = frame.size.width - optionFrame.origin.x - dayFrame.origin.x;
		optionFrame.size.height = frame.size.height - optionYmargin;
		
        self.optionView = [[UITextField alloc] initWithFrame:optionFrame];
		self.optionView.font = [UIFont systemFontOfSize:9];
		self.optionView.textAlignment = NSTextAlignmentRight;
        
        self.optionView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        self.optionView.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;

        self.optionView.enabled = NO;
        self.optionView.backgroundColor = [UIColor clearColor];
        self.optionView.textColor = UIColor.blackColor;

		[self addSubview:self.optionView];
	      
        self.optionView.backgroundColor = [UIColor clearColor];
        
    }
    
    return self;
}

- (void) setTextColor:(UIColor *)color {
    self.dayView.textColor = color;
}

- (void) setDayString:(NSString *)str {
    self.dayView.text = str;
}
- (void) setOptionString:(NSString *)str {
    self.optionView.text = str;
}

-(void) setHeadarFont:(UIFont *)headerFont {
    self.dayView.font = headerFont;
    [self.dayView setNeedsLayout];
}

- (void)setBackgroundColor:(UIColor *)clr {
	[super setBackgroundColor:clr];
	self.dayView.backgroundColor = clr;
    self.optionView.backgroundColor = clr;
}

-(void) layoutSubviews {
    LOG_METHOD;
    CGFloat optionYmargin = 0.0f;
    
    CGRect rect = self.bounds;
    CGRect dayViewFrame = self.dayView.frame;
    dayViewFrame.size.height = rect.size.height - optionYmargin;
    
    self.dayView.frame = dayViewFrame;
    
    CGRect optionViewFrame = self.optionView.frame;
    optionViewFrame.size.height = rect.size.height - optionYmargin;
    optionViewFrame.size.width = rect.size.width - optionViewFrame.origin.x - (CGFloat)2;

    self.optionView.frame = optionViewFrame;
    [self.optionView setNeedsLayout];
}


@end
