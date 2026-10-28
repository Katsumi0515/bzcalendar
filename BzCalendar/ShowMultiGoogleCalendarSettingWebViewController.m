//
//  ShowMultiGoogleCalendarSettingWebViewController.m
//  BzCalendar
//
//  Created by 小林 活水 on 11/11/15.
//  Copyright (c) 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "ShowMultiGoogleCalendarSettingWebViewController.h"
#import "BzCalendar-Swift.h"

@interface ShowMultiGoogleCalendarSettingWebViewController()

@property (nonatomic, retain) UIActivityIndicatorView* indicator;

@end

@implementation ShowMultiGoogleCalendarSettingWebViewController

@synthesize indicator;

- (id) init 
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"Google";
    }
    return self;
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [BzAppThemeService.shared mainBackgroundColor];

    UIActivityIndicatorView* tmpView = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
   // indicator.frame = CGRectMake(0, 0, 100, 100);
   // indicator.center = self.view.center;
    self.indicator = tmpView;

    
    NSURL* url = [NSURL URLWithString:@"https://calendar.google.com/calendar/iphoneselect"];
    NSURLRequest* req = [NSURLRequest requestWithURL:url];
    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.backgroundColor = [BzAppThemeService.shared  mainBackgroundColor];
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    [webView loadRequest:req]; 
    
    [self.view addSubview:webView];

    CGFloat indicatorSize = 50;
    CGRect indicatorRect = self.view.frame;
    LOG(@"self.view.frame.origin.x:   %4.1f      y:%4.1f", indicatorRect.origin.x, indicatorRect.origin.y);
    LOG(@"self.view.frame.size.width: %4.1f height:%4.1f", indicatorRect.size.width, indicatorRect.size.height);
    LOG(@"webView.frame.origin.x:   %4.1f      y:%4.1f", webView.frame.origin.x, webView.frame.origin.y);
    LOG(@"webView.frame.size.width: %4.1f height:%4.1f", webView.frame.size.width, webView.frame.size.height);

    
    indicatorRect.origin.x = ( (self.view.bounds.size.width - indicatorSize) / 2);
    indicatorRect.origin.y = ( ((self.view.bounds.size.height - self.view.frame.origin.y) / 2 ) - indicatorSize);
    LOG(@"indicatorRect.origin.y: %4.1f", indicatorRect.origin.y);
    //indicatorRect.origin.y = 190;
    indicatorRect.size.width = indicatorSize;
    indicatorRect.size.height = indicatorSize;
    self.indicator.frame = indicatorRect;
    [webView addSubview:self.indicator];
    
   

}


- (void) viewWillDisappear:(BOOL)animated {
    [self.indicator stopAnimating];
    [super viewWillDisappear:animated];
}
- (void) webViewDidStartLoad:(UIWebView*)webView {
    LOG_METHOD;
    [self.indicator startAnimating];
}
- (void) webViewDidFinishLoad:(UIWebView*)webView {
    LOG_METHOD;

    [self.indicator stopAnimating];
}
@end
