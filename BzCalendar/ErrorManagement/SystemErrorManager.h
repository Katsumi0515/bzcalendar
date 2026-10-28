//
//  SystemErrorManager.h
//  BzCalendar
//
//  Created by 小林 活水 on 12/12/31.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BzSysErrorData.h"

#ifndef kBzNotification_SystemError
#define kBzNotification_SystemError @"BzNotification_SystemError"
#endif

@interface SystemErrorManager : NSObject {
    
}

+(SystemErrorManager*)sharedManager;

-(void) error:(NSError*)pError at:(NSString*)pErrorAt callStack:(NSArray*)pCallStack
        alertWithTitle:(NSString*)pTitle message:(NSString*)pMessage;
-(void) generalSystemError:(NSError*)pError at:(NSString*)pErrorAt callStack:(NSArray*)pCallStack;

/*
 -(void) error:(NSError*)pError at:(NSString*)pErrorAt
        alertWithTitle:(NSString*)pTitle message:(NSString*)pMessage;
-(void) errorAt:(NSString*) pErrorAt alertWithTitle:(NSString*)pTitle message:(NSString*)pMessage;
*/
//-(void) alertWithTitle:(NSString*)title message:(NSString*)message report:(BOOL)isReport;

@end
