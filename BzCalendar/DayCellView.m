//
//  DayCellView.m
//  GSystemT0
//
//  Created by 小林 活水 on 09/12/11.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DayCellView.h"
#import <EventKit/EventKit.h>
#import <QuartzCore/QuartzCore.h>

#import "MonthViewSettingManager.h"
#import "CalendarManager.h"
#import "BzAppDelegate.h"
#import "CalendarManager.h"

#import "DayCellHeaderView.h"
#import "MVDayScheduleView.h"


#import "BzCalendar-Swift.h"

@interface DayCellView()

@property CGFloat curY;

@property(nonatomic, retain) BzMoreEventToShowView* moreView;

@property BOOL hasMoreEventToShow;
@property(nonatomic, strong) DayCellHeaderView* headerView;
@property(nonatomic, strong) NSMutableArray* scheduleViewArray;
@property BOOL isDisabled;

//-(void) singleTap:(UITapGestureRecognizer*)tap;
//-(void) doubleTap:(UITapGestureRecognizer*)tap;

-(CGFloat) eventViewLogicalHeight;

@end

@implementation DayCellView


-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if( self ) {
//        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
//        singleTap.numberOfTapsRequired = 1;
//        singleTap.numberOfTouchesRequired = 1;
//        [self addGestureRecognizer:singleTap];
//        
//        UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
//        doubleTap.numberOfTapsRequired = 2;
//        doubleTap.numberOfTouchesRequired = 1;
//        [self addGestureRecognizer:doubleTap];
        
        
        self.backgroundColor = [UIColor grayColor];
        
        //ボーダーの設定
        //これをすることでUIViewの中にUIViewを作成する方法でのボーダー表記を回避する
        self.layer.borderWidth = 0.5f;
        UIColor* color = [[ColorUtil shared] UIColorFromColorCode:@"#C0C0C0"];
        self.layer.borderColor = [color CGColor];
        self.curY = 0.0f;
        CGFloat xMargin = 1.0f;
        
        CGFloat headerHeight = [[MonthViewSettingManager sharedManager] heightForHeader];
        CGRect headerFrame = CGRectMake(xMargin, self.curY, self.frame.size.width - (xMargin*2.0f), headerHeight);
        self.headerView = [[DayCellHeaderView alloc] initWithFrame:headerFrame];
        
        //[self addSubview:headerView];
        [self performSelectorOnMainThread:@selector(addSubview:)
                               withObject:self.headerView
                            waitUntilDone:NO];
        
        self.curY += headerFrame.size.height;
        
        self.scheduleViewArray = [[NSMutableArray alloc] initWithCapacity:10];
        
        self.clipsToBounds = YES;
        
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame]) != nil) {
        // Initialization code

//        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
//        singleTap.numberOfTapsRequired = 1;
//        singleTap.numberOfTouchesRequired = 1;
//        [self addGestureRecognizer:singleTap];
//        
//        UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
//        doubleTap.numberOfTapsRequired = 2;
//        doubleTap.numberOfTouchesRequired = 1;
//        [self addGestureRecognizer:doubleTap];
        

		self.backgroundColor = [UIColor grayColor];
		
		//ボーダーの設定　
		//これをすることでUIViewの中にUIViewを作成する方法でのボーダー表記を回避する
		self.layer.borderWidth = 0.5f;
        UIColor* color = [[ColorUtil shared] UIColorFromColorCode:@"#C0C0C0"];
        self.layer.borderColor = [color CGColor];
		self.curY = 0.0f;
		CGFloat xMargin = 1.0f;
		
		CGFloat headerHeight = [[MonthViewSettingManager sharedManager] heightForHeader];
		CGRect headerFrame = CGRectMake(xMargin, self.curY, frame.size.width - (xMargin*2.0f), headerHeight);
		self.headerView = [[DayCellHeaderView alloc] initWithFrame:headerFrame];

        [self performSelectorOnMainThread:@selector(addSubview:)
                               withObject:self.headerView
                            waitUntilDone:NO];

		self.curY += headerFrame.size.height;

		self.scheduleViewArray = [[NSMutableArray alloc] initWithCapacity:10];
        
		self.clipsToBounds = YES;
		
		self.userInteractionEnabled = YES;
		self.multipleTouchEnabled = YES;
        
	}
    return self;
}


-(CGFloat) eventViewLogicalHeight {
    CGFloat eventHeight = [[MonthViewSettingManager sharedManager] heightForEventEntity];
    eventHeight += DayCell_Schedule_Margin_Y;
    return eventHeight;
}

