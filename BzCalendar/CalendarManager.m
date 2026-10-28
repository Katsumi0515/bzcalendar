//
//  CalendarManager.m
//  BzCalendar
//
//  Created by 小林 活水 on 09/09/21.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CalendarManager.h"
//#import "AppEventKit.h"
#import "MonthViewSettingManager.h"
#import "WeekViewSettingManager.h"
//#import "BzCloudExtensionManager.h"
//#import "CalendarSettingManager.h"

#import "BzAppDelegate.h"
#import "BzCalendar-Swift.h"

@interface  CalendarManager() 

@property (nonatomic) BOOL _iCloudCapable;

- (id) initSingleton;

// Core Date Related Methods
//- (NSManagedObjectContext*) managedObjectContext;
//- (NSManagedObjectModel*) managedObjectModel;
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSString *)applicationDocumentsDirectory;

// ノーティフィケーションに登録するメソッド

@property (nonatomic, retain) NSDate* _selectedDate;
@property (nonatomic, retain) NSCalendar* appCalendar;
@property (nonatomic, retain) BasicAppSettingManager* _basicSettingManager;
@property (nonatomic, retain) ColorSettingManager* _appSettingColorManager;
@property (nonatomic, retain) NSDateFormatter* _dateFormatter_yMMMM;
@property (nonatomic, retain) NSDateFormatter* _dateFormatter_fullStyle;

- (void) _setupData;

@end

@implementation CalendarManager

@synthesize currentUbiquityToken;
@synthesize selectedYear;
@synthesize appCalendar;
@synthesize _selectedDate;
@synthesize _basicSettingManager;
@synthesize _appSettingColorManager;
@synthesize _dateFormatter_yMMMM;
@synthesize _dateFormatter_fullStyle;
@synthesize _iCloudCapable;

static CalendarManager* singleton = nil;

#pragma mark - インスタンス

+(CalendarManager*) sharedManager {
	if( singleton == nil) {
		singleton = [[CalendarManager alloc] initSingleton];
    } else {

    }
	return singleton;
}

-(id) initSingleton {
    
    if((self = [super init]) != nil) {
        [self _setupData];
        if ([self iCloudEnabledByUserAndSystem] == YES) {
            
        }
        self.currentUbiquityToken = [[NSFileManager defaultManager] ubiquityIdentityToken];
    }
    
    return self;
}

#pragma mark -

-(void) refreshData {
    [self _setupData];
}

- (void) _setupData {
    // ToDo ロケールの設定
    self.appCalendar = [NSCalendar currentCalendar];
    
    if( eventStore == nil ) {
        eventStore = [[AppEventKit shared] store];
    } else {
        [eventStore reset];
    }
    
    self._basicSettingManager = [BasicAppSettingManager sharedManager];
    // ToDo: (ToDoではないが）
    // selectedDateの設定より後にappCalendarの設定をしていたため、
    //日付から年月日等を設定する処理がうまくいっていなかった
    if( [self selectedDate] == nil ) {
        [self setSelectedDate:[NSDate date]];
    }
    
    
    commonDateFormatter = [[NSDateFormatter alloc] init];
    
    NSString *dateComponents = @"yMMMM";
    NSString* dateFormat = [NSDateFormatter dateFormatFromTemplate:dateComponents 
                                                           options:0 
                                                            locale:[self appLocale]];
    NSDateFormatter* tmpFormatter = [[NSDateFormatter alloc] init];
    tmpFormatter.calendar = self.appCalendar;
    tmpFormatter.locale = [self appLocale];
    [tmpFormatter setDateFormat:dateFormat];
    
    self._dateFormatter_yMMMM = tmpFormatter;
   
    
    NSDateFormatter* tmpFormatterFull = [[NSDateFormatter alloc] init];
    tmpFormatterFull.calendar = self.appCalendar;
    tmpFormatterFull.locale = [self appLocale];
    [tmpFormatterFull setDateStyle:NSDateFormatterFullStyle];
    
    self._dateFormatter_fullStyle = tmpFormatterFull;
   
    
    
    

    self._appSettingColorManager = [ColorSettingManager shared];
 
    
    
}
- (BOOL) iCloudCapable {

    self._iCloudCapable = NO;
	NSURL* rtnVal = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
	if( rtnVal ) {
		self._iCloudCapable = YES;
	}

    return self._iCloudCapable;
}
- (BOOL) iCloudEnabledByUserAndSystem {
    BOOL rtnVal = FALSE;
    if( [self iCloudCapable] ) {
        if( [[BzCloudExtensionManager shared] iCloudEnabled] && 
           !([[BzSystemActivityManager shared] isTring_iCloud]) ) {
            rtnVal = TRUE;
        }
    }
    return rtnVal;
}

