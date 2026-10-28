//
//  BzEventTamplateManager.h
//  BzCalendar
//
//  Created by 小林 活水 on 12/06/09.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppEventTemplate;

@interface BzEventTamplateManager :  NSObject {     NSManagedObjectContext* _privateMoc;
    NSMutableDictionary* _extensionDict;

}

@property(nonatomic, retain) NSManagedObjectContext* _privateMoc;
@property(nonatomic, retain) NSMutableDictionary* _extensionDict;

- (id) initSingleton;
//- (void) _setupData;
-(void)setPrivateContext:(NSManagedObjectContext*)privateContext;

- (BOOL)saveAllChangesInContext:(NSError**)error;
- (void)clearCache:(void (^)(NSError* error))completionHandler;

+(BzEventTamplateManager*)sharedManager;

// 取得系
-(NSArray*)getEventTemplatesOfDefaultGroup; // 現状はデフォルトグループのみサポート

// 変更系
-(void) addNewTemplate:(AppEventTemplate*) template completionHandler: (void (^)(NSError* error))completionHandler;     // 即永続化
-(void) updateTemplate:(AppEventTemplate*) eventTemplate completionHandler: (void (^)(NSError* error))completionHandler; // 即永続化
-(void) deleteTemplate:(AppEventTemplate*) eventTemplate;   // 即永続化

@end
