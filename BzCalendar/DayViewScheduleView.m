//
//  DayViewScheduleView.m
//  GSystemT0
//
//  Created by 小林 活水 on 11/01/17.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "DayViewScheduleView.h"
#import "BzAppDelegate.h"

@interface DayViewScheduleView()

@property (nonatomic, retain) EKEvent* _event;

- (void) handleSingleTap:(id)sender;

@end

@implementation DayViewScheduleView

static CGFloat xMargin = 5.0f;
static CGFloat xOffsetFromXMargin = 3.0f;
static CGFloat yMargin = 0.2f;
static CGFloat yShadowMargin = 0.5f;

@synthesize _event;
@synthesize text;
@synthesize font;
@synthesize textColor;
@synthesize fillColor;

@synthesize index;
@synthesize rowIndex;
@synthesize originalCellViewIndex;

@synthesize isShadowOn;

-(void) showEvent:(id)sender {
	LOG_METHOD;
    
    BzAppDelegate* appDelegate = (BzAppDelegate*)[[UIApplication sharedApplication] delegate];;
    [[appDelegate topViewControllerDelegate] openEvent:self._event];
	
}
- (void) handleSingleTap:(id)sender {
    [self showEvent:sender];    
}


- (void) setBackgroundColor:(UIColor *)color {
	LOG_METHOD;
	LOG(@"setting backgroundColor for this class will be ignored");
    // ToDo
    //  ここの挙動を含めて、クラス設計の再考が必要
    //
}

- (void) setEvent:(EKEvent *)newEvent {

	if (newEvent) {
		self._event = newEvent;
		self.text = newEvent.title;
        if( (newEvent.location != nil) && ([newEvent.location length] > 0 ) ) {
            self.text = [self.text stringByAppendingFormat:@" (%@)", newEvent.location];
        }
		[self setNeedsDisplay];

	}
}
- (EKEvent*) event {
	return self._event;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame]) != nil) {
        /*
        bgLayer = [[CALayer alloc] init];
        bgLayer.frame = frame;
        bgLayer.cornerRadius = 5;
        bgLayer.borderWidth = 2;
        bgLayer.backgroundColor = [[UIColor redColor] CGColor];
        bgLayer.borderColor = [[UIColor blueColor] CGColor];
        [self.layer addSublayer:bgLayer];
        */
        
        self.font = [UIFont boldSystemFontOfSize:12.0f];
		self.textColor = [UIColor blackColor];
		radius = 0;
		
		//self.backgroundColorは不可にしているのでsuperで設定
		super.backgroundColor = [UIColor clearColor];
		
		shadowOffsetSize = CGSizeMake(3, 2);
		isShadowOn = YES;
        self.userInteractionEnabled = YES;

        UITapGestureRecognizer *singleTapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTapRec.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTapRec];
       

    }
    return self;
}

-(void)drawTextInRect:(CGRect)contextRect withContext:(CGContextRef)ctx {
	
     CGSize size =  [text sizeWithAttributes:@{NSFontAttributeName:font}];
	//CGSize size = [text sizeWithFont:font];
	CGFloat textHeight = size.height;
	CGFloat viewHeight = contextRect.size.height;
	
	CGPoint pt;
	if( textHeight <= viewHeight ) {
		pt = CGPointMake(xMargin + xOffsetFromXMargin, yMargin + (viewHeight - textHeight)/2.0f);
	} else {
		pt = CGPointMake(xMargin + xOffsetFromXMargin, 0);
	}
	CGContextSaveGState(ctx);	
    /*
    const CGFloat *components = CGColorGetComponents([self.fillColor CGColor]);
    CGContextSetRGBFillColor(ctx, components[0], components[1], components[2], 1.0f);
     */
    
	CGContextSetFillColorWithColor(ctx, [textColor CGColor]);

    
    NSDictionary *attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: textColor};
    [text drawAtPoint:pt withAttributes:attributes];
	
	CGContextRestoreGState(ctx);
}

- (void)drawRect:(CGRect)rect {
//	LOG_METHOD;
	
	[self clearRect:rect];
	
	CGRect contextRect = rect;
	contextRect.origin.x = xMargin;
	contextRect.origin.y = yMargin;
	if( isShadowOn ) {
		contextRect.size.height -= ( (yMargin * 2) + yShadowMargin);
	} else {
		contextRect.size.height -= (yMargin * 2);	
	}
	contextRect.size.width -= (xMargin * 2);
	if( radius == 0 ) {
		radius = contextRect.size.height/4.0f;
	}
	radius = 4;
	CGFloat minx = CGRectGetMinX(contextRect);
	CGFloat midx = CGRectGetMidX(contextRect);
	CGFloat maxx = CGRectGetMaxX(contextRect);
	CGFloat miny = CGRectGetMinY(contextRect);
	CGFloat midy = CGRectGetMidY(contextRect);
	CGFloat maxy = CGRectGetMaxY(contextRect);
	
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSaveGState(ctx);
		
    CGContextSetLineWidth(ctx, 4.0f);

	CGContextMoveToPoint(ctx, minx, midy);
	CGContextAddArcToPoint(ctx, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(ctx, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(ctx, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(ctx, minx, maxy, minx, midy, radius);
	CGContextClosePath(ctx);
	
    /*
	if( isShadowOn ) {
		CGContextSetShadow(ctx, shadowOffsetSize, 3); 
	}
     */
    const CGFloat *components = CGColorGetComponents([self.fillColor CGColor]);

    CGFloat bgAlpha = 0.8f;
    CGContextSetRGBFillColor(ctx, components[0], components[1], components[2], bgAlpha);
	//CGContextSetFillColorWithColor(ctx, [self.fillColor CGColor]);
	
    CGContextFillPath(ctx); 	
    
    CGContextSetRGBStrokeColor(ctx, components[0], components[1], components[2], 1.0f);
    CGContextStrokePath(ctx);
	CGContextRestoreGState(ctx);
	
	[self drawTextInRect:contextRect withContext:ctx];
	
}

-(void) clearRect:(CGRect)rect {

	CGContextRef ctx = UIGraphicsGetCurrentContext();	
	CGContextSaveGState(ctx);
	CGContextSetFillColorWithColor(ctx, [[UIColor clearColor] CGColor]);
	CGContextFillRect(ctx, rect);
	CGContextRestoreGState(ctx);
	
}

-(void) dealloc {
    if( self._event ) self._event = nil;
	if( self.text ) self.text = nil;
	if( self.font ) self.font = nil;
    if( self.textColor ) self.textColor = nil;
	if( self.fillColor ) self.fillColor = nil;

	
}


@end
