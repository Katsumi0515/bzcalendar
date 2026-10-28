//
//  BzCloudMOCManagerProtocol.h
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/04/25.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

#ifndef BzCloudMOCManagerProtocol_h
#define BzCloudMOCManagerProtocol_h

@protocol BzCloudMOCManagerProtocol

- (NSManagedObjectContext*) bzCloudContext;
- (BOOL) isReadyToUse;
- (void) processPendingChanges;

@end

#endif /* BzCloudMOCManagerProtocol_h */
