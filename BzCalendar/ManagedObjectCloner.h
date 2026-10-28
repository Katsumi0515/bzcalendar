//
//  ManagedObjectCloner.h
//  GSystemInitData
//
//  Created by 小林 活水 on 11/03/01.
//  Copyright 2011 Yamaha Employee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import	<CoreData/CoreData.h>


@interface ManagedObjectCloner : NSObject {

}
+(void) addEntity:(NSString*)entityName
      fromContext:(NSManagedObjectContext*)fromCtx
        toContext:(NSManagedObjectContext*) toCtx
withDuplicationCheck:(BOOL)dupCheck
       completion:(void (^)(NSError *error))completionHandler;

+(void) addEntities:(NSArray*)entityNameArray
        fromContext:(NSManagedObjectContext*)fromCtx
          toContext:(NSManagedObjectContext*) toCtx
withDuplicationCheck:(BOOL)dupCheck
         completion:(void (^)(NSError *error))completionHandler;

+(NSManagedObject *)clone:(NSManagedObject *)source inContext:(NSManagedObjectContext *)context;
+(void) cloneEntity:(NSString*)entityName 
		fromContext:(NSManagedObjectContext*) fromCtx
		  toContext:(NSManagedObjectContext*) toCtx;
@end
