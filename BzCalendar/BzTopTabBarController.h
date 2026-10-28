//
//  CalendarModeTabBarController.h
//  GSystemT0
//
//  Created by 小林 活水 on 10/09/05.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BzTopNavBar.h"
#import "CalendarManager.h"
#import "BzApplicationTopViewControllerDelegate.h"

@class BzMonthViewScrollController;
@class BzWeekViewScrollController;
@class SelectOthersNavController;

@interface BzTopTabBarController :  UITabBarController
<UITabBarControllerDelegate,
BzApplicationTopViewControllerDelegate>{

    
}
@property (nonatomic, retain) UIViewController* prevController;

+(id) sharedController;

@end
