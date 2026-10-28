//
//  BzEventTamplateManager.m
//  BzCalendar
//
//  Created by 小林 活水 on 12/06/09.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import "BzEventTamplateManager.h"
#import "CalendarManager.h"
//#import "CDEventTemplate.h"

#import "BzCalendar-Swift.h"

@interface BzEventTamplateManager() 

@property (atomic) BOOL cacheInProcess;

- (void) _setCDEventTemplate:(CDEventTemplate*) cdTemplate fromTemplate:(AppEventTemplate*)template;

@end

@implementation BzEventTamplateManager

@synthesize _privateMoc;
@synthesize _extensionDict;

+(BzEventTamplateManager*)sharedManager {
    
    static BzEventTamplateManager* singleton = nil;
    
    if( singleton == nil ) {
        singleton = [[BzEventTamplateManager alloc] initSingleton];
        
    }
    return singleton;
}

- (id) initSingleton {
    LOG_METHOD;
    self = [super init];
    if( self != nil ) {
        self.cacheInProcess = FALSE;
        self._extensionDict = [NSMutableDictionary dictionaryWithCapacity:100];
        self._privateMoc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeAcvive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        
        
    }
    return self;
}

//- (id) initSingleton {
//    LOG_METHOD;
//    self = [super init];
//    if( self != nil ) {
//        [self _setupCloudManagedObjectContextManager];
//    }
//    return self;
//}

- (id) init {
    LOG(@"use initSingleton caz this is singleton class");
    return nil;
}

#pragma mark -

// 親のコンテクストに関連した子のManagedObjectContextをセットする
-(void)setPrivateContext:(NSManagedObjectContext *)privateContext {
    
    self._privateMoc = privateContext;

    [self clearCache:^(NSError *error) {
        
    }];
    
}


#pragma mark -
- (void)dealloc {
    if( self._privateMoc ) self._privateMoc = nil;
    if( self._extensionDict ) self._extensionDict = nil;
    
}

#pragma mark -
- (void)clearCache:(void (^)(NSError* error))completionHandler {
    LOG_METHOD;
    
    self.cacheInProcess = TRUE;
    
    [self._privateMoc performBlock:^{
        [self._extensionDict removeAllObjects];
        
        NSFetchRequest* request;
        NSEntityDescription* entity;
        NSError* error = nil;
        
        request = [[NSFetchRequest alloc] init];
        entity = [NSEntityDescription entityForName:@"EventTemplate" inManagedObjectContext:self._privateMoc];
        [request setEntity:entity];
        
        NSAsynchronousFetchRequest *asynchronousFetchRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:request completionBlock:^(NSAsynchronousFetchResult *result) {
            
            NSArray* array = result.finalResult;
            
            LOG(@"eventTemplate count: %d", [array count]);
            
            if( error ) {
                self.cacheInProcess = FALSE;
                LOG_METHOD;
                LOG(@"error: %@",error);
                completionHandler(error);
                return;
            }
            
            for( CDEventTemplate* template in array ) {
                // NSString* templateGroup = template.templateGroupName;
                NSString* templateName = template.templateName;
                
                if( templateName ) {
                    AppEventTemplate* tmp = [[AppEventTemplate alloc] initWithCdTemplate:template];
                    
                    LOG(@"got Template: %@",tmp.templateName);
                    
                    LOG(@"recurrenceRules: %@",tmp.recurrenceRules);
                    
                    [self._extensionDict setObject:tmp forKey:templateName];
                    
                } else {
                    LOG(@"templateName is nil");
                }
            }
            
            self.cacheInProcess = FALSE;
            completionHandler(nil);
            
        }];
        NSError* asynchronousFetchRequestError = nil;
        [self._privateMoc executeRequest:asynchronousFetchRequest error:&asynchronousFetchRequestError];
        
    }];

}

- (BOOL)saveAllChangesInContext:(NSError**)error {
    LOG_METHOD;
    __block BOOL rtnVal = NO;
    //NSError* error = nil;
    rtnVal = [self._privateMoc save:error];
    if( error ) {
        LOG(@"error: %@", *error);
        [self clearCache:^(NSError *error) {
            
        }];

    } else {
        [self._privateMoc.parentContext performBlock:^{
            NSError* error = nil;
            rtnVal = [self._privateMoc.parentContext save:&error];
            if( error ) {
                LOG(@"error: %@", error);
            }
            [self clearCache:^(NSError *error) {
                
            }];

        }];
    }
    
    return rtnVal;
}

#pragma mark -
-(NSArray*)getEventTemplatesOfDefaultGroup {
    
    return [[NSArray alloc] initWithArray:[self._extensionDict allValues]] ;
    
}

-(void) deleteTemplate:(AppEventTemplate *)eventTemplate {
    if( eventTemplate.cdEventTemplate ) {
        
        [self._privateMoc performBlock:^{
            [self._privateMoc deleteObject:eventTemplate.cdEventTemplate];
            NSError* error = nil;
            [self._privateMoc save:&error];
            if( error ) {
                [self clearCache:^(NSError *error) {
                    
                }];

            } else {
                [self._privateMoc.parentContext performBlock:^{
                    NSError* error = nil;
                    [self._privateMoc.parentContext save:&error];
                    if( error ) {
                        LOG(@"error: %@",error);
                    }
                    [self clearCache:^(NSError *error) {
                        
                    }];

                }];
            }
        }];
    }
}

