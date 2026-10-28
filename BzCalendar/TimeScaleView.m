//
//  TimeScaleView.m
//  GSystemT0
//
//  Created by 小林 活水 on 10/08/18.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "TimeScaleView.h"

@implementation TimeScaleView


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
        
        // ToDo: アプリケーション設定から取得するよう変更
        UIFont* font = [UIFont fontWithName:kScheduleFontName size:14.0f];
        
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
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		timeLabelArray = [[NSMutableArray alloc] initWithCapacity:24];
        // Initialization code
		UILabel* hourLabel;
		
		CGFloat startY = 0.0f;
		CGFloat currentY = startY;
		topMargin = 0.0f;
		hourHeight = (frame.size.height - topMargin*2) / 24.0f;
		
		// ToDo: アプリケーション設定から取得するよう変更
		UIFont* font = [UIFont fontWithName:kScheduleFontName size:14.0f];
		
		currentY += topMargin;
		for(int index=0; index < 24; index++) {
		
			// ToDo: アプリケーション設定から取得するよう変更(80という数値）
			hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,currentY, 80, hourHeight)];
			
			hourLabel.font = font;
			hourLabel.backgroundColor = self.superview.backgroundColor;
			
			//hourLabel.textAlignment = UITextAlignmentLeft;
			//hourLabel.verticalAlignment = VerticalAlignmentMiddle;
			
			NSString* hourStr = [NSString stringWithFormat:@"%02d:00", index];
			hourLabel.text = hourStr;
			[self addSubview:hourLabel];
			[timeLabelArray addObject:hourLabel];
			currentY += hourHeight;
			
			// [hourStr release];
		}
		
		
		
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void) setHourHeight:(CGFloat)height {
	hourHeight = height;
}
- (void) setTopMargin:(CGFloat)top {
	topMargin = top;
}

-(void) layoutSubviews {
	LOG_METHOD;
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
		
		vv.backgroundColor = [UIColor clearColor];
	//	vv.backgroundColor = [UIColor whiteColor];
		[vv setNeedsLayout];
		[vv setNeedsDisplay];
		
		//[self addSubview:vv];
		index++;
	}	
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
	[timeLabelArray removeAllObjects];
	timeLabelArray =nil;
    
}


@end
