//
//  AppSettingCalendarManager.m
//  GSystemT0
//
//  Created by 小林 活水 on 11/01/02.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "CalendarSettingManager.h"

#import "BzCalendar-Swift.h"

@interface CalendarSettingManager()

@property (nonatomic, retain) NSManagedObjectContext* context;
@property (nonatomic, retain) NSArray* selectedCalendars;
@property (nonatomic, retain) NSMutableDictionary* colorDict;


-(id) initSingleton;

-(void) loadSelectedEKCalendars;
- (void) addCalender:(EKCalendar*)calendar selected:(BOOL)bl;

@end

@implementation CalendarSettingManager

@synthesize context;
@synthesize selectedCalendars;
@synthesize colorDict;

static id singleton = nil;
static NSString* entityName = @"CalendarSetting";

#pragma mark - インスタンス

+(CalendarSettingManager*)sharedManager {
    if( singleton == nil ) {
        singleton = [[CalendarSettingManager alloc] initSingleton];
    }
    return singleton;
}

- (id) initSingleton {
    self = [super init];
    if( self ) {
        self.context = [[BzManagedObjectContextManager shared] parentMOC];
        allCalendars = [[NSMutableArray alloc] initWithCapacity:10];
        selectedEKCalendars = [[NSMutableArray alloc] initWithCapacity:10];
        [self loadSelectedEKCalendars];
        
        self.colorDict = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return self;
}

#pragma mark - コアデータモデル取得
// コアデータのモデル配列の取得
-(NSArray*) allCoreData_CalendarSetting {
    LOG_METHOD;
    
    BOOL iCloudCapable = FALSE;
    if( [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil] != nil ) {
        iCloudCapable = TRUE;
    }
    
    [self syncCalendarList];
    
    NSFetchRequest* request;
    NSEntityDescription* entity;
    NSError* error = nil;
    
    request = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSArray* array = [context executeFetchRequest:request error:&error];
    
    if( allCalendars != nil ) {
        [allCalendars removeAllObjects];
    }
    for( CalendarSetting* cal in array ) {
        LOG(@"identifier; %@, title: %@", cal.identifier, cal.title);
        [allCalendars addObject:cal];
    }
    if( iCloudCapable == YES ) {
        EKEventStore* store = [[AppEventKit shared] store];
        CalendarSetting* toBeDeteledCal = nil;
        for( NSInteger idx = 0; idx < [allCalendars count]; idx++ ) {
            CalendarSetting* calSetting = [allCalendars objectAtIndex:idx];
            EKCalendar* foundCal = [store calendarWithIdentifier:calSetting.identifier];
            if( foundCal.source.sourceType == EKSourceTypeLocal ) {
                toBeDeteledCal = calSetting;
            }
        }
        if( toBeDeteledCal ) {
            [allCalendars removeObject:toBeDeteledCal];
        }
    }
    
    NSError* saveError = nil;
    [self.context save:&saveError];
    
    if( saveError != nil ) {
        LOG_METHOD;
        LOG(@"error domain:   %@", [saveError domain] );
        // cancel
    }
    
    return allCalendars;
}

- (BOOL)saveAllChangesInContext:(NSError**)error {
    BOOL rtnVal = [self.context save:error];
    [self loadSelectedEKCalendars];
    
	return rtnVal;
}

#pragma mark - EKCalendar

-(void) loadSelectedEKCalendars {
    LOG_METHOD;
    EKEventStore* store = [[AppEventKit shared] store];
    [selectedEKCalendars removeAllObjects];
    
    NSArray* selectecCales = [self selectedCalendars];
    
    NSArray* allEKCalendars = [store calendarsForEntityType:EKEntityTypeEvent];
    
    for(EKCalendar* cal in allEKCalendars) {
        for(CalendarSetting* appCal in selectecCales) {
            // 過去に選択しているカレンダーが、現時点の選択可能なEKCalendarの中に存在するかチェックする
            // つまり既に選択不可能なカレンダーがゴミデータとして選択されていないか確認する
            if( [cal.calendarIdentifier compare:appCal.identifier] == NSOrderedSame ) {
                BOOL isNewItem = YES;
                for(EKCalendar* tmpCal in selectedEKCalendars) {
                    if( [tmpCal.calendarIdentifier compare:cal.calendarIdentifier] == NSOrderedSame ) {
                        isNewItem = NO;
                        break;
                    }
                    
                }
                if( isNewItem == YES ) {
                    [selectedEKCalendars addObject:cal];
                }
                continue;
            }
        }
    }
    
}

-(NSArray<EKCalendar*>*) selectedEKCalendars {
    // ToDo: キャッシュを返す　（設定を変更した側の通知で再設定しておく
    LOG_METHOD;
    [self performSelectorOnMainThread:@selector(loadSelectedEKCalendars) withObject:nil waitUntilDone:YES];
    //[self loadSelectedEKCalendars];
    
    LOG(@"selectedEKCalendars: %@", selectedEKCalendars);
    
//    let store : EKEventStore = AppEventKit.shared().store()
//    let arr = store.calendars(for: .event)
//    
//    guard let calMgr = CalendarSettingManager.shared() else {
//        fatalError()
//    }
//    var mutSet : Set<EKCalendar> = Set() //NSMutableSet(capacity:10)
//    
//    if let appSetting_Calendar_List = calMgr.allCoreData_CalendarSetting() {
//        for cal in appSetting_Calendar_List {
//            if let calSetting = cal as? CalendarSetting {
//                if calSetting.selected.boolValue == true  {
//                    if let ekCal = calMgr.getEKCalendar(withIdentifier: calSetting.identifier) {
//                        if arr.contains(ekCal) {
//                            mutSet.insert(ekCal)
//                            
//                        }
//                    }
//                }
//            }
//        }
//    }
//    let selectableCalendars : Array<EKCalendar> = Array(mutSet)

    return selectedEKCalendars;
}

-(void)selectEKCalendars:(NSArray<EKCalendar*>*)calendars {
    NSArray* appSetting_Calendar_List  = [self allCoreData_CalendarSetting];
    
    NSMutableSet* mutSet = [[NSMutableSet alloc] initWithCapacity:10];
    
    for( EKCalendar* ekCal in calendars ) {
        [mutSet addObject:ekCal];
    }
    for( CalendarSetting* cal in appSetting_Calendar_List ) {
        EKCalendar* ekCal = [self getEKCalendarWithIdentifier:cal.identifier];
        
        if( [mutSet containsObject:ekCal] ) {
            LOG(@"selected: %@", ekCal);
            cal.selected = [NSNumber numberWithBool:YES];
        } else {
            cal.selected = [NSNumber numberWithBool:NO];
        }
    }
    NSError* error = nil;
    [self saveAllChangesInContext:&error];
    if( error ) {
        LOG(@"error: %@", error);
    }
    
    [self loadSelectedEKCalendars];

}
-(EKCalendar*) getEKCalendarWithIdentifier:(NSString *)ekIdentifier {
    LOG_METHOD;
    EKCalendar* rtnVal = nil;
    
    EKEventStore* store = [[AppEventKit shared] store];
    NSArray* allEKCalendars = [store calendarsForEntityType:EKEntityTypeEvent];
    for( EKCalendar* cal in allEKCalendars ) {
        if( [cal.calendarIdentifier compare:ekIdentifier] == NSOrderedSame ) {
            rtnVal = cal;
        }
    }
    
    return rtnVal;
}

#pragma mark - プライベート

-(NSArray*) selectedCalendars {
    //@property (nonatomic, retain) NSArray* selectedCalendars;
    
    NSFetchRequest* request;
    NSEntityDescription* entity;
    NSPredicate* predicate;
    NSError* error = nil;
    
    request = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [request setEntity:entity];
    
    predicate = [NSPredicate predicateWithFormat:@"selected == YES"];
    
    [request setPredicate:predicate];
    
    
    NSArray* selectedCalendars = [context executeFetchRequest:request error:&error];
    for(CalendarSetting* cal in selectedCalendars ) {
        NSLog(@"%@, selected? %@", cal.title, cal.selected);
        
    }
    
    // upto here
    
    if( selectedCalendars.count == 0 ) {
        
        EKEventStore* store = [[AppEventKit shared] store];
        
        [store defaultCalendarForNewEvents];
        
        NSArray* ekAllCalendars = [store calendarsForEntityType:EKEntityTypeEvent];
        
        for( EKCalendar* cal in ekAllCalendars ) {
            BOOL isSelected = YES;
            if( [cal.title compare:@"Birthdays"] == NSOrderedSame ) {
                isSelected = NO;
            }
            [self addCalender:cal selected:isSelected];
        }
        
        request = [[NSFetchRequest alloc] init];
        entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
        [request setEntity:entity];
        
        predicate = [NSPredicate predicateWithFormat:@"selected == YES"];
        //,[NSNumber numberWithBool:YES]];
        [request setPredicate:predicate];
        
        if( selectedCalendars != nil )
            
            selectedCalendars = [[context executeFetchRequest:request error:&error] mutableCopy];
        
    }
    
    return selectedCalendars;
}

-(void) syncCalendarList{
	EKEventStore* store = [[AppEventKit shared] store];
	
    NSArray* allEKCalendars = [store calendarsForEntityType:EKEntityTypeEvent];
 
    for( EKCalendar* cal in allEKCalendars ) {
        NSLog(@"calendar.title: %@, source.title: %@", cal.title, cal.source.title );
    }
    
	NSFetchRequest* request;
	NSEntityDescription* entity;
	NSError* error = nil;
	
	request = [[NSFetchRequest alloc] init];
	entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
	[request setEntity:entity]; 
	
	NSMutableArray* tmpCalenders = [[context executeFetchRequest:request error:&error] mutableCopy];
		
    for( EKCalendar* ekCal in allEKCalendars ) {
        BOOL found = NO;
        for( CalendarSetting* cal in tmpCalenders ) {
            if( [cal.identifier compare:ekCal.calendarIdentifier] == NSOrderedSame ) {
                found = YES;
                [tmpCalenders removeObject:cal];
                break;
            }
        }
        if (found == NO) {
            [self addCalender:ekCal selected:YES];
        }
    }

    // for those remaining items are trash, delete!
	for( CalendarSetting* cal in tmpCalenders ) {
		[context deleteObject:cal];
        NSError* error = nil;
        [context save:&error];
        if( error ) {
            // ignor...
        }
	}
	
}

-(void) addCalender:(EKCalendar *)calendar selected:(BOOL)bl {
	
	CalendarSetting* setting_calendar = (CalendarSetting*) [NSEntityDescription
															insertNewObjectForEntityForName:entityName
															inManagedObjectContext:self.context];


    setting_calendar.identifier = calendar.calendarIdentifier;

	setting_calendar.title = calendar.title;
	setting_calendar.selected = [NSNumber numberWithBool:bl];
	
	CGColorRef cgColor = calendar.CGColor;
	const CGFloat *comps;
	NSUInteger red = 1.0f;
	NSUInteger green = 1.0f;
	NSUInteger blue = 1.0f;
	
	switch ( CGColorSpaceGetModel( CGColorGetColorSpace(cgColor) )) {
		case kCGColorSpaceModelMonochrome:		//　whiteColorやblackColorはこちらになる
			comps = CGColorGetComponents(cgColor);
			red = comps[0] * 255;
			green = red;
			blue = red;
			/*
			if( CGColorGetNumberOfComponents(cgColor) > 1 ) {
				alpha = comps[1] * 255;
			}
			 */
			break;
		case kCGColorSpaceModelRGB:
			comps = CGColorGetComponents(cgColor);
			red = comps[0] * 255;
			green = comps[1] * 255;
			blue = comps[2] * 255;
			/*
			if( CGColorGetNumberOfComponents(cgColor) > 3 ) {
				alpha = comps[3] * 255;
			}
			 */
			break;
		default:
			break;
	}
	NSString* colorString = [NSString stringWithFormat:@"#%02x%02x%02x", (int)red, (int)green, (int)blue];
	setting_calendar.color = colorString;
	
	NSError* saveError = nil;
	//[self saveAllChangesInContext:&saveError];
	[self.context save:&saveError];

	if( saveError != nil ) {
		LOG(@"error domain:   %@", [saveError domain] );
		// cancel
	}
}

//-(NSArray*) allEKCalendars {
//
//    EKEventStore* store = [[AppEventKit sharedEventKit] store];
//
//    NSArray* tmpCalendars = [store calendarsForEntityType:EKEntityTypeEvent];
//
//    return tmpCalendars;
//}

//- (UIColor*) appCalendarColor:(EKCalendar*) cal {
//
//    UIColor* rtnColor;
//    rtnColor = [self.colorDict objectForKey:cal.calendarIdentifier];
//    if( rtnColor == nil ) {
//        rtnColor = [UIColor colorWithCGColor: cal.CGColor];
//        [self.colorDict setObject:rtnColor forKey:cal.calendarIdentifier];
//    }
//    NSFetchRequest* request;
//    NSEntityDescription* entity;
//    NSPredicate* predicate;
//    NSError* error = nil;
//
//    request = [[NSFetchRequest alloc] init];
//    entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
//    [request setEntity:entity];
//
//    predicate = [NSPredicate predicateWithFormat:@"identifier == %@", cal.title];
//
//    [request setPredicate:predicate];
//
//    NSArray* rtnArr = [context executeFetchRequest:request error:&error];
//
//
//    if( rtnArr && ([rtnArr count] > 0) ) {
//        CalendarSetting* setting_cal = [rtnArr objectAtIndex:0];
//        if( setting_cal.color ) {
//            rtnColor = [[ColorUtil sharedManager] UIColorFromColorCode: setting_cal.color];
//        }
//    }
//
//    return rtnColor;
//
//}
//
//-(EKCalendar*) getEKCalendarWithTitle:(NSString *)ekTitle {
//    EKEventStore* store = [[AppEventKit sharedEventKit] store];
//    NSArray* calendars = [store calendarsForEntityType:EKEntityTypeEvent];
//    for( EKCalendar* cal in calendars ) {
//        if( [cal.title compare:ekTitle] == NSOrderedSame )
//            return cal;
//    }
//    return nil;
//}

//- (void) notifyChange {
//    NSNotification* notify;
//
//    notify = [NSNotification notificationWithName:AppSettingCalendarChangeNotification object:nil userInfo:nil];
//
//    NSNotificationCenter* nCenter = [NSNotificationCenter defaultCenter];
//    [nCenter postNotification:notify];
//
//}

@end
