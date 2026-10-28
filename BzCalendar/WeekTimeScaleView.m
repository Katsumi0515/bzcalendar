//
//  WeekTimeScaleView.m
//  GSystemT0
//
//  Created by 小林 活水 on 11/03/08.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "WeekTimeScaleView.h"
#import "WeekViewSettingManager.h"

@interface WeekTimeScaleView()

@property CGFloat _activeTimeStart;
@property CGFloat _activeTimeEnd;

@end
@implementation WeekTimeScaleView

@synthesize _activeTimeStart;
@synthesize _activeTimeEnd;
@synthesize offsetX;

- (void)setActiveTimeStart:(CGFloat)activeTimeStart {
    self._activeTimeStart = activeTimeStart;
    [self setNeedsDisplay];
}
- (CGFloat) activeTimeStart {
    return self._activeTimeStart;
}
- (CGFloat) activeTimeEnd {
    return self._activeTimeEnd;
}
- (void)setActiveTimeEnd:(CGFloat)activeTimeEnd {
    self._activeTimeEnd = activeTimeEnd;
    [self setNeedsDisplay];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if( self ) {
        timeLabelArray = [[NSMutableArray alloc] initWithCapacity:24];
        // Initialization code
        UILabel* hourLabel;
        
        CGFloat startY = 0.0f;
        CGFloat currentY = startY;
        topMargin = 0.0f;
        hourHeight = (self.frame.size.height - topMargin*2) / 24.0f;
        
        UIFont* font = [[WeekViewSettingManager sharedManager] fontForTime];
        
        
        currentY += topMargin;
        for(int index=0; index < 24; index++) {
            
            // ToDo: アプリケーション設定から取得するよう変更(80という数値）
            hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,currentY, 80, hourHeight)];
            
            hourLabel.font = font;
            hourLabel.backgroundColor = self.superview.backgroundColor;
            
            NSString* hourStr = [NSString stringWithFormat:@"%02d:00", index];
            hourLabel.text = hourStr;
            
            hourLabel.textColor = UIColor.blackColor;
            
            [self addSubview:hourLabel];
            [timeLabelArray addObject:hourLabel];
            currentY += hourHeight;
            
        }
        
        self.backgroundColor = [UIColor clearColor];
        
        self._activeTimeStart = 8;
        self._activeTimeEnd = 5;
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
  	//LOG_METHOD;
    if ((self = [super initWithFrame:frame])) {
		timeLabelArray = [[NSMutableArray alloc] initWithCapacity:24];
        // Initialization code
		UILabel* hourLabel;
		
		CGFloat startY = 0.0f;
		CGFloat currentY = startY;
		topMargin = 0.0f;
		hourHeight = (frame.size.height - topMargin*2) / 24.0f;
		
        UIFont* font = [[WeekViewSettingManager sharedManager] fontForTime];

		
		currentY += topMargin;
		for(int index=0; index < 24; index++) {
			
			// ToDo: アプリケーション設定から取得するよう変更(80という数値）
			hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,currentY, 80, hourHeight)];
			
			hourLabel.font = font;
			hourLabel.backgroundColor = self.superview.backgroundColor;
			
			NSString* hourStr = [NSString stringWithFormat:@"%02d:00", index];
			hourLabel.text = hourStr;
			[self addSubview:hourLabel];
			[timeLabelArray addObject:hourLabel];
			currentY += hourHeight;
			
		}
		
		self.backgroundColor = [UIColor clearColor];
		
		self._activeTimeStart = 8;
		self._activeTimeEnd = 5;
        
        self.userInteractionEnabled = YES;
    }
    return self;
	
}

-(void) layoutSubviews {
	//LOG_METHOD;
	hourHeight = (self.frame.size.height - topMargin*2) / 24.0f;
	
	NSInteger index = 0;
	for(UILabel* vv in timeLabelArray) {
		CGRect newFrame = vv.frame;
		newFrame.origin.x = 0;
		newFrame.origin.y = topMargin + (index * hourHeight);
		newFrame.size.height = hourHeight;
		//newFrame.size.width = self.frame.size.width;
		newFrame.size.width = 45;
		[vv setFrame:newFrame];
		//CGRect newBounds = newFrame;
		//newBounds.origin.x = 0;
		//newBounds.origin.y = 0;
		//[vv setBounds:newBounds];
		
        vv.font = [[WeekViewSettingManager sharedManager] fontForTime];
		vv.backgroundColor = [UIColor clearColor];
		//	vv.backgroundColor = [UIColor whiteColor];
		[vv setNeedsLayout];
		[vv setNeedsDisplay];
		
		//[self addSubview:vv];
		index++;
	}	
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
	
	UIColor* nonActiveColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
	CGRect beforeRect = rect;
	beforeRect.origin.y = 0;
	beforeRect.size.height = _activeTimeStart;
	CGContextSetFillColorWithColor(ctx, [nonActiveColor CGColor]);
	CGContextFillRect(ctx, beforeRect);
	CGRect afterRect = rect;
	afterRect.origin.y = _activeTimeEnd;
	afterRect.size.height = rect.size.height - _activeTimeEnd;
	CGContextFillRect(ctx, afterRect);
	
	for(int i=0; i<25; i++) {
		[self drawLine:ctx x0:offsetX y0:curY x1:rect.size.width y1:curY];
		
		curY += step;
	}
	CGFloat curX = offsetX;
	CGFloat xStep = (self.bounds.size.width - offsetX)/7.0f;
	CGFloat contentHeight = hourHeight * 24.0f;
	for(int y=0; y<7; y++) {
		[self drawLine:ctx x0:curX y0:startY x1:curX y1:contentHeight];
		curX += xStep;
	}
	
}


 

- (void)dealloc {

   // [super dealloc];
}



@end
