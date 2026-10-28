//
//  BzAppDelegate.h
//  BzCalendar
//
//  Created by 小林 活水 on 11/11/10.
//  Copyright (c) 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BzTopTabBarController.h"
#import "BzApplicationTopViewControllerDelegate.h"
#import <UserNotifications/UserNotifications.h>

#ifdef	APP_DEBUG
#include <sys/time.h>   // パフォーマンス計測用
#endif

@interface BzAppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate> {
#ifdef	APP_DEBUG	
	struct timeval start, stop;
#endif

}
@property (nonatomic, strong) BzTopTabBarController* topTabBarController;

@property (strong, nonatomic) UIWindow *window;

- (id<BzApplicationTopViewControllerDelegate>) topViewControllerDelegate;

@end
