//
//  HowToAddMultiGoogleCalendarViewController.m
//  BzCalendar
//
//  Created by 小林 活水 on 11/11/15.
//  Copyright (c) 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "HowToAddMultiGoogleCalendarViewController.h"
#import "ShowMultiGoogleCalendarSettingWebViewController.h"

@implementation HowToAddMultiGoogleCalendarViewController

-(void)goToGoogle:(UIButton*)btn {
    ShowMultiGoogleCalendarSettingWebViewController* ctrl = 
    [[ShowMultiGoogleCalendarSettingWebViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (id) init 
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"ViewTitle_HowTo_MultiGoogleCalendar", 
                                       @"複数カレンダーとの同期");
    }
    return self;
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect = self.view.bounds;
    rect.size.height = 150;
    UITextView* field = [[UITextView alloc] initWithFrame:rect];
    field.editable = NO;
    field.text = NSLocalizedString(@"HowTo_MultiGoogleCalendar_Text", 
                                   @"複数のグーグルカレンダーとの同期をするにはgoogle上での設定が必要です。下記リンクにて同期したいカレンダーを選択してください。");
    field.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:field];
   
    
    CGFloat margin = 10;
    CGRect btnRect = self.view.bounds;
    btnRect.origin.x = margin;
    btnRect.origin.y = rect.origin.y + rect.size.height + 20;
    btnRect.size.height = 50;
    btnRect.size.width -= (margin * 2);
    UIButton* goToGoogleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    goToGoogleBtn.frame = btnRect;
    [goToGoogleBtn setTitle:NSLocalizedString(@"HowTo_MultiGoogleCalendar_GoToGoogleSettingSite", 
                                              @"設定サイト（グーグル）へ")
                   forState:UIControlStateNormal];
    [goToGoogleBtn addTarget:self
                      action:@selector(goToGoogle:) 
            forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:goToGoogleBtn];
}

- (void) viewWillAppear:(BOOL)animated {
    
    NSString* backText = NSLocalizedString(@"Common_BarButtonItem_Back", @"戻る");
    UIBarButtonItem* backBarButtonItem = [[UIBarButtonItem alloc]
                                          initWithTitle:backText
                                          style:UIBarButtonItemStyleDone 
                                          target:nil
                                          action:nil];
    [backBarButtonItem setTintColor:[UIColor whiteColor]];
    
    // Set custom back button.
    [self.navigationItem setBackBarButtonItem:backBarButtonItem];
    

    [super viewWillAppear:animated];
}
@end
