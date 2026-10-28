//
//  CalendarModeTabBarController.m
//  GSystemT0
//
//  Created by 小林 活水 on 10/09/05.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "BzTopTabBarController.h"
//#import "MoveToTodayViewController.h"
#import <QuartzCore/QuartzCore.h>
//#import "AppEventKit.h"
//#import "SelectOthersNavController.h"
//#import "EventExtension+Cloud.h"
#import "AppEventEditNavController.h"

#import "BzCalendar-Swift.h"

//#import "BzCloudManagedObjectContextManager.h" // notification defのため

#ifdef	APP_DEBUG
#include <sys/time.h>   // パフォーマンス計測用
#endif


@interface BzTopTabBarController()



@property (nonatomic, retain) BzTopNavBar* navBar;

@property (nonatomic, retain) BzDayPageViewController* dayViewController;
@property (nonatomic, retain) BzWeekPageViewController* weekViewController;
@property (nonatomic, retain) BzMonthPageViewController* monthViewController;


@property (nonatomic, retain) UINavigationController* selectOthersNavController;

@property (nonatomic, retain) NSMutableArray* tabViewControllers;


@property (nonatomic) AppCalendarDisplayMode prevDisplayMode;


@property (nonatomic, retain) UIActivityIndicatorView* indicator;

-(id) initSingleton;
-(void) _moveToDisplayModeView:(NSTimer*)timer;
-(void) _hidesTopNavBar:(BOOL)bl;
-(void) _showIndicator:(BOOL)bl;

@end


@implementation BzTopTabBarController

#pragma mark - BzApplicationTopViewControllerDelegate

-(void)selectDefaultDisplayMode {
    
    AppCalendarDisplayMode displayMode = [[CalendarManager sharedManager] defaultDisplayMode];
    if( displayMode == AppCalendarDisplayModeKeepPreviousMode ) {
        displayMode = [[BzSystemActivityManager shared] lastDisplayMode];
    }
    switch (displayMode) {
        case AppCalendarDisplayModeDaily:
            for( UIViewController* ctrl in self.viewControllers ) {
                if( [ctrl isKindOfClass:[BzDayPageViewController class]] ) {
                    self.selectedIndex = [self.viewControllers indexOfObject:ctrl];
                    self.prevController = ctrl;
                    self.prevDisplayMode = AppCalendarDisplayModeDaily;
                }
            }
//            self.selectedIndex = [self.tabViewControllers indexOfObject:self.dayViewController];
//            self.prevController = self.dayViewController;
//            self.prevDisplayMode = AppCalendarDisplayModeDaily;
            break;
        case AppCalendarDisplayModeWeekly:
            for( UIViewController* ctrl in self.viewControllers ) {
                if( [ctrl isKindOfClass:[BzWeekPageViewController class]] ) {
                    self.selectedIndex = [self.viewControllers indexOfObject:ctrl];
                    self.prevController = ctrl;
                    self.prevDisplayMode = AppCalendarDisplayModeWeekly;
                }
            }
//            self.selectedIndex = [self.tabViewControllers indexOfObject:self.weekViewController];
//            self.prevController = self.weekViewController;
//            self.prevDisplayMode = AppCalendarDisplayModeWeekly;
            break;
        case AppCalendarDisplayModeMonthly:
            for( UIViewController* ctrl in self.viewControllers ) {
                if( [ctrl isKindOfClass:[BzMonthPageViewController class]] ) {
                    self.selectedIndex = [self.viewControllers indexOfObject:ctrl];
                    self.prevController = ctrl;
                    self.prevDisplayMode = AppCalendarDisplayModeMonthly;
                }
            }
//            self.selectedIndex = [self.tabViewControllers indexOfObject:self.monthViewController];
//            self.prevController = self.monthViewController;
//            self.prevDisplayMode = AppCalendarDisplayModeMonthly;
            break;
        default:
            for( UIViewController* ctrl in self.viewControllers ) {
                if( [ctrl isKindOfClass:[BzDayPageViewController class]] ) {
                    self.selectedIndex = [self.viewControllers indexOfObject:ctrl];
                    self.prevController = ctrl;
                    self.prevDisplayMode = AppCalendarDisplayModeDaily;
                }
            }
//            self.selectedIndex = [self.tabViewControllers indexOfObject:self.dayViewController];
//            self.prevController = self.dayViewController;
//            self.prevDisplayMode = AppCalendarDisplayModeDaily;
            break;
    }
    UITabBarItem* tmpItem = [self.tabBar.items objectAtIndex:0];
    [tmpItem setEnabled:YES];
    [self _hidesTopNavBar:NO];
}

