//
//  BzSysErrorData.h
//  BzCalendar
//
//  Created by 小林 活水 on 13/01/20.
//  Copyright (c) 2013年 Katsumi KOBAYASHI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BzSysErrorData : NSObject {
    NSError* error;
    NSArray* stackTraceArray;
    NSString* location;
}
@property(nonatomic, retain) NSError* error;
@property(nonatomic, retain) NSArray* stackTraceArray;
@property(nonatomic, retain) NSString* location;

-(id) initWithError:(NSError*)_error stackTrace:(NSArray*)_stackTrace location:(NSString*)_location;

@end
