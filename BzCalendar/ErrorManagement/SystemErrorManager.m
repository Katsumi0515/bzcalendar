//
//  SystemErrorManager.m
//  BzCalendar
//
//  Created by 小林 活水 on 12/12/31.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import "SystemErrorManager.h"
#import "BzTopTabBarController.h"
#import "BzSysErrorReportMailViewController.h"
#import "BzAppDelegate.h"

@interface SystemErrorManager()

@property (nonatomic, retain) NSString* errorAtString;
@property (nonatomic, retain) NSError* errorData;
@property (nonatomic, retain) NSArray* callStack;
@property (nonatomic, retain) UIAlertController* sysErrorAlertView;

@property (nonatomic) BOOL toReport;


@end

@implementation SystemErrorManager

- (UIViewController*) _topViewController {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}


-(void) sysErrorHandle:(NSNotification*)notification {
    LOG_METHOD;
    dispatch_async(dispatch_get_main_queue(), ^{
        //  NSDictionary* dict = notification.userInfo;
        
        BzSysErrorReportMailViewController* ctrl = [[BzSysErrorReportMailViewController alloc] init];
        
        BzAppDelegate* appDelegate = (BzAppDelegate*) [[UIApplication sharedApplication] delegate];
        BzTopTabBarController* tabCtrl = [appDelegate topTabBarController];
        
        BzSysErrorData* sysError = notification.object;
        
        [ctrl prepareWithError:sysError.error
                            at:sysError.location
                     callStack:sysError.stackTraceArray
                       subject:NSLocalizedString(@"MailTitle_Auto_SystemError", @"")
                       message:@""];
        
        [tabCtrl presentViewController:ctrl animated:YES completion:^{}];
        
    });
}


+(SystemErrorManager*)sharedManager {
    static SystemErrorManager* singlton = nil;
    if( singlton == nil) {
        singlton = [[SystemErrorManager alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sysErrorHandle:)
                                                     name:kBzNotification_SystemError
                                                   object:nil];

        
    }
    return singlton;
}

-(void) _resetInfo {
    self.toReport = YES;
    self.errorData = nil;
    self.errorAtString = nil;
    self.callStack = nil;
}
-(void) generalSystemError:(NSError*)pError at:(NSString*)pErrorAt callStack:(NSArray*)pCallStack {
    [self error:pError
             at:pErrorAt
      callStack:pCallStack
 alertWithTitle:nil
        message:nil];
}
-(void) error:(NSError*)pError at:(NSString*)pErrorAt callStack:(NSArray*)pCallStack
alertWithTitle:(NSString*)pTitle message:(NSString*)pMessage {
    [self _resetInfo];
    self.errorData = pError;
    self.errorAtString = pErrorAt;
    self.callStack = pCallStack;
    NSString* _title = pTitle;
    if( !_title ) {
        _title = NSLocalizedString(@"AlertTitle_SystemError", @"システムエラー");
    }
    NSString* _message = pMessage;
    if( !_message ) {
        _message = NSLocalizedString(@"AlertMessage_SuggestReportingToDevelopper", @"エラー発生情報のサポートへの自動送付にご協力お願い致します。");
    }
    UIAlertController * alert =
    [UIAlertController alertControllerWithTitle:_title
                                        message:_message
                                 preferredStyle:UIAlertControllerStyleAlert];
    // Cancel用のアクションを生成
    UIAlertAction * cancelAction =
    [UIAlertAction actionWithTitle:NSLocalizedString(@"Common_CancelButton_Title", @"キャンセル")
                             style:UIAlertActionStyleCancel
                           handler:^(UIAlertAction * action) {
                               // ボタンタップ時の処理
                               NSLog(@"Cancel button tapped.");
                           }];
    
    // OK用のアクションを生成
    UIAlertAction * okAction =
    [UIAlertAction actionWithTitle:NSLocalizedString(@"Common_ExactWord_OK", @"OK")
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {
                               // ボタンタップ時の処理
                               if( !([MFMailComposeViewController canSendMail]) ) {
                                   return;
                               }
                               
                               if( self.toReport ) {
                                   
                                   UIViewController* baseCtrl = nil;
                                   BzAppDelegate* appDelegate = (BzAppDelegate*) [[UIApplication sharedApplication] delegate];
                                   BzTopTabBarController* tabCtrl = [appDelegate topTabBarController];

                                   baseCtrl = [tabCtrl selectedViewController];
                                   LOG(@"class %@",[baseCtrl class]);
                                   
                                   BzSysErrorReportMailViewController* ctrl = [[BzSysErrorReportMailViewController alloc] init];
                                   [ctrl prepareWithError:self.errorData
                                                       at:self.errorAtString
                                                callStack:nil
                                                  subject:NSLocalizedString(@"MailTitle_Auto_SystemError", @"")
                                                  message:@""];
                                   [baseCtrl presentViewController:ctrl animated:YES completion:^{}];
                               }

                           }];
//    UIAlertView* alert = [[UIAlertView alloc]
//                           initWithTitle:_title
//                           message:_message
//                           delegate:self
//                           cancelButtonTitle:NSLocalizedString(@"Common_CancelButton_Title", @"キャンセル")
//                           otherButtonTitles:@"OK",nil];
    self.sysErrorAlertView = alert;
    // コントローラにアクションを追加
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    
    // アラート表示処理
    UIViewController* topViewController = [self _topViewController];
    [topViewController presentViewController:alert animated:YES completion:nil];

    //[self.sysErrorAlertView show];

}
-(void) error:(NSError*)pError at:(NSString*)pErrorAt alertWithTitle:(NSString*)pTitle message:(NSString*)pMessage {
    [self error:pError at:pErrorAt callStack:nil alertWithTitle:pTitle message:pMessage];
}

-(void) errorAt:(NSString*) pErrorAt alertWithTitle:(NSString*)pTitle message:(NSString*)pMessage {
    [self error:nil at:pErrorAt alertWithTitle:pTitle message:pMessage];
}

@end
