//
//  Clone_ColorPalletData.m
//  BzCalendar
//
//  Created by 小林 活水 on 12/02/17.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import "Clone_ColorPalletData.h"
#import "TemplateManagedObjectContextManager.h"
#import "ManagedObjectCloner.h"
#import "BzCalendar-Swift.h"

@implementation Clone_ColorPalletData
+(void) cloneData {
	LOG_METHOD;
    
	NSManagedObjectContext* templateCtx = [[TemplateManagedObjectContextManager sharedContextManager] sharedContext];
    if( templateCtx == nil ) {
        return;
    }
	NSManagedObjectContext* context = [[BzManagedObjectContextManager shared] parentMOC];
	if( context == nil ) {
        return;
    }

    NSArray* entityNames = [NSArray arrayWithObjects:@"ColorPallet",
                            @"ColorPallet_Item",
                            @"ColorCode", 
                            nil];
    
    for(NSString* name in entityNames) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:name];
        NSArray* arr = [context executeFetchRequest:request error:nil];
        for(NSManagedObject* mo in arr) {
            [context deleteObject:mo];
        }
    }
    
    
    
    for(NSString* name in entityNames ) {
        [ManagedObjectCloner cloneEntity:name
                             fromContext:templateCtx
                               toContext:context];
    }
    
    NSError* contextError = nil;
    [context save:&contextError];
    if( contextError ) {
        [context reset];
    }
}

@end
