//
//  WeekTimeScaleView.h
//  GSystemT0
//
//  Created by 小林 活水 on 11/03/08.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekTimeScaleView : UIView {
	NSMutableArray* timeLabelArray;
	CGFloat hourHeight;
	CGFloat topMargin;
	
	CGFloat _activeTimeStart;
	CGFloat _activeTimeEnd;
	
	CGFloat offsetX;
}
@property CGFloat activeTimeStart;
@property CGFloat activeTimeEnd;

@property CGFloat offsetX;

- (void) setHourHeight:(CGFloat)height;
- (void) setTopMargin:(CGFloat)top;

@end
