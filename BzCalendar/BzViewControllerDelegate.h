//
//  ScheduleViewControllerProtocol.h
//  GSystemT0
//
//  Created by 小林 活水 on 11/07/01.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BzViewControllerDelegate <NSObject>

-(void) setDate:(NSDate*)date;

- (void) loadDataAndDisplayForSelectedDate:(NSDate *)date;

- (void) loadData;
- (void) updateUIComponents;
- (void) loadDataAndDisplay;


- (UIView*)view;
- (void) setContentHeight:(CGFloat)height;

@end
