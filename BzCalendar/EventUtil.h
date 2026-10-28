//
//  EventUtil.h
//  GSystemT0
//
//  Created by 小林 活水 on 10/01/09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "EventProtocol.h"

@interface EventUtil : NSObject {

}
+(BOOL) isLongEvent:(NSObject*) obj;
+(int) eventLengthByDay:(NSObject *)obj;
+(int) eventLength:(NSObject*) obj fromDate:(NSDate*)fromDate;

@end
