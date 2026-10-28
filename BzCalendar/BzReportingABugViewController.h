//
//  BzReportingABugViewController.h
//  BzCalendar
//
//  Created by 小林 活水 on 12/05/27.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import "BaseNavSubViewCtrl_DoneWithShowScheduleView.h"

@interface BzReportingABugViewController : BaseNavSubViewCtrl_DoneWithShowScheduleView 
<UITableViewDelegate, UITableViewDataSource> {
    
    UITableView* _tableView;

}

@end