-(AppCalendarDisplayMode)currentDisplayMode {
    AppCalendarDisplayMode rtnVal = 0;
    if( self.prevDisplayMode != AppCalendarDisplayModeKeepPreviousMode ) {
        rtnVal = self.prevDisplayMode;
    } else {
        rtnVal = 0;
    }
    return rtnVal;
}

-(void)selectDisplayMode:(AppCalendarDisplayMode)mode {
    switch (mode) {
        case AppCalendarDisplayModeDaily:
            self.selectedIndex = 1;
            break;
        case AppCalendarDisplayModeWeekly:
            self.selectedIndex = 2;
            break;
        case AppCalendarDisplayModeMonthly:
            self.selectedIndex = 3;
            break;
        default:
            self.selectedIndex = 1;
            break;
    }
}

-(void) refreshCurrentEventView {
    LOG_METHOD;
    dispatch_async(dispatch_get_main_queue(), ^{
        // Swift以降では、BaseMainViewScrollControllerの内容を「プロトコル」にて
    // メインビューはプロトコルを実装する形式にする
    id selectedCtrl = self.selectedViewController;
    if( [selectedCtrl isKindOfClass:[BzDayPageViewController class]] ) {
        BzDayPageViewController* mainCtrl = (BzDayPageViewController*)selectedCtrl;
        // iCloudがenabledになった後、selectedDateを設定しただけでは再描画とならない？
        [mainCtrl displayScedulesWithForceRefresh:TRUE];
        //[mainCtrl refreshView];
    } else if( [selectedCtrl isKindOfClass:[BzWeekPageViewController class]] ) {
        BzWeekPageViewController* mainCtrl = (BzWeekPageViewController*)selectedCtrl;
        [mainCtrl displaySchedulesWithForceRefresh:TRUE];
        
    } else if( [selectedCtrl isKindOfClass:[BzMonthPageViewController class]] ) {
        BzMonthPageViewController* mainCtrl = (BzMonthPageViewController*)selectedCtrl;
        [mainCtrl displaySchedulesWithForceRefresh:TRUE];
    }
    });
}

