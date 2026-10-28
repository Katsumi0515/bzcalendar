//
//  ScheduleSheetView.h
//  GSystemT0
//
//  Created by 小林 活水 on 10/08/12.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleScaleView : UIView {
	CGFloat topMargin;
	//CGFloat bottomMargin;
	CGFloat offsetY;
	CGFloat hourHeight;
	
	CGFloat _activeTimeStart;
	CGFloat _activeTimeEnd;
}

-(void)setNonActiveColor:(UIColor*)color;

-(void)setActiveTimeStart:(CGFloat)time;
-(void)setActiveTimeEnd:(CGFloat)time;

-(void) setHourHeight:(CGFloat)height;
-(void) setTopMargin:(CGFloat)top;

@end
