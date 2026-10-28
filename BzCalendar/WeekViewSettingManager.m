//
//  WeekViewSettingManager.m
//  BzCalendar
//
//  Created by 小林 活水 on 12/02/09.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import "WeekViewSettingManager.h"
#import "CalendarManager.h"
#import "BasicAppSettingManager.h"

#import "BzCalendar-Swift.h"

@interface WeekViewSettingManager()
@property (nonatomic, retain) UIFont* _fontForEvent;
@property (nonatomic, retain) UIFont* _fontForHeader;
@property (nonatomic)	CGFloat _heightForEvent;
@property (nonatomic)	CGFloat _heightForHeader;
@property (nonatomic, retain) UIFont* _fontForTime;
@property (nonatomic, retain) UIFont* _fontForWeekday;

-(id) initSingleton;

@end

@implementation WeekViewSettingManager

@synthesize _fontForEvent;
@synthesize _fontForHeader;
@synthesize _heightForEvent;
@synthesize _heightForHeader;
@synthesize _fontForTime;
@synthesize _fontForWeekday;

static WeekViewSettingManager* weekViewSetting = nil;

+(WeekViewSettingManager*) sharedManager {
	if( weekViewSetting == nil ) {
		weekViewSetting = [[WeekViewSettingManager alloc] initSingleton];
	}
	return weekViewSetting;
}

- (void) refresh {
    BasicAppSettingManager* manager = [[CalendarManager sharedManager] basicSettingManager];
    BasicAppSetting* setting = [manager basicAppSetting];
    NSInteger fontType = 120;
    
    if( setting.fontSizeForWeek ) {
        fontType = [setting.fontSizeForWeek intValue];
    }
    
    LOG(@"new fontType: %d", fontType);
    NSLocale* locale = [NSLocale currentLocale];
    NSString* langCode = [locale objectForKey:NSLocaleLanguageCode];
    if([langCode compare:@"ja"] == NSOrderedSame) {
        self._fontForWeekday = [UIFont systemFontOfSize:12.0];

    } else {
        self._fontForWeekday = [UIFont systemFontOfSize:11.0];
    }
    
    switch (fontType) {
        case 120:
            self._fontForEvent = [UIFont systemFontOfSize:12.0f];
            self._fontForHeader = [UIFont fontWithName:kMonthViewDayCellHeaderFontName size:15.5f];
            self._fontForTime = [UIFont fontWithName:kScheduleFontName size:11.5f];

            self._heightForEvent = 15.0f;
            self._heightForHeader = 15.0f;                                
            break;
        case 100:
            self._fontForEvent = [UIFont systemFontOfSize:10.0f];
            self._fontForHeader = [UIFont fontWithName:kMonthViewDayCellHeaderFontName size:12.5f];
            self._fontForTime = [UIFont fontWithName:kScheduleFontName size:10.0f];

            self._heightForEvent = 12.0f;
            self._heightForHeader = 12.0f;     
            break;
        case 110:
        default:
            self._fontForEvent = [UIFont systemFontOfSize:11.0f];
            self._heightForEvent = 14.0f;
            self._fontForTime = [UIFont fontWithName:kScheduleFontName size:11.0f];
            
            self._fontForHeader = [UIFont fontWithName:kMonthViewDayCellHeaderFontName size:13.5f];
            
            self._heightForHeader = 13.0f;
            break;
    }
    
}
-(id) initSingleton {
	if((self = [super init]) != nil) {
        [self refresh];
	}
	return self;
}
-(id) init {
    LOG_METHOD;
    LOG(@"use initSingleton");
    SINGLTON_INIT_NOT_ALLOWED;
}
-(UIFont*) fontForEventEntity {
	return self._fontForEvent;
}
-(CGFloat) heightForEventEntity {
	return self._heightForEvent;
}

-(UIFont*) fontForHeader {
	return self._fontForHeader;
}
-(CGFloat) heightForHeader {
	return self._heightForHeader;
}
-(UIFont*) fontForTime {
    return self._fontForTime;
}
-(UIFont*) fontForWeekday {
    return self._fontForWeekday;
}

@end
