//
//  ColorUtil.h
//  GSystemT0
//
//  Created by 小林 活水 on 10/02/07.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface ColorUtil : NSObject {
	NSMutableDictionary* colorDict;
}

+(ColorUtil*) sharedManager;
-(UIColor*) UIColorFromColorCode:(NSString*) code;
-(UIColor*) UIColorFromEKEvent:(EKEvent*) event;
-(NSString*) colorCodeFromUIColor:(UIColor*)color;

@end
