//
//  ManagedObjectCloner.m
//  GSystemInitData
//
//  Created by 小林 活水 on 11/03/01.
//  Copyright 2011 Yamaha Employee. All rights reserved.
//

#import "ManagedObjectCloner.h"
//#import "EventExtension+Cloud.h"

@implementation ManagedObjectCloner

+(NSManagedObject *) clone:(NSManagedObject *)source inContext:(NSManagedObjectContext *)context{
    NSString *entityName = [[source entity] name];
	
    //create new object in data store
    NSManagedObject *cloned = [NSEntityDescription
                               insertNewObjectForEntityForName:entityName
                               inManagedObjectContext:context];
	
    //loop through all attributes and assign then to the clone
    NSDictionary *attributes = [[NSEntityDescription
                                 entityForName:entityName
                                 inManagedObjectContext:context] attributesByName];
	
    for (NSString *attr in attributes) {
        [cloned setValue:[source valueForKey:attr] forKey:attr];
    }
	
    //Loop through all relationships, and clone them.
    NSDictionary *relationships = [[NSEntityDescription
									entityForName:entityName
									inManagedObjectContext:context] relationshipsByName];
    for (NSRelationshipDescription *rel in relationships){
        NSString *keyName = [NSString stringWithFormat:@"%@",rel];
        //get a set of all objects in the relationship
        NSMutableSet *sourceSet = [source mutableSetValueForKey:keyName];
        NSMutableSet *clonedSet = [cloned mutableSetValueForKey:keyName];
        NSEnumerator *e = [sourceSet objectEnumerator];
        NSManagedObject *relatedObject;
        while ( (relatedObject = [e nextObject])){
            //Clone it, and add clone to set
            NSManagedObject *clonedRelatedObject = [ManagedObjectCloner clone:relatedObject 
																	inContext:context];
            [clonedSet addObject:clonedRelatedObject];
        }
		
    }
	
    return cloned;
}

+(NSManagedObject *) cloneOrUpdate:(NSManagedObject *)source inContext:(NSManagedObjectContext *)context{
    NSString *entityName = [[source entity] name];
	
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:[source entity]];
    NSPredicate* predicate = nil;

    if( [entityName compare:@"EventExtension"] == NSOrderedSame ) {
        id calendarIdentifier = [source valueForKey:@"calendarIdentifier"];
        id identifier = [source valueForKey:@"identifier"];
        if( calendarIdentifier && identifier) {
            predicate = [NSPredicate predicateWithFormat:@"calendarIdentifier = %@ and identifier = %@", calendarIdentifier, identifier];
        } else {
            
        }
    } else if( [entityName compare:@"CalendarExtension"] == NSOrderedSame ) {
        predicate = [NSPredicate predicateWithFormat:@"identifier = %@", [source valueForKey:@"identifier"]];

    } else if ( [entityName compare:@"EventTemplate"] == NSOrderedSame ) {
        predicate = [NSPredicate predicateWithFormat:@"templateGroupName = %@ and templateName = %@", [source valueForKey:@"templateGroupName"], [source valueForKey:@"templateName"]];

    } else if( [entityName compare:@"CustomHolidayCalendar"] == NSOrderedSame ) {
        predicate = [NSPredicate predicateWithFormat:@"identifier = %@", [source valueForKey:@"identifier"]];

    } else if( [entityName compare:@"CustomHolidayCalendarItem"] == NSOrderedSame ) {
        predicate = [NSPredicate predicateWithFormat:@"calendarIdentifier = %@ and date = %@", [source valueForKey:@"calendarIdentifier"], [source valueForKey:@"date"]];

    } else {
        
        return nil;
    }
	[request setPredicate:predicate];
	
    NSError* error = nil;
    NSArray* resultArr = [context executeFetchRequest:request error:&error];
      
    NSManagedObject* clonedOrUpdated = nil;
    
    if( ([resultArr count] ==  0) || (resultArr == nil) ) {
        //create new object in data store
        clonedOrUpdated = [NSEntityDescription
                           insertNewObjectForEntityForName:entityName
                           inManagedObjectContext:context];

    } else {
        clonedOrUpdated = [resultArr objectAtIndex:0];

	}
    //loop through all attributes and assign then to the clone
    NSDictionary *attributes = [[NSEntityDescription
                                 entityForName:entityName
                                 inManagedObjectContext:context] attributesByName];
    
    for (NSString *attr in attributes) {
        [clonedOrUpdated setValue:[source valueForKey:attr] forKey:attr];
    }
    
    //Loop through all relationships, and clone them.
    NSDictionary *relationships = [[NSEntityDescription
                                    entityForName:entityName
                                    inManagedObjectContext:context] relationshipsByName];
    for (NSRelationshipDescription *rel in relationships){
        NSString *keyName = [NSString stringWithFormat:@"%@",rel];
        //get a set of all objects in the relationship
        NSMutableSet *sourceSet = [source mutableSetValueForKey:keyName];
        NSMutableSet *clonedSet = [clonedOrUpdated mutableSetValueForKey:keyName];
        NSEnumerator *e = [sourceSet objectEnumerator];
        NSManagedObject *relatedObject;
        while ( (relatedObject = [e nextObject])){
            //Clone it, and add clone to set
            NSManagedObject *clonedRelatedObject = [ManagedObjectCloner clone:relatedObject
                                                                    inContext:context];
            [clonedSet addObject:clonedRelatedObject];
        }
        
    }
    
    return clonedOrUpdated;
}