-(BasicAppSettingManager*) basicSettingManager {
    return self._basicSettingManager;
}

-(id) init {
	return nil;
}

- (void)dealloc {
    /*
	if( self._selectedDate ) [self._selectedDate release];
	if( self._basicSettingManager ) [self._basicSettingManager release];	
    if( self._appSettingCalendarManager ) [self._appSettingCalendarManager release];
	if( self._appSettingColorManager ) [self._appSettingColorManager release];
     */
   
}

-(NSDate*) selectedDate {
    return self._selectedDate;
}
-(void) setSelectedDate:(NSDate *)date {
    if( date == nil ) {
        return;
    }
    NSUInteger unitFlag = NSCalendarUnitYear | 
    NSCalendarUnitMonth |
    NSCalendarUnitDay | 
    NSCalendarUnitWeekday;
    NSDateComponents* comps = [appCalendar components:unitFlag fromDate:date];
	selectedYear = [comps year];
	selectedMonth = [comps month];
    day = [comps day];
	weekday = [comps weekday];	// 1 sunday, 2 monday, ...
    
    self._selectedDate = [appCalendar dateFromComponents:comps];
    
}

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

-(ColorSettingManager*) appSettingColorManager {
	// Lazy Loading
	if( self._appSettingColorManager == nil ) {
		self._appSettingColorManager = [ColorSettingManager shared];
	}
	return self._appSettingColorManager;
}

-(NSLocale*)appLocale {
    return [NSLocale currentLocale];
}
-(NSCalendar*) appCalendar {
	[appCalendar setFirstWeekday:[self weekStartWeekday]];
	return appCalendar;
}
- (NSUInteger) weekStartWeekday {
	// sunday = 1, monday = 2 ...
	NSUInteger weekStartWeekday = self._basicSettingManager.weekStartWeekday;
	return weekStartWeekday;
}

-(EKEventStore*) appEventStore {
	return eventStore;
}

-(AppCalendarDisplayMode) defaultDisplayMode {
    AppCalendarDisplayMode mode = [self._basicSettingManager defaultDisplayMode];
    return mode;
}

// defaultEKCalendar
// このメソッドでは純粋にユーザ設定されているカレンダーを返す。設定されていない場合はnilを返す
-(EKCalendar*) defaultEKCalendar {
    
    EKCalendar* rtnCal = nil;
    NSString* calID = [self._basicSettingManager defaultEKCalendarID];
    
    if( calID ) {
        // getEKCalendarWithIdentifierがiOS5以前の場合引数（この場合calID）をtitleと読み替える対応をとっている
        rtnCal = [[BzCalendarSettingManager sharedManager] getEKCalendarWithIdentifierWithEkIdentifier:calID];
    }
    if( rtnCal == nil ) {
        // Case: user uses this apps with iOS 4.3 and update to iOS 5.0
        [self._basicSettingManager updateDefaultCalendarFromEKEventStoreDefault];
        rtnCal = [[[AppEventKit shared] store] defaultCalendarForNewEvents];
        
    }
    
    return rtnCal;
}

-(NSUInteger)selectedMonth {
    return selectedMonth;
}

-(void) notifyWeekStartWeekdayChenged {
	[appCalendar setFirstWeekday:[self weekStartWeekday]];
	/*
     // インスタンス化されていない画面は落ちてしまう
     [[MonthViewScrollController sharedController] refresh];
     [[WeekViewScrollController sharedController] refresh];
     [[DayViewScrollController sharedController] refresh];
     */
}
-(void) notifyHolidaySelectionChanged {
    [[WorldCalendarManager shared] update];
	/*
     // インスタンス化されていない画面は落ちてしまう
     [[MonthViewScrollController sharedController] refresh];
     [[WeekViewScrollController sharedController] refresh];
     [[DayViewScrollController sharedController] refresh];
     */
}

-(void) notifyCloudDataChanged {
    dispatch_async(dispatch_get_main_queue(), ^{
        BzAppDelegate* appDelegate = (BzAppDelegate*)[[UIApplication sharedApplication] delegate];;
        [[appDelegate topViewControllerDelegate] refreshCurrentEventView];

    });
        
}


#pragma mark -

- (NSDateFormatter*) dateFormatter_yMMMM {
    return self._dateFormatter_yMMMM;
}
- (NSDateFormatter*) dateFormatter_fullStyle {
    return self._dateFormatter_fullStyle;
}
- (NSArray*) weekdaySymbols {
    commonDateFormatter.locale = [self appLocale];
    return commonDateFormatter.weekdaySymbols;
}

- (NSArray*) shortWeekdaySymbols {
    commonDateFormatter.locale = [self appLocale];
    return commonDateFormatter.shortWeekdaySymbols;
}

@end
