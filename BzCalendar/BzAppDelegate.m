 //
//  BzAppDelegate.m
//  BzCalendar
//
//  Created by 小林 活水 on 11/11/10.
//  Copyright (c) 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "BzAppDelegate.h"
//#import "BzCloudManagedObjectContextManager.h"
//#import "AppEventKit.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <StoreKit/StoreKit.h>
#import "BzCalendar-Swift.h"
#import <Contacts/Contacts.h>

@interface BzAppDelegate()

//@property (nonatomic, strong) BzTopTabBarController2* calendarController;

- (void) _checkAccess;
- (NSString *)_applicationDocumentsDirectory;

@end

@implementation BzAppDelegate

@synthesize window = _window;
@synthesize topTabBarController;

#pragma mark - app color setting

-(void) setupAppAppearance {
        
    [BzAppThemeService.shared applyTheme];
    
    return;
    
}

#pragma mark -
#pragma mark public methods

- (id<BzApplicationTopViewControllerDelegate>)topViewControllerDelegate {
    return self.topTabBarController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    LOG_METHOD;
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    
    
    // ------------------------------------
    // 前準備: ユーザに通知の許可を求める
    // ------------------------------------
    
    // request to notify for user
    [center requestAuthorizationWithOptions:
     UNAuthorizationOptionBadge |
     UNAuthorizationOptionSound |
     UNAuthorizationOptionAlert
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
         
     }];
    center.delegate = self;
    

    UIFont* systemFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    //システムフォントのインスタンスからフォントサイズを取得
    UIFontDescriptor *fontDesc = [systemFont fontDescriptor];
    NSLog(@"fontDesc: %@", fontDesc);
    NSNumber* fontsize = [fontDesc fontAttributes][UIFontDescriptorSizeAttribute];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    label.text = @"Hi, how are you?";
    
    NSDictionary* attrsDictionary = @{NSFontAttributeName: systemFont};

    CGRect checkRect = [label.text boundingRectWithSize:CGSizeMake(320, 5000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrsDictionary context:NULL];

    NSLog(@"checkRect: %@", NSStringFromCGRect(checkRect));
    
    //Application supports iTunes file sharingを追加。終わったらさくじ
//    JPHolidayDatabaseCreate* j = [[JPHolidayDatabaseCreate alloc] init];
    //RokuyoDatabaseCreate* d = [[RokuyoDatabaseCreate alloc] init];
    
    
    [Fabric with:@[[Crashlytics class], [Answers class]]];
    
	[self _checkAccess];

    [self setupAppAppearance];
    
	
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    self.window.backgroundColor= [UIColor whiteColor];

    //UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //self.topTabBarController = [BzTopTabBarController sharedController];
    //self.window.rootViewController = self.topTabBarController;

    //[self.window makeKeyAndVisible];

    self.topTabBarController = (BzTopTabBarController*) self.window.rootViewController;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    LOG_METHOD;
    
    AppCalendarDisplayMode mode = [self.topTabBarController currentDisplayMode];
    LOG(@"mode: %d", mode);
    [[BzSystemActivityManager shared] saveCurrentDisplayModeWithMode:mode];
    //[[BzCloudManagedObjectContextManager sharedManager] processPendingChanges];    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    LOG_METHOD;
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    LOG_METHOD;
    [self _checkAccess];
    
    AppCalendarDisplayMode mode = [[CalendarManager sharedManager] defaultDisplayMode];
    if( mode != AppCalendarDisplayModeKeepPreviousMode ) {
        [self.topTabBarController selectDefaultDisplayMode];
    } else {
        AppCalendarDisplayMode lastMode = [[BzSystemActivityManager shared] lastDisplayMode];
        
        [self.topTabBarController selectDisplayMode:lastMode];
        [self.topTabBarController.view setNeedsDisplay];
    }

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    LOG_METHOD;
#ifdef	APP_DEBUG
	gettimeofday(&start, NULL);
#endif
    
    [self.topTabBarController.view setNeedsLayout];
    [self.topTabBarController.view setNeedsDisplay];

    NSString* key = @"startUpCount_forRating";
    NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:key];
    
    [[NSUserDefaults standardUserDefaults] setInteger: count + 1 forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    count = [[NSUserDefaults standardUserDefaults] integerForKey:key];
    switch (count) {
        case 40:
        case 200:
        case 400:
        case 600:
        case 800:
            [SKStoreReviewController requestReview];
            break;
        default:
            break;
    }

#ifdef	APP_DEBUG
	gettimeofday(&stop, NULL);
	LOG(@"finishLaunc to didBecomeActive time: %.6f", ((stop.tv_sec * 1000000 + stop.tv_usec) -
                                                         (start.tv_sec * 1000000 + start.tv_usec)) /1000000.0f);
#endif
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    LOG_METHOD;
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder {
    LOG_METHOD;
    return NO;
}
-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder {
    LOG_METHOD;
    return NO;
}

#pragma mark -
#pragma mark private methods

- (UIViewController*) _topViewController {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}

- (void) _checkAccess {
    
    EKEventStore* store = [[AppEventKit shared] store];
    
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        /* This code will run when uses has made his/her choice */
        
        if( !granted ) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSString* _title = NSLocalizedString(@"AlertTitle_PleaseSetPrivacySetting",@"プライバシー設定をオンにしてください");
                NSString* _message = NSLocalizedString(@"AlertMessage_HowToSetPrivacySetting",@"「設定」->「プライバシー」->「カレンダー」");
                UIAlertController * alert =
                [UIAlertController alertControllerWithTitle:_title
                                                    message:_message
                                             preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Common_ExactWord_OK", @"OK")
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action) {
                                                                     
                                                                 }];
                [alert addAction:okAction];

                UIViewController* topController = [self _topViewController];
                [topController presentViewController:alert animated:TRUE completion:nil];
                
            });
        }
    }];

    
//    CNEntityType entityType = CNEntityTypeContacts;
//    if( [CNContactStore authorizationStatusForEntityType:entityType] == CNAuthorizationStatusNotDetermined)
//    {
//        CNContactStore * contactStore = [[CNContactStore alloc] init];
//        [contactStore requestAccessForEntityType:entityType completionHandler:^(BOOL granted, NSError * _Nullable error) {
//            if(granted){
//
//            }
//        }];
//    }
//    else if( [CNContactStore authorizationStatusForEntityType:entityType]== CNAuthorizationStatusAuthorized)
//    {
//
//    }


}

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)_applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

// ローカル通知

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    
}

// The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from application:didFinishLaunchingWithOptions:.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    
}
@end