+(void) addEntities:(NSArray*)entityNameArray
      fromContext:(NSManagedObjectContext*)fromCtx
        toContext:(NSManagedObjectContext*) toCtx
withDuplicationCheck:(BOOL)dupCheck
       completion:(void (^)(NSError *error))completionHandler {
    
    
    // スレッドの問題で落ちる
    
    __block int count = 0;
    __block int fetchEndCount = 0;
    
    // performBlockAndWait　でも処理をすり抜けているようだ。mainスレッドだから？？？
    [fromCtx performBlockAndWait:^{
        
        for(NSString* entityName in entityNameArray) {
            count += 1;
            
            __block NSError* error = nil;
            
            //[fromCtx performBlockAndWait:^{
            
            NSFetchRequest* request = [[NSFetchRequest alloc] init];
            NSEntityDescription* entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:fromCtx];
            if( entity == nil ) {
                NSLog(@"entity is nil....");
            }
            [request setEntity:entity];
            
            NSAsynchronousFetchRequest *asynchronousFetchRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:request completionBlock:^(NSAsynchronousFetchResult *result) {
                
                NSArray* templateEntityArr = result.finalResult;
                
                if( templateEntityArr.count > 0 ) {
                    NSLog(@"more than 0!!!!");
                }
                if( [entityName isEqualToString:@"EventExtension"] ) {
                    for( NSManagedObject* item in templateEntityArr ) {
                        NSLog(@"item: %@", item);
                    }
                } else if( [entityName isEqualToString:@"CalendarExtension"] ) {
                    for( NSManagedObject* item in templateEntityArr ) {
                        NSLog(@"item: %@", item);
                    }
                }
                
                if( error ) {
                    NSLog(@"error: %@, count: %d", error, count);
                    NSLog(@"stores: %@", fromCtx.persistentStoreCoordinator.persistentStores);
                    
                    NSString* errorAt = [NSString stringWithFormat:@"%s [fromCtx executeFetch...", __func__];
                    [[SystemErrorManager sharedManager] error:error
                                                           at:errorAt
                                                    callStack:[NSThread callStackSymbols]
                                               alertWithTitle:NSLocalizedString(@"AlertTitle_SystemError", @"システムエラー")
                                                      message:NSLocalizedString(@"AlertMessage_SuggestReportingToDevelopper", @"エラー発生情報のサポートへの自動送付にご協力お願い致します。")];
                }
                
                NSLog(@"templateEntityArr.count: %d", (int)templateEntityArr.count);
                __block NSMutableArray* errorArr = [NSMutableArray arrayWithCapacity:10];
                
                [toCtx performBlockAndWait:^{
                    for( NSManagedObject* obj in templateEntityArr ) {
                        if( dupCheck == YES ) {
                            [ManagedObjectCloner cloneOrUpdate:obj inContext:toCtx];
                        } else {
                            [ManagedObjectCloner clone:obj inContext:toCtx];
                        }
                    }
                    if( toCtx.hasChanges ) {
                        NSError* saveErr = nil;
                        [toCtx save:&saveErr];
                        if( saveErr ) {
                            [errorArr addObject:saveErr];
                            
                            NSString* errorAt = [NSString stringWithFormat:@"%s [toCtx save:&saveErr]", __func__];
                            [[SystemErrorManager sharedManager] error:saveErr
                                                                   at:errorAt
                                                            callStack:[NSThread callStackSymbols]
                                                       alertWithTitle:NSLocalizedString(@"AlertTitle_SystemError", @"システムエラー")
                                                              message:NSLocalizedString(@"AlertMessage_SuggestReportingToDevelopper", @"エラー発生情報のサポートへの自動送付にご協力お願い致します。")];
                        }
                        
                        
                    }
                    fetchEndCount += 1;
                    NSLog(@"fetchEndCount: %d", fetchEndCount);
                    
                    if( fetchEndCount >= entityNameArray.count ) {
                        completionHandler(nil);
                    }
                    
                }];
            }];
            
            
            
            //NSUInteger batchSize = 5000;
            //[request setFetchBatchSize:batchSize];
            NSError* asynchronousFetchRequestError = nil;
            NSAsynchronousFetchResult *asynchronousFetchResult = [fromCtx executeRequest:asynchronousFetchRequest error:&asynchronousFetchRequestError];
            NSLog(@"class? %@", [asynchronousFetchResult class]);
            NSLog(@"finalResult: %@", asynchronousFetchResult.finalResult); // 非同期なので、nullのはず。KVOで確認するためか？
            //templateEntityArr = [fromCtx executeFetchRequest:request error:&error];
            
            //  }];
            
            
            
            //}];
            
        } // for(NSString* entityName in ...
    }];

}

