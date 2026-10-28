//
//  DayCellView.h
//  GSystemT0
//
//  Created by 小林 活水 on 09/12/11.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

#define DayCell_CELL_Margin_X		1.0f
#define DayCell_Schedule_Margin_Y 	0.0f

@class BZVMWeekRowDayItem;
@class BZVMWeekRoyHolidayItem;

@interface DayCellView : UIView {
	
}

@property (nonatomic, strong) NSDate* date;


-(void) setDisabled:(BOOL)bl;

//-(void) setDate:(NSDate*)dt;
-(void) setOptionText:(NSString*)opText;

-(void) addHolidayEntity:(NSString *)holidayText rowIndex:(NSInteger)rowIndex;
//-(void) addHolidayItem:(BZVMWeekRoyHolidayItem*)item;
-(void) addDayItem:(BZVMWeekRowDayItem*)item;



-(CGFloat) scheduleOriginY;
-(CGFloat) originYForRowIndex:(NSInteger)rowIdx;

-(void) clearView;
-(void) showShedules;


@end
