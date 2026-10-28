//
//  HolidaySelectionManager.m
//  GSystemT0
//
//  Created by 小林 活水 on 11/03/01.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "HolidaySelectionManager.h"

#import "BzCalendar-Swift.h"

@interface HolidaySelectionManager()

@property (nonatomic, readwrite) NSString* entityName;
@property(nonatomic, retain) NSManagedObjectContext* context;

@property (nonatomic, readwrite) NSMutableArray* selectedHolidayCalendarList;
@property(nonatomic, retain) NSMutableArray* selectedHolidayIdentifierList;

-(id) initSingleton;

@end

@implementation HolidaySelectionManager

@synthesize selectedHolidayCalendarList;
@synthesize context;
@synthesize selectedHolidayIdentifierList;

static HolidaySelectionManager* singleton = nil;

- (NSManagedObjectContext*) context {
    return [[BzManagedObjectContextManager shared] parentMOC];
}
- (NSEntityDescription*) entityDescription {
    NSEntityDescription* entity = [NSEntityDescription
                                   entityForName:self.entityName
                                   inManagedObjectContext:self.context];
    return entity;
}

+(HolidaySelectionManager*)sharedManager {
    if( singleton == nil ) {
        singleton = [[HolidaySelectionManager alloc] initSingleton];
    }
    return singleton;
}

- (id) initSingleton {
    self = [super init];
	if( self != nil ) {
        self.entityName = @"HolidaySelection";
		self.context = [self context];
        self.selectedHolidayIdentifierList = [NSMutableArray arrayWithCapacity:20];
	}
	return self;
}
- (id) init {
    LOG(@"use initSingleton");
    SINGLTON_INIT_NOT_ALLOWED;
}

-(NSArray*) selectedHolidayIdentifiers {
	NSFetchRequest* request;
	NSEntityDescription* entity;
	NSError* error = nil;
    
    entity = [self entityDescription];
	request = [[NSFetchRequest alloc] init];
	[request setEntity:entity]; 
    
	NSArray* arr = [context executeFetchRequest:request error:&error];
	
    if ([arr count] > 0) {
        self.selectedHolidayIdentifierList = [NSMutableArray arrayWithCapacity:[arr count]];
    
        for(HolidaySelection* elm in arr) {
            NSString* newItem = elm.identifier;
            [self.selectedHolidayIdentifierList addObject:newItem];
        }
    } else {
        self.selectedHolidayIdentifierList = nil;
    }
    return self.selectedHolidayIdentifierList;
}
-(NSArray*) selectedHolidayCalendars {
	return selectedHolidayCalendarList;
}

- (BOOL)saveSelectedHolidays:(NSArray*)identifierList error:(NSError**)error {
    // ToDo: delete ALL

    NSEntityDescription* entity;
    entity = [self entityDescription];
    // Delete All
    NSFetchRequest* allRequest = [[NSFetchRequest alloc] init];
    [allRequest setEntity:entity];
	NSArray* allEntities = [context executeFetchRequest:allRequest error:error];
   
    
    if( *error ) {
        [context reset];
        return NO;
    }
    
    for( HolidaySelection* elm in allEntities ) {
        [context deleteObject:elm];
    }

    // Add all identifiers in identifierList
    for(NSString* newItem in identifierList) {
        HolidaySelection* holiday = (HolidaySelection*) [NSEntityDescription 
                                                         insertNewObjectForEntityForName:self.entityName
                                                         inManagedObjectContext:context];
        
        holiday.identifier = newItem;
    }
    [context save:error];
    
    if( *error ) {
        [context reset];
        return NO;
    }
    
    return YES;
}

@end