-(void) showMainView {
    LOG_METHOD;
    
    switch ([[CalendarManager sharedManager] displayMode]) {
        case AppCalendarDisplayModeDaily:
            // 説明
            //  self.selectedIndexをすると、対象のViewControllerのviewWillAppearが呼ばれる
            //  ---> [dayViewController refresh]は不要（読んだら２度描画されてしまう
            for( UIViewController* ctrl in self.viewControllers ) {
                if( [ctrl isKindOfClass:[BzDayPageViewController class]] ) {
                    self.selectedIndex = [self.viewControllers indexOfObject:ctrl];
                    self.prevController = ctrl;
                    self.prevDisplayMode = AppCalendarDisplayModeDaily;
                }
            }
//            self.selectedIndex = [self.tabViewControllers indexOfObject:self.dayViewController];
//            self.prevController = self.dayViewController;
//            self.prevDisplayMode = AppCalendarDisplayModeDaily;
            break;
        case AppCalendarDisplayModeWeekly:
            for( UIViewController* ctrl in self.viewControllers ) {
                if( [ctrl isKindOfClass:[BzWeekPageViewController class]] ) {
                    self.selectedIndex = [self.viewControllers indexOfObject:ctrl];
                    self.prevController = ctrl;
                    self.prevDisplayMode = AppCalendarDisplayModeWeekly;
                }
            }
//            self.selectedIndex = [self.tabViewControllers indexOfObject:self.weekViewController];
//            self.prevController = self.weekViewController;
//            self.prevDisplayMode = AppCalendarDisplayModeWeekly;
            break;
        case AppCalendarDisplayModeMonthly:
            for( UIViewController* ctrl in self.viewControllers ) {
                if( [ctrl isKindOfClass:[BzMonthPageViewController class]] ) {
                    self.selectedIndex = [self.viewControllers indexOfObject:ctrl];
                    self.prevController = ctrl;
                    self.prevDisplayMode = AppCalendarDisplayModeMonthly;
                }
            }
//            self.selectedIndex = [self.tabViewControllers indexOfObject:self.monthViewController];
//            self.prevController = self.monthViewController;
//            self.prevDisplayMode = AppCalendarDisplayModeMonthly;
            break;
        default:
            for( UIViewController* ctrl in self.viewControllers ) {
                if( [ctrl isKindOfClass:[BzWeekPageViewController class]] ) {
                    self.selectedIndex = [self.viewControllers indexOfObject:ctrl];
                    self.prevController = ctrl;
                    self.prevDisplayMode = AppCalendarDisplayModeWeekly;
                }
            }
//            self.selectedIndex = [self.tabViewControllers indexOfObject:self.weekViewController];
//            self.prevController = self.weekViewController;
//            self.prevDisplayMode = AppCalendarDisplayModeWeekly;
            break;
    }
    
    UITabBarItem* tmpItem = [self.tabBar.items objectAtIndex:0];
    [tmpItem setEnabled:YES];
    [self _hidesTopNavBar:NO];
    LOG(@"END of showMainView");
}

-(void) applicationResumed {
    
    id token = [[NSFileManager defaultManager] ubiquityIdentityToken];
    if ([CalendarManager sharedManager].currentUbiquityToken != token) {
        if (NO == [[CalendarManager sharedManager].currentUbiquityToken isEqual:token]) {
            [self iCloudAccountChanged:nil];
        }
    }
    
    [self showMainView];
}

// 参照
-(void) openEvent:(EKEvent*)event {
    LOG_METHOD;
    
//    AppEventNavController* nav = [[AppEventNavController alloc] initWithEKEvent:event];
//    [self.selectedViewController presentViewController:nav animated:YES completion:^{}];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Event" bundle:nil];

    BzEventInfoTblViewController* ctrl = [storyboard instantiateViewControllerWithIdentifier:@"BzEventInfoTblViewController"];
    ctrl.event = event;

    
//    BzEventDetailViewController* ctrl = [storyboard instantiateViewControllerWithIdentifier:@"BzEventDetailViewController"];
//    ctrl.event = event;
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
    [nav setToolbarHidden:FALSE];
    [self.selectedViewController presentViewController:nav animated:TRUE completion:^{}];
}

// 新規作成
-(void) editEvent:(EKEvent*)event {
    LOG_METHOD;
    
    EKEventStore* store = [[AppEventKit shared] store];
    AppEventEditNavController* addController;
    addController = [[AppEventEditNavController alloc] initWithEvent:event store:store];
    
    [self.selectedViewController presentViewController:addController animated:YES completion:^{}];
    
}

-(void) addTemplate:(EKEvent *)event {
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"EventTemplate" bundle:nil];
    BzEventTemplateEditTblViewController* ctrl = [storyboard instantiateViewControllerWithIdentifier:@"BzEventTemplateEditTblViewController"];
    
    ctrl.event = event;
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
    
    //BzEventTemplateNavController* nav = [[BzEventTemplateNavController alloc]
    //                                     initWithEKEvent:event];
    
    [self.selectedViewController presentViewController:nav animated:YES completion:^{}];
    
}


