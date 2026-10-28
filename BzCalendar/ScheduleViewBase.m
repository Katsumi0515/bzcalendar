//
//  ScheduleViewBase.m
//  GSystemT0
//
//  Created by 小林 活水 on 10/12/20.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "ScheduleViewBase.h"
#import <QuartzCore/CALayer.h>

@interface ScheduleViewBase()
@end

@implementation ScheduleViewBase

@synthesize textAlignment;
@synthesize lineBreakMode;
@synthesize verticalAlignment = verticalAlignment_;
@synthesize numberOfLines;
@synthesize text;
@synthesize font;
@synthesize textColor;
@synthesize clearColor;

@synthesize index;
@synthesize originalCellViewIndex;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		xMargin = 0.2f;
		xOffsetFromXMargin = 1.0f;
		yTopMargin = 1.0f;
		yBottomMargin = 0.8f;
		
		self.lineBreakMode = NSLineBreakByCharWrapping;
		self.font = [UIFont systemFontOfSize:10];
		self.textAlignment = NSTextAlignmentLeft;
		self.numberOfLines = 1;
		self.verticalAlignment = VerticalAlignmentMiddle;
		self.textColor = [UIColor blackColor];
		self.clearColor = [UIColor clearColor];
		radius = 0;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment {
    verticalAlignment_ = verticalAlignment;
    [self setNeedsDisplay];
}

-(void)drawTextInRect:(CGRect)contextRect withContext:(CGContextRef)ctx {
	
    CGSize size =  [text sizeWithAttributes:@{NSFontAttributeName:font}];
	CGFloat textHeight = size.height;
	CGFloat viewHeight = contextRect.size.height;
	CGFloat x = xMargin + xOffsetFromXMargin;
	CGFloat y = yTopMargin + 1.0f + (viewHeight - textHeight)/2.0f;
	CGPoint pt = CGPointMake(x, y);
	
	CGContextSaveGState(ctx);	
	CGContextSetFillColorWithColor(ctx, [textColor CGColor]);
    
    NSDictionary *attributes = @{ NSFontAttributeName: font, NSForegroundColorAttributeName: textColor};
    [text drawAtPoint:pt withAttributes:attributes];
	
	//[text drawAtPoint:pt withFont:font];
	CGContextRestoreGState(ctx);
}

- (void)drawRect:(CGRect)rect {
    
	[self clearRect:rect];
	
	CGRect contextRect = rect;
	contextRect.origin.x = xMargin;
	contextRect.origin.y = yTopMargin;
	contextRect.size.height -= (yTopMargin + yBottomMargin);
	contextRect.size.width -= (xMargin * 2);
	if( radius == 0 ) {
		radius = floor(contextRect.size.height/4.0f);
	}
	CGFloat minx = CGRectGetMinX(contextRect);
	CGFloat midx = CGRectGetMidX(contextRect);
	CGFloat maxx = CGRectGetMaxX(contextRect);
	CGFloat miny = CGRectGetMinY(contextRect);
	CGFloat midy = CGRectGetMidY(contextRect);
	CGFloat maxy = CGRectGetMaxY(contextRect);
	
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSaveGState(ctx);
	
	
	CGContextMoveToPoint(ctx, minx, midy);
	CGContextAddArcToPoint(ctx, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(ctx, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(ctx, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(ctx, minx, maxy, minx, midy, radius);
	CGContextClosePath(ctx);
	
    CGContextSetShadow(ctx, CGSizeMake(1,1), 3); 
	
	CGContextSetFillColorWithColor(ctx, [self.backgroundColor CGColor]);
	
    CGContextFillPath(ctx); 
	
	CGContextRestoreGState(ctx);
	
    if( text ) {
        [self drawTextInRect:contextRect withContext:ctx];
	}
}

-(void) clearRect:(CGRect)rect {
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();	
	CGContextSetFillColorWithColor(ctx, [clearColor CGColor]);
	CGContextFillRect(ctx, rect);
	
}

-(void) dealloc {	
	if( self.text ) text =nil;
	if( self.font ) font =nil;
	if( self.textColor ) textColor =nil;
    if( self.clearColor ) clearColor =nil;
}

@end
