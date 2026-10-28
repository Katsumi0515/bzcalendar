//
//  BzWeekViewControllerDelegate.h
//  BzCalendar
//
//  Created by 小林 活水 on 12/09/08.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BzViewControllerDelegate.h"

@protocol BzWeekViewControllerDelegate <BzViewControllerDelegate>

-(NSDate*) startDate;
-(NSDate*) endDate;

@end
