//
//  CloneFallbackStoreToBzCloudStore.m
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/04/18.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

#import "CloneFallbackStoreToBzCloudStore.h"

@implementation CloneFallbackStoreToBzCloudStore
//
//- (void)addToCloud_FromFallbackStore:(NSURL *)seedStoreURL
//                               error:(NSError**)error
//                     removeFromStore:(BOOL)removeFromStore
//                          completion:(void (^)(BOOL success))completionHandler
//{
//
//    BOOL success = YES;
//    NSError *localError = nil;
//
//    if( self.iCloudStore == nil ) {
//        completionHandler(FALSE);
//        return;
//    }
//
//    //    NSManagedObjectContext* moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
//    NSManagedObjectContext* moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//    [moc setPersistentStoreCoordinator:self.persistentStoreCoordinator];
//
//    //NSManagedObjectContext* moc = self.parentMOC;
//
//    NSManagedObjectModel *model = [self managedObjectModel]; // [NSManagedObjectModel mergedModelFromBundles:nil];
//    NSPersistentStoreCoordinator *seedPSC = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
//    NSDictionary *seedStoreOptions = @{ NSReadOnlyPersistentStoreOption : [NSNumber numberWithBool:YES] };
//    NSPersistentStore *seedStore = [seedPSC addPersistentStoreWithType:NSSQLiteStoreType
//                                                         configuration:nil
//                                                                   URL:seedStoreURL
//                                                               options:seedStoreOptions
//                                                                 error:&localError];
//
//
//    if (seedStore) {
//
//
//        //NSManagedObjectContext *seedMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType ];
//        NSManagedObjectContext *seedMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//        [seedMOC setPersistentStoreCoordinator:seedPSC];
//
//
//        NSArray* entityNames = [NSArray arrayWithObjects:@"CalendarExtension",
//                                @"CustomHolidayCalendar",
//                                @"CustomHolidayCalendarItem",
//                                @"EventExtension",
//                                @"EventTemplate",
//                                nil];
//
//
//        [ManagedObjectCloner addEntities:entityNames
//                             fromContext:seedMOC
//                               toContext:moc
//                    withDuplicationCheck:YES
//                              completion:^(NSError* error) {
//
//                                  if( error ) {
//                                      completionHandler(FALSE);
//                                      return;
//                                  }
//                                  NSError* contextError = nil;
//                                  [moc save:&contextError];
//                                  if( contextError ) {
//                                      [moc reset];
//                                  }
//
//                                  if( removeFromStore == YES ) {
//                                      NSError* removeErr = nil;
//                                      [[NSFileManager defaultManager] removeItemAtURL:seedStoreURL error:&removeErr];
//                                      if( removeErr ) {
//                                          LOG(@"removeError: %@", removeErr);
//                                      }
//                                  }
//                                  completionHandler(TRUE);
//                                  return;
//                              }];
//
//
//    } else {
//        success = NO;
//        LOG(@"Error adding seed store: %@", localError);
//    }
//
//    if (NO == success) {
//        if (localError  && (error != NULL)) {
//            *error = localError;
//        }
//    }
//
//
//    completionHandler( success );
//}
//
//
@end

