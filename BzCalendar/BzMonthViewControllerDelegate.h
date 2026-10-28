//
//  BzMonthViewControllerDelegate.h
//  BzCalendar
//
//  Created by 小林 活水 on 12/02/09.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BzViewControllerDelegate.h"

@protocol BzMonthViewControllerDelegate <BzViewControllerDelegate> 

-(NSDate*) date;
-(void) showDayDetail:(BOOL)bl;

@end
