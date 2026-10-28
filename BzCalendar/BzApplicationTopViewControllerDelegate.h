//
//  BzApplicationTopViewControllerDelegate.h
//  BzCalendar
//
//  Created by 小林 活水 on 12/09/23.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarManager.h"

@protocol BzApplicationTopViewControllerDelegate <NSObject>


-(void) selectDefaultDisplayMode;

-(AppCalendarDisplayMode) currentDisplayMode;
-(void) selectDisplayMode:(AppCalendarDisplayMode)mode;

-(void) refreshCurrentEventView;

/* showMainView
 * 日ビュー、週ビュー、月ビュー等のメインビューへ遷移する
 */
-(void) showMainView;
-(void) applicationResumed;

// EKEventのハンドリング
-(void) openEvent:(EKEvent*)event; // onViewController:(UIViewController*)controller;
-(void) editEvent:(EKEvent*)event; // onController:(UIViewController*)controller;
-(void) addTemplate:(EKEvent*)event;

@end
