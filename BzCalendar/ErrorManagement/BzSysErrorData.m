//
//  BzSysErrorData.m
//  BzCalendar
//
//  Created by 小林 活水 on 13/01/20.
//  Copyright (c) 2013年 Katsumi KOBAYASHI. All rights reserved.
//

#import "BzSysErrorData.h"

@implementation BzSysErrorData

@synthesize error;
@synthesize stackTraceArray;
@synthesize location;

-(id) initWithError:(NSError*)_error stackTrace:(NSArray*)_stackTrace location:(NSString*)_location {
    self = [super init];
    if( self ) {
        self.error = _error;
        self.stackTraceArray = _stackTrace;
        self.location = _location;
    }
    return self;
}

@end
