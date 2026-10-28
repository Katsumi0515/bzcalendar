//
//  WVAllDayScheduleView.m
//  GSystemT0
//
//  Created by 小林 活水 on 11/03/15.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "WVAllDayScheduleView.h"


@implementation WVAllDayScheduleView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.clearColor = [self.superview backgroundColor];
		xMargin = 0.2f;
		xOffsetFromXMargin = 1.0f;
		yTopMargin = 0.2f;
		yBottomMargin = 0.3f;
		
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void) clearRect:(CGRect)rect {
    self.alpha = 0.8f;
	CGContextRef ctx = UIGraphicsGetCurrentContext();	
	CGContextSetFillColorWithColor(ctx, [clearColor CGColor]);
	CGContextFillRect(ctx, rect);
	
}


@end