+(void) addEntity:(NSString*)entityName
      fromContext:(NSManagedObjectContext*)fromCtx
        toContext:(NSManagedObjectContext*) toCtx
withDuplicationCheck:(BOOL)dupCheck
       completion:(void (^)(NSError *error))completionHandler {

    [fromCtx performBlockAndWait:^{
        NSError* error = nil;
        NSFetchRequest* request = [[NSFetchRequest alloc] init];
        NSEntityDescription* entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:fromCtx];
        [request setEntity:entity];
        //fetch all the person objects, use a batched fetch request to control memory usage
        NSUInteger batchSize = 5000;
        [request setFetchBatchSize:batchSize];
        
        
        NSAsynchronousFetchRequest *asynchronousFetchRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:request completionBlock:^(NSAsynchronousFetchResult *result) {
            if (result.finalResult) {
            
            }
        }];

        
        NSArray* templateEntityArr = [fromCtx executeFetchRequest:request error:&error];
        
        if( error ) {
            NSString* errorAt = [NSString stringWithFormat:@"%s [fromCtx executeFetch...", __func__];
            [[SystemErrorManager sharedManager] error:error
                                                   at:errorAt
                                            callStack:[NSThread callStackSymbols]
                                       alertWithTitle:NSLocalizedString(@"AlertTitle_SystemError", @"システムエラー")
                                              message:NSLocalizedString(@"AlertMessage_SuggestReportingToDevelopper", @"エラー発生情報のサポートへの自動送付にご協力お願い致します。")];
            return;
        }
        
        NSLog(@"templateEntityArr.count: %d", (int)templateEntityArr.count);
        
        
        for( NSManagedObject* obj in templateEntityArr ) {
            if( dupCheck == YES ) {
                [ManagedObjectCloner cloneOrUpdate:obj inContext:toCtx];
            } else {
                [ManagedObjectCloner clone:obj inContext:toCtx];
            }
        }
        
        NSError* saveErr = nil;
        [toCtx save:&saveErr];
        if( saveErr ) {
            NSString* errorAt = [NSString stringWithFormat:@"%s [toCtx save:&saveErr]", __func__];
            [[SystemErrorManager sharedManager] error:error
                                                   at:errorAt
                                            callStack:[NSThread callStackSymbols]
                                       alertWithTitle:NSLocalizedString(@"AlertTitle_SystemError", @"システムエラー")
                                              message:NSLocalizedString(@"AlertMessage_SuggestReportingToDevelopper", @"エラー発生情報のサポートへの自動送付にご協力お願い致します。")];
            return;
        }
        
        
    }];
    
    
    
    

}
+(void) cloneEntity:(NSString*)entityName
		fromContext:(NSManagedObjectContext*) fromCtx
		  toContext:(NSManagedObjectContext*) toCtx {
	
	NSError* error = nil;
	NSFetchRequest* request = [[NSFetchRequest alloc] init];
	NSEntityDescription* entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:fromCtx];
	[request setEntity:entity]; 
    //fetch all the person objects, use a batched fetch request to control memory usage
    NSUInteger batchSize = 5000;
    [request setFetchBatchSize:batchSize];

	NSArray* templateEntityArr = [fromCtx executeFetchRequest:request error:&error];
   
	if( error ) {
        NSString* errorAt = [NSString stringWithFormat:@"%s [fromCtx executeFetch...", __func__];
        [[SystemErrorManager sharedManager] error:error
                                               at:errorAt
                                        callStack:[NSThread callStackSymbols]
                                   alertWithTitle:NSLocalizedString(@"AlertTitle_SystemError", @"システムエラー")
                                          message:NSLocalizedString(@"AlertMessage_SuggestReportingToDevelopper", @"エラー発生情報のサポートへの自動送付にご協力お願い致します。")];
        return;
	}
		
	for( NSManagedObject* obj in templateEntityArr ) {
		[ManagedObjectCloner clone:obj inContext:toCtx];
	}
    
    NSError* saveErr = nil;
    [toCtx save:&saveErr];
    if( saveErr ) {
        NSString* errorAt = [NSString stringWithFormat:@"%s [toCtx save:&saveErr]", __func__];
        [[SystemErrorManager sharedManager] error:error
                                               at:errorAt
                                        callStack:[NSThread callStackSymbols]
                                   alertWithTitle:NSLocalizedString(@"AlertTitle_SystemError", @"システムエラー")
                                          message:NSLocalizedString(@"AlertMessage_SuggestReportingToDevelopper", @"エラー発生情報のサポートへの自動送付にご協力お願い致します。")];
        return;
    }
}

@end