#pragma mark -

- (void)iCloudDataReady:(NSNotification*)note {
    LOG_METHOD;
    [self refreshCurrentEventView];
}

- (void)iCloudAccountChanged:(NSNotification *)notification {
	
    // update the current ubiquity token
    id token = [[NSFileManager defaultManager] ubiquityIdentityToken];
    [CalendarManager sharedManager].currentUbiquityToken = token;
    
    //reload persistent store
   // [self loadPersistentStores];
}

#pragma mark - インスタンス

+(id)sharedController {
    static BzTopTabBarController* singleton = nil;

	if( singleton == nil ) {
		singleton = [[BzTopTabBarController alloc] initSingleton];
	}
	return singleton;
}

-(id)initSingleton {
#ifdef	APP_DEBUG
	struct timeval start, stop;
	
	gettimeofday(&start, NULL);
#endif
    self = [super init];
    if( self ) {
        
        
    }
#ifdef	APP_DEBUG
	gettimeofday(&stop, NULL);
    LOG_METHOD;
	LOG(@"total time: %f us.", ((stop.tv_sec * 1000000 + stop.tv_usec) -
                                (start.tv_sec * 1000000 + start.tv_usec)) /1000000.0f);
#endif		
	
    return self;	
}

- (id)init { //WithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	LOG(@"use initSingleton instead");
	exit(2);
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if( self ) {
        
    }
    return self;
}
#pragma mark - 標準メソッド（UIViewController）

- (void)viewWillAppear:(BOOL)animated {
	LOG_METHOD;
    [[[AppEventKit shared] store] refreshSourcesIfNecessary];
    UITabBarItem* tmpItem = [self.tabBar.items objectAtIndex:0];
    [tmpItem setEnabled:YES];
    
    
    [super viewWillAppear:animated];
}
//- (void)viewDidAppear:(BOOL)animated {
//    LOG_METHOD;
//    [super viewDidAppear:animated];
//}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.tabBar invalidateIntrinsicContentSize];
}

// iOS11からのUIViewControllerのメソッド
- (void)viewSafeAreaInsetsDidChange {
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(iCloudDataReady:)
                                                 name:NSNotification.BzCalendar_iCloudData_Ready
                                               object:nil];
    
    self.prevController = nil;
    
    

    for( UIViewController* ctrl in self.viewControllers ) {
        
        if( [ctrl isKindOfClass:[BzDayPageViewController class]] ) {
            UIImage* imageDay = [UIImage imageNamed:@"icon_day_7.png"];
            UITabBarItem* itmDay = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TabBarItem_Title_Day", @"日")
                                                                 image:imageDay
                                                                   tag:0] ;
            self.dayViewController = (BzDayPageViewController*)ctrl;
            self.dayViewController.tabBarItem = itmDay;
        } else if( [ctrl isKindOfClass:[BzWeekPageViewController class]] ) {
            UITabBarItem* itmWeek = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TabBarItem_Title_Week", @"週")
                                                                  image:[UIImage imageNamed:@"icon_week.png"]
                                                                    tag:0] ;
            self.weekViewController = (BzWeekPageViewController*)ctrl;
            self.weekViewController.tabBarItem = itmWeek;
        } else if( [ctrl isKindOfClass:[BzMonthPageViewController class]] ) {
            UITabBarItem* itmMonth = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TabBarItem_Title_Month", @"月")
                                                                   image:[UIImage imageNamed:@"icon_month.png"]
                                                                     tag:0] ;
            self.monthViewController = (BzMonthPageViewController*)ctrl;
            self.monthViewController.tabBarItem = itmMonth;
        } else if( [ctrl isKindOfClass:[UINavigationController class]] ) {
            self.selectOthersNavController = (UINavigationController*)ctrl;
            self.selectOthersNavController.tabBarItem = [[UITabBarItem alloc]
                                                         initWithTabBarSystemItem:UITabBarSystemItemMore
                                                         tag:0] ;

        } else if( [ctrl isKindOfClass:[BzMoveToTodayViewController class]] ){
            UITabBarItem* itmToday = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TabBarItem_Title_Today", @"今日")
                                                                   image:[UIImage imageNamed:@"tabbar_today3.png"]
                                                                     tag:0] ;
            ctrl.tabBarItem = itmToday;
        }
        
    }
    
