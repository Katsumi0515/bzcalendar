//
//  BzTopNavBar.m
//  GSystemT0
//
//  Created by 小林 活水 on 11/02/12.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "BzTopNavBar.h"
//#import "AppEventKit.h"
#import "CalendarManager.h"
#import "BzAppDelegate.h"

@interface BzTopNavBar()
-(void) eventCreate:(id)sender;
@end

@implementation BzTopNavBar

-(void) eventCreate:(id)sender {
    BzAppDelegate* appDelegate = (BzAppDelegate*)[[UIApplication sharedApplication] delegate];

    [[appDelegate topViewControllerDelegate] editEvent:nil];
}

- (void)drawRect:(CGRect)rect {
}

- (id)initWithFrame:(CGRect)frame {
	
    if ( (self = [super initWithFrame:frame]) != nil ) {
        // Initialization code.

		// イベント登録ボタンの設定
		UIBarButtonItem* eventCreateButton = 
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                      target:self
                                                      action:@selector(eventCreate:)];
//        [eventCreateButton setTintColor:[UIColor whiteColor]];
        
		UINavigationItem* navItem = [[UINavigationItem alloc] init];
		navItem.rightBarButtonItem = eventCreateButton;
		
		[self pushNavigationItem:navItem animated:NO];
		self.barStyle = UIBarStyleDefault;
        self.backgroundColor = [UIColor clearColor];
		self.alpha = 1.0f;
		self.translucent = YES;
        
      
//        self.tintColor= [UIColor whiteColor];

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/



@end
