//
//  WVScheduleView.m
//  GSystemT0
//
//  Created by 小林 活水 on 11/03/19.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "WVScheduleView.h"
//#import "BzWeekViewScrollController.h"
#import "BzAppDelegate.h"

@interface WVScheduleView()

-(void) showEvent:(id)sender;
- (void) handleSingleTap:(id)sender;

@end

@implementation WVScheduleView

@synthesize event;
@synthesize date;

-(void) showEvent:(id)sender {
	LOG_METHOD;
    BzAppDelegate* appDelegate = (BzAppDelegate*)[[UIApplication sharedApplication] delegate];;
    [[appDelegate topViewControllerDelegate] openEvent:self.event];
	
}
- (void) handleSingleTap:(id)sender {
    [self showEvent:sender];    
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.clearColor = [self.superview backgroundColor];
		xMargin = 0.2f;
		xOffsetFromXMargin = 1.0f;
		yTopMargin = 0.2f;
		yBottomMargin = 0.3f;
		self.font = [UIFont fontWithName:kScheduleFontName size:9.0f];

        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *singleTapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTapRec.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTapRec];
        singleTapRec =nil;

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
-(void)drawTextInRect:(CGRect)contextRect withContext:(CGContextRef)ctx {
		
	CGContextSaveGState(ctx);	
	
    //CGColorRef bkCGColor = CGColorCreateCopyWithAlpha([self.backgroundColor CGColor], 0.2f);
    //CGContextSetFillColorWithColor(ctx, bkCGColor);
    
    CGContextSetFillColorWithColor(ctx, [textColor CGColor]);
    
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByCharWrapping;
  
    NSDictionary *dictionary = @{ NSFontAttributeName: font,
                                  NSParagraphStyleAttributeName: textStyle,
                                  NSForegroundColorAttributeName: textColor};
    
    
	[text drawInRect:contextRect withAttributes:dictionary];

	CGContextRestoreGState(ctx);
}

- (void)drawRect:(CGRect)rect {
	
   // self.clearColor = [UIColor clearColor];
	[self clearRect:rect];
	
	CGRect contextRect = rect;
	contextRect.origin.x = xMargin;
	contextRect.origin.y = yTopMargin;
	contextRect.size.height -= (yTopMargin + yBottomMargin);
	contextRect.size.width -= (xMargin * 2);
	if( radius == 0 ) {
		radius = contextRect.size.height/3.0f;
	}
	radius = 5.0f;
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

	//CGContextClip(ctx);
		
	//CGColorRef bkCGColor = CGColorCreateCopyWithAlpha([self.backgroundColor CGColor], 0.7f);
    self.alpha = 0.8f;
	CGColorRef bkCGColor = CGColorCreateCopyWithAlpha([self.backgroundColor CGColor], self.alpha);
    CGContextSetFillColorWithColor(ctx, bkCGColor);

    /*
    // CGGradientを生成する
    // 生成するためにCGColorSpaceと色データの配列が必要になるので
    // 適当に用意する
    CGGradientRef gradient;
    CGColorSpaceRef colorSpace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8]; // = { 1.0, 1.0, 1.0, 1.0,  // Start color
		//0.79, 0.79, 0.79, 1.0 }; // End color
    colorSpace = CGColorGetColorSpace(bkCGColor);
	const CGFloat* bkComponents = CGColorGetComponents(bkCGColor);
	components[0] = bkComponents[0];
	components[1] = bkComponents[1];
	components[2] = bkComponents[2];
	components[3] = 0.8f;
	components[4] = bkComponents[0];
	components[5] = bkComponents[1];
	components[6] = bkComponents[2];
	components[7] = 1.0f;
	
    gradient = CGGradientCreateWithColorComponents(colorSpace, components,
                                                   locations, num_locations);
	
    // 生成したCGGradientを描画する
    // 始点と終点を指定してやると、その間に直線的なグラデーションが描画される。
    // （横幅は無限大）
    CGPoint startPoint = CGPointMake(minx, miny);
    CGPoint endPoint = CGPointMake(maxx, contextRect.size.height);
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
	CGContextSetShadow(ctx, CGSizeMake(1,1), 3); 

    // GradientとColorSpaceを開放する
    CGGradientRelease(gradient);
    CGColorRelease(bkCGColor);
    //CGColorSpaceRelease(colorSpace);
*/
    
    CFRelease(bkCGColor);
    CGContextFillPath(ctx); 
	
	CGContextRestoreGState(ctx);
	
    CGFloat textCornerMargin = 2.0f;
    CGRect textRect = contextRect;
    textRect.origin.x += textCornerMargin;
    textRect.origin.y += textCornerMargin;
    textRect.size.width -= (textCornerMargin * 2.0f);
    textRect.size.height -= (textCornerMargin * 2.0f);
	[self drawTextInRect:textRect withContext:ctx];
	
}

- (void)dealloc {
    if( self.date ) date =nil;
    if( self.event ) event =nil;
  
}


@end
