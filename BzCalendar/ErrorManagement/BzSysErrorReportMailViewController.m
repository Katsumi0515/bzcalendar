//
//  BzSysErrorReportMailViewController.m
//  BzCalendar
//
//  Created by 小林 活水 on 12/12/31.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import "BzSysErrorReportMailViewController.h"



@interface BzSysErrorReportMailViewController ()

@property (nonatomic, strong) NSData* data;
@property (nonatomic, strong) NSError* sysError;
@property (nonatomic, strong) NSArray* stackTraceArray;


@end

@implementation BzSysErrorReportMailViewController

- (void) setData:(NSData *)myData {
    self.data = myData;
}
-(void)addAttachmentError:(NSError*)error {
    self.sysError = error;
}
-(void)addAttachmentStackTrace {
    self.stackTraceArray = [NSThread callStackSymbols];
}
-(void)prepareWithError:(NSError*) pError at:(NSString*)pErrorAt callStack:(NSArray*) pCallStack
                subject:(NSString*)pSubject message:(NSString*)pMessage {
    LOG_METHOD;
    
    // 宛先を設定
    [self setToRecipients:[NSArray arrayWithObjects:@"bugreport@example.com", nil]];
    

    // 題名を設定
    NSString* mySubject = pSubject;
    if( pSubject == nil ) {
        mySubject = [NSString stringWithFormat:@"%@",
                     NSLocalizedString(@"MailTitle_Auto_SystemError", @"[自動設定]システムエラー")];
    }
    [self setSubject: mySubject];
    

    // メール本文を設定
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
    NSString* model = [[UIDevice currentDevice] localizedModel];
    NSString* version= [[UIDevice currentDevice] systemVersion];
    
    NSString* bodyText = pMessage;
    if( bodyText == nil ) {
        bodyText = NSLocalizedString(@"Reporting_AutoSystemError_iCloud_Section_Title",@"");
    }
    
    // エラー個所のnilチェック
    NSString* errorAt = pErrorAt;
    if( errorAt == nil ) {
        errorAt = @"";
    }
    NSString* line = @"----------------------------------------------------";
    NSString* appVerText = @"AppVer:";
    appVerText = [appVerText stringByPaddingToLength:10 withString:@" " startingAtIndex:0];
    NSString* deviceText = @"Device:";
    deviceText = [deviceText stringByPaddingToLength:10 withString:@" " startingAtIndex:0];
    NSString* osText = @"OS:";
    osText = [osText stringByPaddingToLength:10 withString:@" " startingAtIndex:0];
    
    NSString* basicMessageText = @"";
    basicMessageText = [basicMessageText stringByAppendingString:bodyText];
    basicMessageText = [basicMessageText stringByAppendingFormat:@"%@\n%@[%@]\n%@[%@]\n%@[%@]\n%@\n",
                                  line,
                                  appVerText, appVersion,
                                  deviceText, model,
                                  osText, version,
                                  line];
    NSString* locationMessageText = [NSString stringWithFormat:@"\nerror at:\n%@\n",errorAt];
    NSString* messageText = [NSString stringWithFormat:@"%@%@", basicMessageText, locationMessageText];
    
    
    
    if( pError ) {
        NSString* errorString = @"\n----- error info -----\n";
        errorString = [errorString stringByAppendingFormat:@"code:   [%d]\n", (int)pError.code];
        errorString = [errorString stringByAppendingFormat:@"domain: [%@]\n", pError.domain];
        
        NSDictionary* dict = [pError userInfo];
        NSArray* keyArr = dict.allKeys;
        for(NSString* key in keyArr) {
            NSString* strValue = [[dict valueForKey:key] stringValue];
            errorString = [errorString stringByAppendingFormat:@"%@, %@\n",key,strValue];
        }
        messageText = [messageText stringByAppendingString:errorString];
    }
    
    if (pCallStack) {
        NSString* stackString = @"\n----- callStackSymbols -----\n";
        for(NSString* ln in pCallStack ) {
            stackString = [stackString stringByAppendingFormat:@"%@\n", ln];
        }
        messageText = [messageText stringByAppendingFormat:@"\n%@",stackString];
    }

    [self setMessageBody:messageText isHTML:NO];

}
-(id)initWithError:(NSError*)pError at:(NSString*) pErrorAt callStack:(NSArray*) pCallStack
           subject:(NSString*)pSubject message:(NSString*)pMessage {
    self = [super init];
    if( self ) {
        self.mailComposeDelegate = self;
        [self prepareWithError:pError at:pErrorAt callStack:pCallStack subject:pSubject message:pMessage];
    }
    return self;
  
}
-(id)initWithError:(NSError*)pError at:(NSString*) pErrorAt subject:(NSString*)pTitle message:(NSString*)pMessage {
    return [self initWithError:pError at:pErrorAt callStack:nil subject:pTitle message:pMessage];
}

-(id)initWithErrorAt:(NSString*)pErrorAt subject:(NSString*)pTitle message:(NSString*)pMessage {
    return [self initWithError:nil at:pErrorAt subject:pTitle message:pMessage];
}
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.mailComposeDelegate = self;
        _data = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark iOS6対応(iOS6でDepricated等)
-(UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return  UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (UIInterfaceOrientationPortrait == interfaceOrientation);
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate
// メール送信処理完了時のイベント

-(void) _showAlertTitle:(NSString*)title message:(NSString*)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: title
                                                                   message: message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Common_ExactWord_OK", @"OK")
                                                       style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:TRUE completion:nil];
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    LOG_METHOD;
    
    switch (result){
        case MFMailComposeResultCancelled:  // キャンセル
            break;
        case MFMailComposeResultSaved:      // 保存
            break;
        case MFMailComposeResultSent:       // 送信成功
        {
            NSString* _message = NSLocalizedString(@"MailMessage_SentSuccessfully", @"送信に成功しました");
            [self _showAlertTitle:nil message:_message];
            break;
        }
        case MFMailComposeResultFailed:     // 送信に失敗した場合
        {
            NSString* _message = NSLocalizedString(@"MailMessage_SentUnsuccessfully",@"送信に失敗しました");
            [self _showAlertTitle:nil message:_message];
            break;
        }
        default:
            break;
    }
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES
                             completion:^{}
     
     ];
    
}

@end
