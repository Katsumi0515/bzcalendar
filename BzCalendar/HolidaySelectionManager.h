//
//  HolidaySelectionManager.h
//  GSystemT0
//
//  Created by 小林 活水 on 11/03/01.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HolidaySelectionManager : NSObject {
    		
}
+(HolidaySelectionManager*)sharedManager;

-(NSArray*) selectedHolidayIdentifiers;

- (BOOL)saveSelectedHolidays:(NSArray*)identifierList error:(NSError**)error;

@end
