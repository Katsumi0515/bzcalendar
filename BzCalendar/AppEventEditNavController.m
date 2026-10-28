//
//  AppEventEditNavController.m
//  GSystemT0
//
//  Created by 小林 活水 on 11/07/08.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "AppEventEditNavController.h"
#import "BzCalendar-Swift.h"

@interface AppEventEditNavController()

@end

@implementation AppEventEditNavController
 
- (id)initWithEvent:(EKEvent*)event store:(EKEventStore *)eventStore {
    LOG_METHOD;
    self = [super init];
    if( self ) {
        
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Event" bundle:nil];
        BzEventEditTblViewController* ctrl = [storyboard instantiateViewControllerWithIdentifier:@"BzEventEditTblViewController"];
        ctrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [ctrl targetEventWithEvent:event store:eventStore];
        
        [self pushViewController:ctrl animated:NO];
        
    }
    return self;    
}

@end
