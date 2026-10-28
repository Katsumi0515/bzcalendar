//
//  BzHowToSet_iCloudViewController.m
//  BzCalendar
//
//  Created by 小林 活水 on 12/05/24.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import "BzHowToSet_iCloudViewController.h"

@implementation BzHowToSet_iCloudViewController

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"ViewTitle_HowToSet_iCloud", @"iCloudの設定");
    }
    return self;
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    LOG_METHOD;
    [super viewDidLoad];
    
    NSURL* url = nil;
    
    // 国が日本または、使用言語が日本語の時六曜を表示
    NSString* documentTitle = NSLocalizedString(@"Document_HowToSet_iCloud_DocumentTitle", @"iCloud設定");
    url = [[NSBundle mainBundle] URLForResource:documentTitle withExtension:@"pdf"];
    //Resourceからpdfファイルのurlを取得
    
    NSURLRequest* req = [NSURLRequest requestWithURL:url];
    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.scalesPageToFit = YES;
    [webView loadRequest:req]; 
    [self.view addSubview:webView];
  
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
