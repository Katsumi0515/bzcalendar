//
//  BzSysErrorReportMailViewController.h
//  BzCalendar
//
//  Created by 小林 活水 on 12/12/31.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import <MessageUI/MessageUI.h>

@interface BzSysErrorReportMailViewController : MFMailComposeViewController
<MFMailComposeViewControllerDelegate> {
    
   // NSData* _data;
   // NSError* _error;
   // NSArray* _stackTraceArray;
}

-(id)initWithError:(NSError*)pError at:(NSString*) pErrorAt callStack:(NSArray*) pCallStack
           subject:(NSString*)pSubject message:(NSString*)pMessage;
-(id)initWithError:(NSError*)pError at:(NSString*) pErrorAt
           subject:(NSString*)pSubject message:(NSString*)pMessage;
-(id)initWithErrorAt:(NSString*) pErrorAt subject:(NSString*)pSubject message:(NSString*)pMessage;

-(void)prepareWithError:(NSError*) pError at:(NSString*)pErrorAt callStack:(NSArray*) pCallStack
                subject:(NSString*)title message:(NSString*)message;

/*
-(void)addAttachmentError:(NSError*)error;
-(void)addAttachmentStackTrace;
-(void)setData:(NSData*)data;
*/

@end
