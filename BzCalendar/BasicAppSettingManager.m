//
//  BasicAppSettingManager.m
//  GSystemT0
//
//  Created by 小林 活水 on 09/11/19.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BasicAppSettingManager.h"
#import <EventKit/EventKit.h>
#import "AppConstants.h"
//#import "AppEventKit.h"

#import "BzCalendar-Swift.h"

@interface BasicAppSettingManager()

@property(nonatomic, retain) NSManagedObjectContext* context;

-(id) initSingleton;

- (void) setUpContents;
@end

@implementation BasicAppSettingManager

@synthesize context;
@synthesize basicAppSetting;

static id singleton = nil;
static NSString* entityName = @"BasicAppSetting";

+(BasicAppSettingManager*) sharedManager {
    if (singleton == nil) {
        singleton = [[BasicAppSettingManager alloc] initSingleton];
    }
    return singleton;
}
- (void) setUpContents {
    
	LOG_METHOD;
	
    [self.context performBlockAndWait:^{
        NSFetchRequest* request = [[NSFetchRequest alloc] init];
        NSEntityDescription* entity = [NSEntityDescription entityForName:entityName
                                                  inManagedObjectContext:self.context];
        
        [request setEntity:entity];
        
        NSError* error = nil;
        NSArray* resultArray = [self.context executeFetchRequest:request error:&error];
        if( resultArray == nil ) {
            // Handle Error here
        }
        
        if( [resultArray count] > 0 ) {
            self.basicAppSetting =  (BasicAppSetting*) [resultArray  objectAtIndex:0];
        } else {
            LOG(@"should not happen");
        }
        
	}];
    
}
-(id) initSingleton {
    self = [super init];
    if ( self ) {
        self.context = [[BzManagedObjectContextManager shared] parentMOC];
		[self setUpContents];
    }
    return self;
}
- (id) init {
    LOG(@"use initSingleton");
    SINGLTON_INIT_NOT_ALLOWED;
    return nil;
}
- (void) updateDefaultCalendarFromEKEventStoreDefault {
    LOG_METHOD;
    EKEventStore* store = [[AppEventKit shared] store];
    EKCalendar* tmpCal = store.defaultCalendarForNewEvents;
    LOG(@"calendar: %@", tmpCal);
    
    float vertion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if( vertion < 5.0 ) {
        [self setDefaultEKCalenarWithTitle:tmpCal.title];
    } else {
        [self setDefaultEKCalenarWithID:tmpCal.calendarIdentifier];
    }
    NSError* error = nil;
    [self saveAllChangesInContext:&error];
    if( error ) {
        
    }    
}

-(NSString*)defaultEKCalendarID {
    LOG_METHOD;
    NSString* rtnVal = nil;
    rtnVal = self.basicAppSetting.defaultCalendarID;
    LOG(@"basic...defaultCalendarID: %@", rtnVal);
    if( rtnVal == nil ) {
        EKEventStore* store = [[AppEventKit shared] store];
        EKCalendar* tmpCal = store.defaultCalendarForNewEvents;
        LOG(@"dafualtCalendar not setting");
        LOG(@"settting defaultCalendar as: %@", tmpCal);
        float vertion = [[[UIDevice currentDevice] systemVersion] floatValue];
        if( vertion < 5.0 ) {
            [self setDefaultEKCalenarWithTitle:tmpCal.title];
            rtnVal = tmpCal.title;
        } else {
            [self setDefaultEKCalenarWithID:tmpCal.calendarIdentifier];
            rtnVal = tmpCal.calendarIdentifier;
        }
        NSError* error = nil;
        [self saveAllChangesInContext:&error];
        if( error ) {
            
        }
    }
    return rtnVal;
    
}
-(void) setDefaultEKCalenarWithID:(NSString*)calendarId {
    self.basicAppSetting.defaultCalendarID = calendarId;
}
-(void) setDefaultEKCalenarWithTitle:(NSString*)calendarTitle {
    self.basicAppSetting.defaultCalendarID = calendarTitle;
}

