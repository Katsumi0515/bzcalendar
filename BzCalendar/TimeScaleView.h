//
//  TimeScaleView.h
//  GSystemT0
//
//  Created by 小林 活水 on 10/08/18.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeScaleView : UIView {
	NSMutableArray* timeLabelArray;
	CGFloat hourHeight;
	CGFloat topMargin;
}

- (void) setHourHeight:(CGFloat)height;
- (void) setTopMargin:(CGFloat)top;

@end