-(void) updateTemplate:(AppEventTemplate*) eventTemplate completionHandler: (void (^)(NSError* error))completionHandler {
    
    [self._privateMoc performBlock:^{
        
        CDEventTemplate* cdTemplate = eventTemplate.cdEventTemplate;
        if( cdTemplate == nil ) {
            
            return;
        }
        [self _setCDEventTemplate:cdTemplate fromTemplate:eventTemplate];
        
        NSError* error = nil;
        [self._privateMoc save:&error];
        if( error ) {
            LOG(@"error: %@",error);
            [self clearCache:^(NSError *error) {
                completionHandler(error);
            }];

        } else {
            [self._privateMoc.parentContext performBlock:^{
                NSError* error = nil;
                [self._privateMoc.parentContext save:&error];
                if( error ) {
                    LOG(@"error: %@",error);
                }
                [self clearCache:^(NSError *error) {
                    completionHandler(error);
                }];

            }];
        }
    }];
}

- (void) _setCDEventTemplate:(CDEventTemplate*) cdTemplate fromTemplate:(AppEventTemplate*)template {
    LOG_METHOD;
    LOG(@"title: %@", template.title);
    LOG(@"color: %@", template.customColor);
    
    cdTemplate.templateGroupName = EMPTY_STRING;
    cdTemplate.templateName = template.templateName;
    cdTemplate.title = template.title;
    cdTemplate.startTimeCompsData = [NSKeyedArchiver archivedDataWithRootObject:template.startTimeComps];
    cdTemplate.allDay = [NSNumber numberWithBool:template.allDay];
    if( template.allDay == FALSE) {
        cdTemplate.eventLengthCompsData  = [NSKeyedArchiver archivedDataWithRootObject:template.eventLengthComps];
    } else {
        cdTemplate.eventLengthCompsData = nil;
    }
    cdTemplate.location = template.location;
    cdTemplate.recurrenceRulesData = [NSKeyedArchiver archivedDataWithRootObject:template.recurrenceRules];
    cdTemplate.calendarIdentifier = template.calendar.calendarIdentifier;
    cdTemplate.alarmsData = [NSKeyedArchiver archivedDataWithRootObject:template.alarms];
    if( template.customColor ) {
        cdTemplate.bgColorCode = [[ColorUtil shared] colorCodeWithColor:template.customColor];
    }
    if( template.customTextColor ) {
        cdTemplate.textColorCode = [[ColorUtil shared] colorCodeWithColor:template.customTextColor];
    }
}
-(void) addNewTemplate:(AppEventTemplate*) template completionHandler: (void (^)(NSError* error))completionHandler {
    LOG_METHOD;
    if( template.cdEventTemplate ) {
        [self updateTemplate:template completionHandler:completionHandler];
        return;
    }    
    [self._privateMoc performBlock:^{

        CDEventTemplate* cdTemplate = (CDEventTemplate*) [NSEntityDescription
                                                          insertNewObjectForEntityForName:@"EventTemplate"
                                                          inManagedObjectContext:self._privateMoc];
        [self _setCDEventTemplate:cdTemplate fromTemplate:template];

        
        NSError* error = nil;
        [self._privateMoc save:&error];
        if( error ) {
            LOG(@"error: %@",error);
            
            [self clearCache:^(NSError *error) {
                completionHandler(error);
            }];

        } else {
            [self._privateMoc.parentContext performBlock:^{
                NSError* error = nil;
                [self._privateMoc.parentContext save:&error];
                if( error ) {
                    LOG(@"error: %@",error);
                }
                [self clearCache:^(NSError *error) {
                    completionHandler(error);
                }];

            }];
        }
    }];
}

#pragma mark -
#pragma mark NOT used
- (void) _deleteAllContents {
    [self._privateMoc performBlock:^{
        
        NSFetchRequest* request;
        NSEntityDescription* entity;
        NSError* error = nil;
        
        request = [[NSFetchRequest alloc] init];
        entity = [NSEntityDescription entityForName:@"EventTemplate" inManagedObjectContext:self._privateMoc];
        [request setEntity:entity];
        
        NSArray* array = [self._privateMoc executeFetchRequest:request error:&error];
        LOG(@"eventTemplate count: %d", [array count]);
        if( error ) {
            LOG_METHOD;
            LOG(@"error: %@",error);
        }
        
        if( [array count] > 0 ) {
            for(CDEventTemplate* t in array) {
                [self._privateMoc deleteObject:t];
            }
            NSError* error = nil;
            [self._privateMoc save:&error];
            if( error ) {
                LOG(@"error: %@",error);
            } else {
                [self._privateMoc.parentContext performBlock:^{
                    NSError* error = nil;
                    [self._privateMoc.parentContext save:&error];
                    if( error ) {
                        LOG(@"error: %@",error);
                    }
                }];
            }
        }
       
    }];
    
}

@end