- (void) addHolidayEntity:(NSString*)holidayText rowIndex:(NSInteger)rowIndex {

    NSInteger rowIdx = rowIndex;
	
	CGFloat logicalHeight =  [self eventViewLogicalHeight];
	
	CGFloat tmpY = self.headerView.frame.size.height + (logicalHeight * rowIdx);

	CGRect cellFrame = CGRectMake(DayCell_CELL_Margin_X, 
								  tmpY, 
								  self.frame.size.width - (DayCell_CELL_Margin_X*2.0), 
								  logicalHeight - (DayCell_Schedule_Margin_Y));
	
	BzMVHolidayView* schedEnt = [[BzMVHolidayView alloc] initWithFrame:cellFrame];
    schedEnt.font = [[MonthViewSettingManager sharedManager] fontForHoliday];

	schedEnt.index = rowIdx;
	schedEnt.text = holidayText;
    schedEnt.clearColor = self.backgroundColor;
    
	[self addSubview:schedEnt];
	[self.scheduleViewArray addObject:schedEnt];
	
	self.curY = tmpY + logicalHeight;
	
	if( self.curY < tmpY ) {
		self.curY = tmpY;
	}
	
}

-(void) addHolidayItem:(BZVMWeekRoyHolidayItem*)item {
//    [self addHolidayEntity: [item title] rowIndex:[item _rowIndex]];
}
- (void) addDayItem:(BZVMWeekRowDayItem*)item {
    int rowIdx = (int)item.rowIndex;
    
    UIColor* calendarColor = [item calendarColor];
    
    
    CGFloat logicalHeight = [self eventViewLogicalHeight];
    
    CGFloat tmpY = self.headerView.frame.size.height + (logicalHeight * (rowIdx));
    
    CGRect cellFrame = CGRectMake(DayCell_CELL_Margin_X,
                                  tmpY,
                                  self.frame.size.width - (DayCell_CELL_Margin_X*2.0),
                                  logicalHeight - (DayCell_Schedule_Margin_Y));
    
    MVDayScheduleView* schedEnt = [[MVDayScheduleView alloc] initWithFrame:cellFrame];
    schedEnt.font = [[MonthViewSettingManager sharedManager] fontForEventEntity];
    
//    schedEnt.verticalAlignment = VerticalAlignmentMiddle;
    
    schedEnt.index = rowIdx;
    schedEnt.text = [item title];
    
    UIColor* bgColor = [item bgColor];
    UIColor* textColor = [item textColor];
    
    if( [item isAllDay] == TRUE ) {
        schedEnt.textColor = textColor;
        schedEnt.backgroundColor = bgColor;
        
        schedEnt.clearColor = self.backgroundColor;
    } else if( calendarColor != nil ) {
        // バックグランドカラーをテキストカラーに
        
        schedEnt.textColor = bgColor;
        schedEnt.backgroundColor = self.backgroundColor;
        schedEnt.clearColor = self.backgroundColor;
    } else {
        schedEnt.textColor = [UIColor blackColor];
        schedEnt.backgroundColor = self.backgroundColor;
        schedEnt.clearColor = self.backgroundColor;
    }
    
    [self.scheduleViewArray addObject:schedEnt];
    
    self.curY = tmpY + logicalHeight;
    
    if( self.curY < tmpY ) {
        self.curY = tmpY;
    }
    

}

-(void) setDisabled:(BOOL)bl {
	self.isDisabled = bl;
	//[headerView setHidden:bl];
	[self setHidden:bl];
	
	// ToDo: アプリケーション設定から背景色を設定するようにする
	if( bl == YES ) {
        //UIColor* color =[UIColor colorWithRed:0xDC green:0xDC blue:0xDC alpha:1.0f];
        UIColor* color = [UIColor lightGrayColor];
        self.backgroundColor = color;
		self.headerView.backgroundColor = color;
	} else {
		self.backgroundColor = [UIColor whiteColor];
		self.headerView.backgroundColor = [UIColor whiteColor];
	}	
}

- (void)setDate:(NSDate *)dt {
    NSCalendar* calendar = [[CalendarManager sharedManager] appCalendar];
    
    NSInteger day = [calendar component:NSCalendarUnitDay fromDate:dt];
    //[self setDay: day];
    NSString* str = [NSString stringWithFormat:@"%d", (int)day];
    self.headerView.dayString = str;
}

-(void) setOptionText:(NSString*)opText {
	self.headerView.optionString = opText;
    [self.headerView setNeedsDisplay];
}

- (void) clearView {
    
    CGFloat headerHeight = [[MonthViewSettingManager sharedManager] heightForHeader];
    CGRect headerRect = self.headerView.frame;
    headerRect.size.height = headerHeight;
    self.headerView.frame = headerRect;
    
    [self.headerView setHeadarFont:[[MonthViewSettingManager sharedManager] fontForHeader]];
	self.headerView.dayString = EMPTY_STRING;
	self.isDisabled = NO;
	[self clearSchedules];
}

