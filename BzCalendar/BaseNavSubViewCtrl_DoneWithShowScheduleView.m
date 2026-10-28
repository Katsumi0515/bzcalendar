//
//  ViewController_NavCloseButton.m
//  BzCalendar
//
//  Created by 小林 活水 on 12/02/11.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import "BaseNavSubViewCtrl_DoneWithShowScheduleView.h"
#import "BzAppDelegate.h"

@implementation BaseNavSubViewCtrl_DoneWithShowScheduleView

-(void) doneClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    BzAppDelegate* appDelegate = (BzAppDelegate*)[[UIApplication sharedApplication] delegate];;
    [[appDelegate topViewControllerDelegate] showMainView];
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	UIBarButtonItem* itemDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																		   target:self
																		   action:@selector(doneClicked:)];
	//[itemDone setTintColor:[UIColor whiteColor]];
	self.navigationItem.rightBarButtonItem = itemDone;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
