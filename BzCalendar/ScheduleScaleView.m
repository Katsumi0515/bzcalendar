//
//  ScheduleSheetView.m
//  GSystemT0
//
//  Created by 小林 活水 on 10/08/12.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "ScheduleScaleView.h"
#import <QuartzCore/QuartzCore.h>

@interface ScheduleScaleView()
@property (nonatomic, readwrite) UIColor* _nonActiveColor;
@property (nonatomic) CGFloat _activeTimeStart;
@property (nonatomic) CGFloat _activeTimeEnd;
@end

@implementation ScheduleScaleView

@synthesize _nonActiveColor;
@synthesize _activeTimeStart;
@synthesize _activeTimeEnd;

-(void)setNonActiveColor:(UIColor*)color {
    self._nonActiveColor = color;
}
-(void) setActiveTimeStart:(CGFloat)time {
    self._activeTimeStart = time;
    [self setNeedsDisplay];
}
-(void) setActiveTimeEnd:(CGFloat)time {
    self._activeTimeEnd = time;
    [self setNeedsDisplay];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if( self ) {
        self._nonActiveColor = [UIColor lightGrayColor];
        topMargin = 0.0f;
        
        offsetY = 0.0f;
        hourHeight = self.frame.size.height / 24.0f;
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];

    }
    return self;
}
- (id) initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame]) != nil) {
        self._nonActiveColor = [UIColor lightGrayColor];

		topMargin = 0.0f;
		
		offsetY = 0.0f;
		hourHeight = frame.size.height / 24.0f;
		
		self.userInteractionEnabled = YES;
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

//ライン幅の指定
- (void)setLineWidth:(CGContextRef)c w:(float)w {
    if (w<0.0f) w=0.0f;
    CGContextSetLineWidth(c,w);
}
//ラインの描画
- (void)drawLine:(CGContextRef)c x0:(float)x0 y0:(float)y0 x1:(float)x1 y1:(float)y1 {

	CGContextSetRGBStrokeColor(c, 0.7, 0.7, 0.7, 0.5);
	
	CGFloat pattern[] = {3.0, 2.0};
	
	CGContextSetLineWidth(c, 0.5f);
	CGContextSetLineDash (c,0,pattern, 2);
    CGContextSetLineCap(c,kCGLineCapButt);
    CGContextMoveToPoint(c,x0,y0);
    CGContextAddLineToPoint(c,x1,y1);
    CGContextStrokePath(c);
}

- (void) setTopMargin:(CGFloat)top {
	topMargin = top;
}
- (void) setHourHeight:(CGFloat)hour{
	hourHeight = hour;
}

- (void) drawRect:(CGRect)rect {
	
	CGFloat startY = topMargin;
	CGFloat step = hourHeight;
	CGFloat curY = startY;

	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextClearRect(ctx, rect);
	//CGContextSetRGBFillColor(ctx, 1, 1, 1, 1.0);
	CGContextSetFillColorWithColor(ctx, [self.superview.backgroundColor CGColor]);
	CGContextFillRect(ctx, rect);
	
	CGRect beforeRect = rect;
	beforeRect.origin.y = 0;
	beforeRect.size.height = _activeTimeStart;
    UIColor* nonActiveColor = [self._nonActiveColor colorWithAlphaComponent:0.2];
	CGContextSetFillColorWithColor(ctx, [nonActiveColor CGColor]);
    
	CGContextFillRect(ctx, beforeRect);
	CGRect afterRect = rect;
	afterRect.origin.y = _activeTimeEnd;
	afterRect.size.height = rect.size.height - _activeTimeEnd;
	CGContextFillRect(ctx, afterRect);
	
	
	for(int i=0; i<25; i++) {
		[self drawLine:ctx x0:0.0 y0:curY x1:rect.size.width y1:curY];
		
		curY += step;
	}
	 
	//[super drawRect:rect];
}

@end
