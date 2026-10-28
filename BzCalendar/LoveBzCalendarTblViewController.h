//
//  LoveBzCalendarTblViewController.h
//  BzCalendar
//
//  Created by 小林 活水 on 12/07/17.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationSubTableViewCtrl_DoneWithShowScheduleView.h"

@interface LoveBzCalendarTblViewController : BaseNavigationSubTableViewCtrl_DoneWithShowScheduleView
<UIWebViewDelegate>{
    
    
    NSURL* reviewURL;
    UIWebView* reviewWebView;
    
}

@end
