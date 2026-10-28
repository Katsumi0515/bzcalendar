//
//  MVDayScheduleView.m
//  GSystemT0
//
//  Created by 小林 活水 on 11/03/15.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "MVDayScheduleView.h"
#import "MonthViewSettingManager.h"

@interface MVDayScheduleView()


@property(nonatomic) CGFloat radius;

@property(nonatomic) NSLineBreakMode lineBreakMode;
@property(nonatomic) NSTextAlignment textAlignment;
@property(nonatomic) NSInteger numberOfLines;
@property (nonatomic, assign) VerticalAlignment verticalAlignment;
@property NSInteger originalCellViewIndex;

-(void)drawTextInRect:(CGRect)contextRect withContext:(CGContextRef)ctx;

@end

@implementation MVDayScheduleView

CGFloat xMargin;
CGFloat xOffsetFromXMargin;
CGFloat yTopMargin;
CGFloat yBottomMargin;

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
@synthesize radius;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( self ) {
        //xMargin = 0.2f;
		//xOffsetFromXMargin = 1.0f;
		//yTopMargin = 1.0f;
		//yBottomMargin = 0.8f;
		
		self.lineBreakMode = NSLineBreakByCharWrapping;
		//self.font = [UIFont systemFontOfSize:10];
		self.textAlignment = NSTextAlignmentLeft;
		self.numberOfLines = 1;
		self.verticalAlignment = VerticalAlignmentMiddle;
		self.textColor = [UIColor blackColor];
		//self.clearColor = [UIColor clearColor];
		radius = 0;
        self.backgroundColor = [UIColor clearColor];

        
		xMargin = 0.2f;
		xOffsetFromXMargin = 1.0f;
//		yTopMargin = 0.4f;
        yTopMargin = 0.1f;
		yBottomMargin = 0.1f;
		self.clearColor = [self.superview backgroundColor];
        self.font = [[MonthViewSettingManager sharedManager] fontForEventEntity];
        self.verticalAlignment = VerticalAlignmentMiddle;

	}
	return self;
}
-(void)drawTextInRect:(CGRect)contextRect withContext:(CGContextRef)ctx {
	
//    UIEdgeInsets insets = UIEdgeInsetsMake(0, xMargin + xOffsetFromXMargin, 0, 0);
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 2, 0, 0);
    CGRect textRect = UIEdgeInsetsInsetRect(contextRect, insets);
    
//    CGSize size =  [text sizeWithAttributes:@{NSFontAttributeName:font}];
//	CGFloat textHeight = size.height;
//	CGFloat viewHeight = contextRect.size.height;
//	CGFloat x = xMargin + xOffsetFromXMargin;
//	CGFloat y = yTopMargin + 1.0f + (viewHeight - textHeight)/2.0f;
//	CGPoint pt = CGPointMake(x, y);
	
	CGContextSaveGState(ctx);
	CGContextSetFillColorWithColor(ctx, [textColor CGColor]);
    
    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSForegroundColorAttributeName: textColor};
    
    [text drawInRect:textRect withAttributes:attributes];
//    [text drawAtPoint:pt withAttributes:attributes];
    
	CGContextRestoreGState(ctx);
}

- (void)drawRect:(CGRect)rect {
    
	[self clearRect:rect]; // クリアカラーで指定した色で一旦塗りつぶし
	
    // バックグラウンドカラーで指定した色で、テキスト領域の背景を塗りつぶし
	CGRect contextRect = rect;
//	contextRect.origin.x = xMargin;
    contextRect.origin.x = 0.0f;
	contextRect.origin.y = yTopMargin;
	contextRect.size.height -= (yTopMargin + yBottomMargin);
	//contextRect.size.width -= (xMargin * 2);
    
	if( radius == 0 ) {
		radius = contextRect.size.height/3.0f;
	}
    if( radius > 4 ) {
        radius = 4;
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
		
	CGContextSetFillColorWithColor(ctx, [self.backgroundColor CGColor]);
	
    CGContextFillPath(ctx);
	
	CGContextRestoreGState(ctx);
	
    // テキストをcontextRectに描画
    if( text ) {
        [self drawTextInRect:contextRect withContext:ctx];
	}
}

-(void) clearRect:(CGRect)rect {
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(ctx, [clearColor CGColor]);
	CGContextFillRect(ctx, rect);
	
}




@end
