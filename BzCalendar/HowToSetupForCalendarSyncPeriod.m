//
//  HowToSetupForCalendarSyncPeriod.m
//  BzCalendar
//
//  Created by 小林 活水 on 11/11/15.
//  Copyright (c) 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "HowToSetupForCalendarSyncPeriod.h"

@implementation HowToSetupForCalendarSyncPeriod

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"ViewTitle_HowTo_CalendarSyncPeriod", 
                                       @"同期期間の設定");
    }
    return self;
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //Resourceからpdfファイルのurlを取得
    NSString* documentTitle = NSLocalizedString(@"Document_HowToSetupForCalendarSyncPeriod_DocumentTitle",
                                                @"同期期間の設定について");
    NSURL *url = [[NSBundle mainBundle] URLForResource:documentTitle withExtension:@"pdf"];
    
    NSURLRequest* req = [NSURLRequest requestWithURL:url];
    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.scalesPageToFit = YES;
    [webView loadRequest:req]; 
    [self.view addSubview:webView];
    
}

@end
