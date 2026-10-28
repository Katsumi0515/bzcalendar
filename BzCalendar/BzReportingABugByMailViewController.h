//
//  BzReportingABugByMailViewController.h
//  BzCalendar
//
//  Created by 小林 活水 on 12/05/29.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface BzReportingABugByMailViewController : MFMailComposeViewController
<MFMailComposeViewControllerDelegate> {
    
}

- (void) setDefaultData;

@end
