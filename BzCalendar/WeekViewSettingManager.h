//
//  WeekViewSettingManager.h
//  BzCalendar
//
//  Created by 小林 活水 on 12/02/09.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeekViewSettingManager : NSObject {

    UIFont* _fontForEvent;
    UIFont* _fontForHeader;
    UIFont* _fontForWeekday;
    UIFont* _fontForTime;
    
    CGFloat _heightForEvent;
    CGFloat _heightForHeader;
}

+(WeekViewSettingManager*) sharedManager;
-(UIFont*) fontForEventEntity;
-(CGFloat) heightForEventEntity;
-(UIFont*) fontForHeader;
-(CGFloat) heightForHeader;
-(UIFont*) fontForTime;
-(UIFont*) fontForWeekday;

-(void) refresh;

@end
