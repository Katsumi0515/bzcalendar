//
//  BzOffdayCalendarTblViewController.h
//  BzCalendar
//
//  Created by 小林 活水 on 12/07/09.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "BaseNavigationSubTableViewCtrl_DoneWithShowScheduleView.h"

@interface BzOffdayCalendarTblViewController : BaseNavigationSubTableViewCtrl_DoneWithShowScheduleView {
    NSArray* selectableCalendars;   //選択可能なカレンダーのリスト
    EKCalendar* curOffdayCalendar;
    
    NSIndexPath* selectedIndexPath;
}

@end