- (void) showShedules {
    self.hidden = YES;
    for(MVDayScheduleView* vv in self.scheduleViewArray) {
        [self addSubview:vv];
    }
    self.hidden = NO;
}

- (void) clearSchedules {
    
	NSArray* mySubviews = [self subviews];
	NSInteger cnt = [mySubviews count];
	for(int i=0; i < cnt; i++) {
		UIView* tmpView = [mySubviews objectAtIndex:i];
		if( (tmpView != self.headerView)  ) {
			[tmpView removeFromSuperview];
		}
	}
	 
	self.curY = self.headerView.frame.size.height;
	[self.scheduleViewArray removeAllObjects];

}

- (void) setBackgroundColor:(UIColor *)newColor {
    
	[super setBackgroundColor:newColor];
	[self.headerView setBackgroundColor:newColor];
}

-(CGFloat) scheduleOriginY {
	CGFloat schedOriginY = self.headerView.frame.origin.y + self.headerView.frame.size.height;
	return schedOriginY;
}

-(CGFloat) originYForRowIndex:(NSInteger)rowIdx {
    CGFloat rtnVal;
	CGFloat logicalHeight = [self eventViewLogicalHeight];
    // スケジュール描画領域のY座標オフセット()を動的に取得するのでheaderViewの動的サイズ変更が可能なはず
	CGFloat schedOriginY = [self scheduleOriginY];
    rtnVal = schedOriginY + (logicalHeight * rowIdx);
    
    return rtnVal;
}

-(void) layoutSubviews {
	LOG_METHOD;
    
    self.hasMoreEventToShow = NO;
    CGFloat headerHeight = [[MonthViewSettingManager sharedManager] heightForHeader];
    CGRect headerFrame = self.headerView.frame;
    headerFrame.size.height = headerHeight;
    headerFrame.size.width = self.bounds.size.width;
    
    self.headerView.frame = headerFrame;
    [self.headerView setNeedsLayout];
    
    CGFloat diff = 2;
    CGFloat limitY = self.bounds.size.height + diff;
    
	//MVDayScheduleView* lastEventView = nil;
	Class schedClass = [MVDayScheduleView class];
	for( id schedObj in self.scheduleViewArray ) {
		if( [schedObj isKindOfClass:schedClass] ) {
			MVDayScheduleView* schedView = (MVDayScheduleView*)schedObj;
			NSUInteger rowIdx = schedView.index;
			CGRect schedFrame = schedView.frame;
			schedFrame.origin.y = [self originYForRowIndex:rowIdx];
			schedView.frame = schedFrame;
			
            //[self addSubview:schedView];
            
            if( (schedFrame.origin.y + schedFrame.size.height ) > limitY ) {
                self.hasMoreEventToShow = YES;
             //   LOG(@"no more! break!");
                break;
            }
            
          //  lastEventView = schedView;
            [schedView setNeedsDisplay];
		}
	}
    /*
    if( lastEventView ) {
        CGFloat endY = lastEventView.frame.origin.y + lastEventView.frame.size.height;
        CGFloat diff = 2;
        if( endY > (self.bounds.size.height + diff)) {
            LOG(@"hasMoreEventToShow! on: %@", self.date);
            hasMoreEventToShow = YES;
        }
    }
     */
    if( self.hasMoreEventToShow ) {
        CGFloat viewWidth = 12.0f;
        CGFloat viewHeight = 12.0f;
        CGRect rect;
        rect.origin.x = self.bounds.size.width - viewWidth;
        rect.origin.y = self.bounds.size.height - viewHeight;
        rect.size.width = viewWidth;
        rect.size.height = viewHeight;

        BzMoreEventToShowView* tmpMoreView = [[BzMoreEventToShowView alloc] initWithFrame:rect];
        self.moreView = tmpMoreView;
        [self addSubview:self.moreView];
           }

 }
 

#pragma mark -
#pragma mark UITapGestureRecognizer
//-(void) singleTap:(UITapGestureRecognizer*)tap {
//
//    if( self.date != nil ) {
//        [[CalendarManager sharedManager] setSelectedDate:self.date];
//
//        if (UIGestureRecognizerStateEnded == tap.state) {
//            // BzMonthViewScrollController* mgr = [BzMonthViewScrollController sharedController];
//            // [mgr displayCurrentPage];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"DayCellViewSelectedDateChanged" object:nil];
//
//        }
//    } else {
//
//    }
//}
//-(void)doubleTap:(UITapGestureRecognizer*)tap {
//    if (UIGestureRecognizerStateEnded == tap.state) {
//        [[CalendarManager sharedManager] setSelectedDate:self.date];
//        BzAppDelegate* appDelegate = (BzAppDelegate*)[[UIApplication sharedApplication] delegate];;
//        [[appDelegate topViewControllerDelegate] selectDisplayMode:AppCalendarDisplayModeDaily];
//    }
//}

@end
