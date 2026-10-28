//
//  MonthViewSettingManager.h
//  GSystemT0
//
//  Created by 小林 活水 on 10/02/11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MonthViewSettingManager : NSObject {
	UIFont* _fontForEvent;
    UIFont* _fontForHeader;
    CGFloat _heightForEvent;
    CGFloat _heightForHeader;
    
    UIFont* _fontForHoliday;
    
}

+(MonthViewSettingManager*) sharedManager;
-(UIFont*) fontForEventEntity;
-(CGFloat) heightForEventEntity;
-(UIFont*) fontForHeader;
-(CGFloat) heightForHeader;

-(UIFont*) fontForHoliday;

-(void) refresh;

@end
