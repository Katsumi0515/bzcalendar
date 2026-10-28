//
//  SupportByFacebookViewController.m
//  BzCalendar
//
//  Created by 小林 活水 on 11/11/15.
//  Copyright (c) 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "SupportByFacebookViewController.h"
#import "BzCalendar-Swift.h"

@interface SupportByFacebookViewController()

@property (nonatomic, retain) UIActivityIndicatorView* indicator;

@end
@implementation SupportByFacebookViewController

@synthesize indicator;

- (id) init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"ViewTitle_Support_Facebook", @"サポート(FB)");
    }
    return self;
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    LOG_METHOD;
    
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    self.view.backgroundColor = [[BzAppThemeService sharedObject] mainBackgroundColor];
    
    UIActivityIndicatorView* tmpView = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    // indicator.frame = CGRectMake(0, 0, 100, 100);
    // indicator.center = self.view.center;
    self.indicator = tmpView;

    NSString* facebook_url = NSLocalizedString(@"Facebook_FunPage_URL", @"フェースブックファンページへのURL");
    NSURL* url = [NSURL URLWithString:facebook_url];
    NSURLRequest* req = [NSURLRequest requestWithURL:url];
    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.backgroundColor = [BzAppThemeService.shared mainBackgroundColor];
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    [webView loadRequest:req]; 
    
    [self.view addSubview:webView];
    


    
    CGFloat indicatorSize = 50;
    CGRect indicatorRect = self.view.frame;    
    
    indicatorRect.origin.x = ( (self.view.bounds.size.width - indicatorSize) / 2);
    indicatorRect.origin.y = ( ((self.view.bounds.size.height - self.view.frame.origin.y) / 2 ) - indicatorSize);
    LOG(@"indicatorRect.origin.y: %4.1f", indicatorRect.origin.y);
    //indicatorRect.origin.y = 190;
    indicatorRect.size.width = indicatorSize;
    indicatorRect.size.height = indicatorSize;
    self.indicator.frame = indicatorRect;
    [webView addSubview:self.indicator];
    
    

}
- (void)viewWillDisappear:(BOOL)animated {
    [self.indicator stopAnimating];
    [super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark UIWebViewDelegate
- (void) webViewDidStartLoad:(UIWebView*)webView {
    LOG_METHOD;
    [self.indicator startAnimating];
}
- (void) webViewDidFinishLoad:(UIWebView*)webView {
    LOG_METHOD;
    
    [self.indicator stopAnimating];
}

@end
