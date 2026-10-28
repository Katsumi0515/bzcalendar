//
//  MonthViewSettingManager.m
//  GSystemT0
//
//  Created by 小林 活水 on 10/02/11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MonthViewSettingManager.h"
#import "CalendarManager.h"

#import "BzCalendar-Swift.h"

@interface MonthViewSettingManager()
@property (nonatomic, retain) UIFont* _fontForEvent;
@property (nonatomic, retain) UIFont* _fontForHeader;
@property (nonatomic)	CGFloat _heightForEvent;
@property (nonatomic)	CGFloat _heightForHeader;
@property (nonatomic, retain) UIFont* _fontForHoliday;

-(id) initSingleton;

@end

@implementation MonthViewSettingManager

@synthesize _fontForEvent;
@synthesize _fontForHeader;
@synthesize _heightForEvent;
@synthesize _heightForHeader;
@synthesize _fontForHoliday;

static MonthViewSettingManager* monthViewSetting = nil;

+(MonthViewSettingManager*) sharedManager {
	if( monthViewSetting == nil ) {
		monthViewSetting = [[MonthViewSettingManager alloc] initSingleton];
	}
	return monthViewSetting;
}

- (void) refresh {
    
    UIFont* systemFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    //システムフォントのインスタンスからフォントサイズを取得
    UIFontDescriptor *fontDesc = [systemFont fontDescriptor];
    NSNumber* fontsize = [fontDesc fontAttributes][UIFontDescriptorSizeAttribute];

    
    BasicAppSettingManager* manager = [[CalendarManager sharedManager] basicSettingManager];
    BasicAppSetting* setting = [manager basicAppSetting];
    NSInteger fontType = 110;
    
    if( setting.fontSizeForMonth ) {
        NSInteger sz = [setting.fontSizeForMonth intValue];
        if( sz > 0 ) {
            fontType = sz;
        }
    }
    if( fontsize.integerValue > 17 ) {
        if( fontType == 100 ) {
            fontType = 110;
        } else if( fontType == 110 ) {
            fontType = 120;
        }
    } else if( fontsize.integerValue < 17 ) {
        if( fontType == 120 ) {
            fontType = 110;
        } else if( fontType == 110 ) {
            fontType = 100;
        }
    }

    
    LOG(@"new fontType: %d", fontType);
    
    
    
    switch (fontType) {
        case 120:
            self._fontForEvent = [UIFont systemFontOfSize:12.0f];
            self._fontForHeader = [UIFont fontWithName:kMonthViewDayCellHeaderFontName size:15.5f];
            
            self._heightForEvent = 15.0f;
            self._heightForHeader = 17.0f;                                
            self._fontForHoliday = [UIFont systemFontOfSize:10.0f];
            break;
        case 100:
            self._fontForEvent = [UIFont systemFontOfSize:10.0f];
            self._fontForHeader = [UIFont fontWithName:kMonthViewDayCellHeaderFontName size:12.5f];
            
            self._heightForEvent = 12.0f;
            self._heightForHeader = 13.0f;
            self._fontForHoliday = [UIFont systemFontOfSize:9.0f];
            break;
        case 110:
        default:
            self._fontForEvent = [UIFont systemFontOfSize:11.0f];
            self._fontForHeader = [UIFont fontWithName:kMonthViewDayCellHeaderFontName size:13.5f];
            
            self._heightForEvent = 14.0f;
            self._heightForHeader = 15.0f;
            
            self._fontForHoliday = [UIFont systemFontOfSize:9.5f];
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
-(UIFont*) fontForHoliday {
    return self._fontForHoliday;
}
@end