//    UIStoryboard* dayStoryboard = [UIStoryboard storyboardWithName:@"DailyView" bundle:nil];
//    UIStoryboard* weekStoryboard = [UIStoryboard storyboardWithName:@"WeeklyView" bundle:nil];
//    UIStoryboard* monthStoryboard = [UIStoryboard storyboardWithName:@"MonthlyView" bundle:nil];
    
    //monthViewNavigationController
//    BzDayPageViewController* dayCtrl = [dayStoryboard instantiateViewControllerWithIdentifier:@"BzDayPageViewController"];
//    BzWeekPageViewController* weekCtrl = [weekStoryboard instantiateViewControllerWithIdentifier:@"BzWeekPageViewController"];
//    BzMonthPageViewController* monthCtrl = [monthStoryboard instantiateViewControllerWithIdentifier:@"BzMonthPageViewController"];
    
    
    
//    // カレンダーViewScrollControllers
//    self.dayViewController = dayCtrl;
//    self.dayViewController.tabBarItem = itmDay;
//    //self.weekViewController = [BzWeekViewScrollController sharedController];
//    self.weekViewController = weekCtrl;
//    self.weekViewController.tabBarItem = itmWeek;
//    //self.monthViewController = [BzMonthViewScrollController sharedController];
//    self.monthViewController = monthCtrl;
//    [self.monthViewController loadViewIfNeeded];
//    self.monthViewController.tabBarItem = itmMonth;
//
//
//    self.selectOthersNavController = [othersStoryboard instantiateInitialViewController];
//
//    self.selectOthersNavController.tabBarItem = [[UITabBarItem alloc]
//                                                 initWithTabBarSystemItem:UITabBarSystemItemMore
//                                                 tag:0] ;
//
//    self.selectOthersNavController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
//    self.tabViewControllers = [[NSMutableArray alloc]
//                               initWithObjects:
//                               ctrl01,
//                               self.dayViewController,
//                               self.weekViewController,
////                               monthNav,
//                               self.monthViewController,
//                               self.selectOthersNavController,
//                               nil];
    
    
    //[self setViewControllers:self.tabViewControllers];
    
    [self setDelegate:self];
    
    [self selectDefaultDisplayMode];
    
    //
    // Add ActivityIndicatorView
    //
    UIActivityIndicatorView* tmpView = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicator = tmpView;
    
    self.indicator.frame = CGRectMake(0, 0, 30, 30);
    self.indicator.center = self.view.center;
    
    [self.view addSubview:self.indicator];
    
    [super viewSafeAreaInsetsDidChange];
}

- (void)viewDidLoad {
    LOG_METHOD;
    [super viewDidLoad];
    
	CGRect navBarFrame = self.view.frame;
    
	if( [[UIApplication sharedApplication] isStatusBarHidden] == NO ) {
		navBarFrame.origin.y += [[UIApplication sharedApplication] statusBarFrame].size.height;
	}
	navBarFrame.size.height = 44;
	self.navBar = [[BzTopNavBar alloc] initWithFrame:navBarFrame];
	[self.view addSubview:self.navBar];
    
    [BzEventExtensionService shared];
}