-(CGFloat) activeTimeFromFloat {
	
	NSNumber* activeTimeFromHour = self.basicAppSetting.activeTimeFromHour;
	NSNumber* activeTimeFromMinute = self.basicAppSetting.activeTimeFromMinute;
	
	CGFloat rtnVal;
	if( (activeTimeFromHour != nil) && (activeTimeFromMinute != nil) ) {
		rtnVal = [activeTimeFromHour intValue] + ([activeTimeFromMinute intValue]/60.0f);
	} else {
		rtnVal = kActiveTimeFromHour + (kActiveTimeFromMinute/60.0f);
	}
	return rtnVal;
}
-(CGFloat) activeTimeToFloat {

	NSNumber* activeTimeToHour = self.basicAppSetting.activeTimeToHour;
	NSNumber* activeTimeToMinute = self.basicAppSetting.activeTimeToMinute;

	CGFloat rtnVal;
	if( (activeTimeToHour != nil) && (activeTimeToMinute != nil) ) {
		rtnVal = [activeTimeToHour intValue] + ([activeTimeToMinute intValue]/60.0f);
	} else {
		rtnVal = kActiveTimeToHour + (kActiveTimeToMinute/60.f);
	}
	return rtnVal;
}
-(NSNumber*) activeTimeFromHour {
	return self.basicAppSetting.activeTimeFromHour;
}
-(NSNumber*) activeTimeFromMinute {
	return self.basicAppSetting.activeTimeFromMinute;
}
-(NSNumber*) activeTimeToHour {
	return self.basicAppSetting.activeTimeToHour;
}
-(NSNumber*) activeTimeToMinute {
	return self.basicAppSetting.activeTimeToMinute;
}
-(void) changeActiveTimeFromHour:(NSNumber*)num {
	LOG(@"num: %@", num);
	self.basicAppSetting.activeTimeFromHour = num;
	LOG(@"app: %@", self.basicAppSetting.activeTimeFromHour);
}
-(void) setActiveTimeFromMinute:(NSNumber*)num {
	basicAppSetting.activeTimeFromMinute = num;
}
-(void) setActiveTimeToHour:(NSNumber*)num {
	basicAppSetting.activeTimeToHour = num;
}
-(void) setActiveTimeToMinute:(NSNumber*)num {
	basicAppSetting.activeTimeToMinute = num;
}

-(NSUInteger) weekStartWeekday {
	NSNumber* num = basicAppSetting.weekStartWeekday;
	
	return [num intValue];
}
- (void) setWeekStartWeekday:(NSUInteger)weekday {
	NSNumber* num = [NSNumber numberWithUnsignedInteger:weekday];
	basicAppSetting.weekStartWeekday = num;
}
-(NSUInteger) defaultDisplayMode {
	NSNumber* num = basicAppSetting.defaultDisplayMode;
	
	return [num intValue];
}
-(void) setDefaultDisplayMode:(NSUInteger)mode {
	NSNumber* num = [NSNumber numberWithUnsignedInteger:mode];
	basicAppSetting.defaultDisplayMode = num;
}

-(BOOL) isRokuyoOn {
    BOOL rtnVal = FALSE;
    
    NSLocale* locale = [NSLocale currentLocale];
    NSString* countryCode = [locale objectForKey:NSLocaleCountryCode];
    NSString* langCode = [locale objectForKey:NSLocaleLanguageCode];
    
    // 国が日本または、使用言語が日本語の時六曜を表示
    if( ([countryCode compare:@"JP"] == NSOrderedSame) ||
       ([langCode compare:@"ja"] == NSOrderedSame) ) {
        NSNumber* num = basicAppSetting.isRokuyoOn;
        rtnVal = [num boolValue];
    }
    return rtnVal;
}

-(void) setRokuyoOn:(BOOL)blVal {
	NSNumber* num = [NSNumber numberWithInt:blVal];
	basicAppSetting.isRokuyoOn = num;
}
-(BOOL)isAutoHolidayDetect {
	NSNumber* num = basicAppSetting.isAutoHolidayDetect;
	return [num boolValue];
}
-(void)setAutoHolidayDetect:(BOOL)blVal {
	NSNumber* num = [NSNumber numberWithInt:blVal];
	basicAppSetting.isAutoHolidayDetect = num;
}


- (BOOL)saveAllChangesInContext:(NSError**)error {
	LOG_METHOD;
    __block BOOL result = YES;
    __block NSError* saveError = nil;
    
    [self.context performBlockAndWait:^{
        result = [self.context save:&saveError];
    }];
	
    if( saveError ) {
        (*error) = saveError;
    }
    
	return result;
}

- (void) notifyChange {
	NSNotification* notify;
	
	notify = [NSNotification notificationWithName:BasicAppSettingChangeNotification object:nil userInfo:nil];
		
	NSNotificationCenter* nCenter = [NSNotificationCenter defaultCenter];
	[nCenter postNotification:notify];
	
    [[NSCalendar currentCalendar] setFirstWeekday:[self weekStartWeekday]];

}

-(void) dealloc {
	//[super dealloc];
}

-(NSString*) customHolidayID {
    NSString* rtnVal = nil;
    rtnVal = self.basicAppSetting.customHolidayCalendarID;
    return rtnVal;
}
-(void) setCustomHolidayID:(NSString*)calendarId {

    self.basicAppSetting.customHolidayCalendarID = calendarId;
    
}

@end
