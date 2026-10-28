//
//  BzReportingABugByMailViewController.m
//  BzCalendar
//
//  Created by 小林 活水 on 12/05/29.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import "BzReportingABugByMailViewController.h"

@interface BzReportingABugByMailViewController ()

@end

@implementation BzReportingABugByMailViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.mailComposeDelegate = self;
        [self setDefaultData];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	//[self.navigationBar setBarTintColor:[UIColor blackColor]];

	NSLog(@"tint color: %@", self.navigationBar.tintColor);
}
- (void)viewWillAppear:(BOOL)animated {
	self.navigationBar.barTintColor = [UIColor whiteColor];
	[self.view setNeedsDisplay];
	[super viewWillAppear:animated];
}
- (void) setDefaultData {
    LOG_METHOD;
   // self.mailComposeDelegate = self;

    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];

    NSString* model = [[UIDevice currentDevice] localizedModel];
    NSString* version= [[UIDevice currentDevice] systemVersion];

    // 題名を設定
    NSString* mySubject = [NSString stringWithFormat:@"%@ [%@]",
                           NSLocalizedString(@"MailTitle_AboutABug", @"不具合について"), 
                           appVersion];
    [self setSubject: mySubject];
	self.title = mySubject;
	
    // メール本文を設定
    
    NSString* headerText = NSLocalizedString(@"Mail_BugDescription",@"不具合内容：");
    NSString* blankLines = @"\n\n\n\n\n\n\n";
    NSString* line = @"----------------------------------------";
    NSString* info = [NSString stringWithFormat:   @"%@\nDevice: [%@][%@]",line, model, version];
    NSString* appInfo = [NSString stringWithFormat:@"Ver.  : [%@]\n%@", appVersion, line];
    NSString* messageText = [NSString stringWithFormat:@"%@%@%@\n%@", 
                             headerText, 
                             blankLines,
                             info, 
                             appInfo];
    [self setMessageBody:messageText isHTML:NO];
    
    // 宛先を設定
    [self setToRecipients:[NSArray arrayWithObjects:@"bugreport@example.com", nil]];
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - MFMailComposeViewControllerDelegate

-(void) _showAlertTitle:(NSString*)title message:(NSString*)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: title
                                                                   message: message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Common_ExactWord_OK", @"OK")
                                                       style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:TRUE completion:nil];

}
// メール送信処理完了時のイベント
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    LOG_METHOD;
    
    switch (result){
        case MFMailComposeResultCancelled:  // キャンセル
            break;
        case MFMailComposeResultSaved:      // 保存
            break;
        case MFMailComposeResultSent:       // 送信成功
        {
            [self _showAlertTitle:nil message:NSLocalizedString(@"MailMessage_SentSuccessfully", @"送信に成功しました")];
            break;
        }
        case MFMailComposeResultFailed:     // 送信に失敗した場合
        {
            [self _showAlertTitle:nil message:NSLocalizedString(@"MailMessage_SentUnsuccessfully",@"送信に失敗しました")];          
            break;
        }
        default:
            break;
    }
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{}];

}

@end
