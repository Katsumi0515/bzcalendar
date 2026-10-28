//
//  HolidaySelectionViewController.h
//  GSystemT0
//
//  Created by 小林 活水 on 11/02/28.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationSubTableViewCtrl_DoneWithShowScheduleView.h"

@interface HolidaySelectionViewController : BaseNavigationSubTableViewCtrl_DoneWithShowScheduleView {
	
    NSMutableArray* selectionNameList;
    NSArray* allWorldCalendars;
	NSUInteger selectedRow;	// 
}

@end
