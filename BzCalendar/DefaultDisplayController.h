//
//  DefaultDisplayController.h
//  GSystemT0
//
//  Created by 小林 活水 on 11/01/31.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationSubTableViewCtrl_DoneWithShowScheduleView.h"

@interface DefaultDisplayController : BaseNavigationSubTableViewCtrl_DoneWithShowScheduleView {
	NSArray* selectionArray;
	NSUInteger selectedRow;
}

@end
