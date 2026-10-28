//
//  HowToLinkWithGoogleCalsTableViewController.m
//  BzCalendar
//
//  Created by 小林 活水 on 11/11/14.
//  Copyright (c) 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "HowToLinkWithGoogleCalsTableViewController.h"
#import "HowToAddGoogleAccountForCalendarUsage.h"
#import "HowToAddMultiGoogleCalendarViewController.h"
#import "HowToSetupForCalendarSyncPeriod.h"

@implementation HowToLinkWithGoogleCalsTableViewController

- (void) leftBtnClicked:(id)sendar {
    //[self.navigationController dismissModalViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];

}

- (id) init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"ViewTitle_GoogleSync", 
                                       @"グーグルカレンダー連携");
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    
/*
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leftBtnClicked:)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [leftBtn release];
*/
}

- (void)viewWillAppear:(BOOL)animated
{
    UIBarButtonItem* backBarButtonItem = [[UIBarButtonItem alloc]
                                          initWithTitle:NSLocalizedString(@"Common_BarButtonItem_Back", @"戻る")
                                          style:UIBarButtonItemStyleDone 
                                          target:nil
                                          action:nil];
    
    [backBarButtonItem setTintColor:[UIColor whiteColor]];
    // Set custom back button.
    [self.navigationItem setBackBarButtonItem:backBarButtonItem];
      

    [super viewWillAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HowToLinkWithGoogleCalsTableViewController_Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = NSLocalizedString(@"ViewTitle_HowTo_MultiGoogleCalendar",
                                                    @"複数カレンダーとの同期");
            break;
        case 1:
            cell.textLabel.text = NSLocalizedString(@"ViewTitle_HowTo_AddGoogleAccount",
                                                    @"グーグルアカウント追加方法");
            break;
        case 2:
            cell.textLabel.text = NSLocalizedString(@"ViewTitle_HowTo_CalendarSyncPeriod", 
                                                    @"同期期間の設定");
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            HowToAddMultiGoogleCalendarViewController* ctrl =
            [[HowToAddMultiGoogleCalendarViewController alloc] init];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
            break;
        case 1: {
            HowToAddGoogleAccountForCalendarUsage* ctrl =
            [[HowToAddGoogleAccountForCalendarUsage alloc] init];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
              break;
        case 2:{
            HowToSetupForCalendarSyncPeriod* ctrl =
            [[HowToSetupForCalendarSyncPeriod alloc] init];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
            
            break;
        default:
            break;
    }
}

@end
