//
//  CalendarManager.h
//  GCodeTestWin
//
//  Created by 小林 活水 on 09/09/21.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <EventKit/EventKit.h>
#import "BasicAppSettingManager.h"

@class ColorSettingManager;

/* ToDo
 *      このクラスの役割が不明確になっているので、リファクタリングが必須
 *
 *
 *
 *
 *
 *
*/



typedef enum : NSUInteger {
    AppCalendarDisplayModeKeepPreviousMode = 0,
    AppCalendarDisplayModeDaily,
	AppCalendarDisplayModeWeekly,
    AppCalendarDisplayModeMonthly
} AppCalendarDisplayMode;

#define _kWeekdayIndexSunday	1
#define _kWeekdayIndexSaturday	0


@interface CalendarManager : NSObject {
	
	// サブマネージャのインスタンスを管理
	/*
	AccountManager* accountEntityManager;			//　アカウント用サブマネージャ 外部に提供しない
	CalendarEntityManager* calendarEntityManager;	//　カレンダーエンティティ用サブマネージャ
	EventEntityManager* eventEntityManagar;			//　イベントエンティティ用サブマネージャ
	SyncManager* syncManager;
	*/
	
	BasicAppSettingManager* _basicSettingManager;				//　アプリケーションレイアウト用サブマネージャ
	ColorSettingManager* _appSettingColorManager;
    
	// Core Data Methods
	//NSManagedObjectContext* managedObjectContext;
	//NSManagedObjectModel* managedObjectModel;
	//NSPersistentStoreCoordinator* persistentStoreCoordinator;
	
	EKEventStore* eventStore;
	
	NSDate* _selectedDate;
	
	NSCalendar* appCalendar;
	
    NSUInteger weekday;
    NSUInteger selectedYear;
    NSUInteger selectedMonth;
    NSUInteger day;

    
    // リフレッシュの通知先
    UIViewController* gController;
    
    NSDateFormatter* commonDateFormatter;
    NSDateFormatter* _dateFormatter_yMMMM;
    NSDateFormatter* _dateFormatter_fullStyle;
    
    
    BOOL _iCloudCapable;
    
    id <NSObject, NSCopying, NSCoding>  currentUbiquityToken;

}

// Class Methods
+(CalendarManager*) sharedManager;

@property (nonatomic, retain) NSDate* selectedDate;
@property (nonatomic, readonly) NSUInteger selectedYear;
@property (nonatomic, readonly) NSUInteger selectedMonth;

@property (nonatomic) AppCalendarDisplayMode displayMode;
@property (nonatomic, retain) id <NSObject, NSCopying, NSCoding>  currentUbiquityToken;

-(void) refreshData;

-(BOOL) iCloudCapable;
-(BOOL) iCloudEnabledByUserAndSystem;

// Instance Methods
-(ColorSettingManager*) appSettingColorManager;
-(BasicAppSettingManager*) basicSettingManager;

// ToDo リファクタリング通知機構
-(void) notifyWeekStartWeekdayChenged;
-(void) notifyHolidaySelectionChanged;

-(void) notifyCloudDataChanged;

-(NSLocale*)appLocale;
-(NSCalendar*) appCalendar;
-(NSUInteger) weekStartWeekday;
-(EKEventStore*) appEventStore;

-(EKCalendar*) defaultEKCalendar;

-(AppCalendarDisplayMode) defaultDisplayMode;

-(NSDateFormatter*) dateFormatter_yMMMM;
-(NSDateFormatter*) dateFormatter_fullStyle;
-(NSArray*) weekdaySymbols;
-(NSArray*) shortWeekdaySymbols;


@end
