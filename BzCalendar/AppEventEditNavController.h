//
//  AppEventEditNavController.h
//  GSystemT0
//
//  Created by 小林 活水 on 11/07/08.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface AppEventEditNavController : UINavigationController {
    
}

- (id)initWithEvent:(EKEvent*)event store:(EKEventStore *)eventStore;

@end
