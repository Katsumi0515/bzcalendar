//
//  ColorUtil.m
//  GSystemT0
//
//  Created by 小林 活水 on 10/02/07.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ColorUtil.h"

static ColorUtil* manager = nil;

@interface ColorUtil()

-(id) initSingleton;

@end
@implementation ColorUtil


+(ColorUtil*) sharedManager {

	if( manager == nil) {
		manager = [[ColorUtil alloc] initSingleton];
	}

	return manager;
}

-(id) initSingleton {
	if((self = [super init]) != nil) {
		colorDict = [[NSMutableDictionary alloc] init];
	}
	return self;
}
-(id) init {
	exit(2);
	return nil;
}
-(NSString*) colorCodeFromUIColor:(UIColor*)color {
    if( color == nil)
        return nil;
    
    NSString* colorCode;
    NSInteger num = CGColorGetNumberOfComponents(color.CGColor);
    if( num >= 3 ) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        CGFloat r = components[0];
        CGFloat g = components[1];
        CGFloat b = components[2];
        //CGFloat a = components[3];
        colorCode = [NSString stringWithFormat:@"#%02x%02x%02x",  
                     (int)(r * 255), (int)(g * 255), (int)(b * 255)];  
        LOG(@"colorCode: %@", colorCode);
    } else {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        CGFloat g = components[0];
        colorCode = [NSString stringWithFormat:@"#%02x%02x%02x",  
                     (int)(g * 255), (int)(g * 255), (int)(g * 255)];  
        LOG(@"colorCode: %@", colorCode);
        
    }
    return colorCode;
}
-(UIColor*) UIColorFromColorCode:(NSString*) code {
	UIColor* color = [colorDict objectForKey:code];
	if( color ) {
		return color;
	}
		
	NSRange range;
	range.location = 1;
	range.length = 2;
	NSString* redString;
	NSString* greenString;
	NSString* blueString;
	
	redString = [code substringWithRange:range];
	range.location = 3;
	greenString = [code substringWithRange:range];
	range.location = 5;
	blueString = [code substringWithRange:range];
	
	unsigned intVal;
	
	NSScanner* scanner;
	
	float red, green, blue;
	
	scanner = [NSScanner scannerWithString:redString];
	[scanner scanHexInt:&intVal];
	red = intVal;
	scanner = [NSScanner scannerWithString:greenString];
	[scanner scanHexInt:&intVal];
	green = intVal;
	scanner = [NSScanner scannerWithString:blueString];
	[scanner scanHexInt:&intVal];
	blue = intVal;
	
	UIColor* tmpColor = [[UIColor alloc] initWithRed:(red/255)
                                                green:(green/255) 
                                                 blue:(blue/255) 
                                                alpha:1]
                         ;

	[colorDict setObject:tmpColor forKey:code];
	
	return tmpColor;
}

-(UIColor*) UIColorFromEKEvent:(EKEvent *)event {
	EKCalendar* cal = event.calendar;
	UIColor* color = [colorDict objectForKey:cal.calendarIdentifier];
	if( color ) {
		return color;
	}	
	CGColorRef cgColorRef = event.calendar.CGColor;
	UIColor* newColor = [[UIColor alloc] initWithCGColor:cgColorRef];
    if( newColor == nil ) {
        UIColor* tmpColor = [UIColor grayColor];
        [colorDict setObject:tmpColor forKey:cal.calendarIdentifier];
    } else {
        [colorDict setObject:newColor forKey:cal.calendarIdentifier];
       
    }
    color = [colorDict objectForKey:cal.calendarIdentifier];
    
	return color;
}

@end