-(void)viewWillLayoutSubviews {
    CGRect navBarFrame = self.view.frame;
    
    if( [[UIApplication sharedApplication] isStatusBarHidden] == NO ) {
        navBarFrame.origin.y += [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
    navBarFrame.size.height = 44;
    self.navBar.frame = navBarFrame;
}

#pragma mark -　ローテーション

-(UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark -
#pragma mark private methods
-(void) _showIndicator:(BOOL)bl {
    LOG_METHOD;
    if( bl ) {
        [self.indicator startAnimating];
    } else {
        [self.indicator stopAnimating];
    }
}
-(void) _hidesTopNavBar:(BOOL)bl {
	self.navBar.hidden = bl;
}
-(void) _moveToDisplayModeView:(NSTimer*)timer {
    LOG_METHOD;

    [[CalendarManager sharedManager] setSelectedDate:[NSDate date]];
    
    // ToDo: 表示する月が変わらない場合はsetupDateを呼ばなくていい
    [self.dayViewController displayScedulesWithForceRefresh:FALSE];
    [self.weekViewController displaySchedulesWithForceRefresh:FALSE];
    [self.monthViewController selectedDate:[[CalendarManager sharedManager] selectedDate]];
    
    [self showMainView];
}

#pragma mark -
#pragma mark UITabBarControllerDelegate Protocol
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    LOG_METHOD;
    BOOL rtn = YES;
    
    
    if( self.selectedViewController == viewController ) {
        
        if( viewController != self.selectOthersNavController ) {
            LOG(@"今日の処理, prevController: %@", prevController);
            [self _showIndicator:YES];
            
            if( self.prevController != self.selectOthersNavController ) {
                [self _showIndicator:YES];
                [NSTimer
                 scheduledTimerWithTimeInterval:0.000001f
                 target:self
                 selector:@selector(_moveToDisplayModeView:)
                 userInfo:nil
                 repeats:NO];
                [self _showIndicator:NO];
            } else {
                [self _moveToDisplayModeView:nil];
            }
            UITabBarItem* tmpItem = [self.tabBar.items objectAtIndex:0];
            [tmpItem setEnabled:YES];
        }
        rtn = NO;
    }
    return rtn;
}

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController {
    // Note: before this method gets called, viewController's viewDidAppear has been ended.
    
    LOG_METHOD;
    
    // ToDo: ActivityIndicatorが表示されるようにすること
    [self _showIndicator:YES];

    if( viewController == self.selectOthersNavController ) {
        UITabBarItem* tmpItem = [self.tabBar.items objectAtIndex:0];
        [tmpItem setEnabled:NO];
    } else {
        UITabBarItem* tmpItem = [self.tabBar.items objectAtIndex:0];
        [tmpItem setEnabled:YES];
    }
    
	if ([viewController isKindOfClass:[BzMoveToTodayViewController class]]) {
        LOG(@"今日の処理, prevController: %@", prevController);
        
        if( self.prevController != self.selectOthersNavController ) {
            [self _showIndicator:YES];
            [NSTimer
             scheduledTimerWithTimeInterval:0.000001f
             target:self
             selector:@selector(_moveToDisplayModeView:)
             userInfo:nil
             repeats:NO];
            [self _showIndicator:NO];
        } else {
            [self _moveToDisplayModeView:nil];
        }
        UITabBarItem* tmpItem = [self.tabBar.items objectAtIndex:0];
        [tmpItem setEnabled:YES];
        
	} else {
        if( viewController != self.selectOthersNavController ) {
            [self _hidesTopNavBar:NO];
        } else {
            [self _hidesTopNavBar:YES];
        }
        self.prevController = viewController;
        
        if( self.prevController == self.dayViewController ) {
            self.prevDisplayMode = AppCalendarDisplayModeDaily;
        } else if( self.prevController == self.weekViewController ) {
            self.prevDisplayMode = AppCalendarDisplayModeWeekly;
        } else if ( self.prevController == self.monthViewController ) {
            self.prevDisplayMode = AppCalendarDisplayModeMonthly;
        }
        LOG(@"selected prevDisplayMode: %d", prevDisplayMode);
    }
    
    [self _showIndicator:NO];

}

@end
