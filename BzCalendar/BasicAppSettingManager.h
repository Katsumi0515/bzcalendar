//
//  BasicAppSettingManager.h
//  GSystemT0
//
//  Created by 小林 活水 on 09/11/19.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BasicAppSettingChangeNotification	@"BasicAppSettingChangeNotification"

@class BasicAppSetting;

@interface BasicAppSettingManager : NSObject {
	
	BasicAppSetting* basicAppSetting;
	
	NSManagedObjectContext* context;

}
@property (nonatomic, retain) BasicAppSetting* basicAppSetting;

+(BasicAppSettingManager*) sharedManager;

- (void) updateDefaultCalendarFromEKEventStoreDefault;

-(CGFloat) activeTimeFromFloat;
-(CGFloat) activeTimeToFloat;
-(NSNumber*) activeTimeFromHour;
-(NSNumber*) activeTimeFromMinute;
-(NSNumber*) activeTimeToHour;
-(NSNumber*) activeTimeToMinute;

-(void) changeActiveTimeFromHour:(NSNumber*)num;
-(void) setActiveTimeFromMinute:(NSNumber*)num;
-(void) setActiveTimeToHour:(NSNumber*)num;
-(void) setActiveTimeToMinute:(NSNumber*)num;

-(NSUInteger) weekStartWeekday;
-(void) setWeekStartWeekday:(NSUInteger)weekday;
-(NSUInteger) defaultDisplayMode;
-(void) setDefaultDisplayMode:(NSUInteger)mode;

-(BOOL) isRokuyoOn;
-(void) setRokuyoOn:(BOOL)blVal;

-(BOOL) isAutoHolidayDetect;
-(void) setAutoHolidayDetect:(BOOL)blVal;

- (BOOL)saveAllChangesInContext:(NSError**)error;
- (void) notifyChange;

-(NSString*)defaultEKCalendarID;
-(void) setDefaultEKCalenarWithID:(NSString*)calendarId;
-(void) setDefaultEKCalenarWithTitle:(NSString*)calendarTitle;

-(NSString*) customHolidayID;
-(void) setCustomHolidayID:(NSString*)calendarId;

@end
