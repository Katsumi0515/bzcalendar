//
//  SettingFontSizeForWeekTblViewController.m
//  BzCalendar
//
//  Created by 小林 活水 on 12/02/10.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import "SettingFontSizeForWeekTblViewController.h"
#import "BasicAppSettingManager.h"
#import "CalendarManager.h"
#import "WeekViewSettingManager.h"

#import "BzCalendar-Swift.h"

@interface SettingFontSizeForWeekTblViewController()

@property(nonatomic, retain) NSIndexPath* selectedIndex;

-(void) saveData;

@end

@implementation SettingFontSizeForWeekTblViewController

@synthesize selectedIndex;

-(void) saveData {
    NSInteger fontSizeNum = 100;
    switch (self.selectedIndex.row) {
        case 0:
            fontSizeNum = 100;
            break;
        case 1:
            fontSizeNum = 110;
            break;
        case 2:
            fontSizeNum = 120;
            break;
        default:
            break;
    }
    
    BasicAppSettingManager* basicMgr = [[CalendarManager sharedManager] basicSettingManager];
    BasicAppSetting* setting = [basicMgr basicAppSetting];
    setting.fontSizeForWeek = [NSNumber numberWithInteger:fontSizeNum];
    
    NSError* error = nil;
    [basicMgr saveAllChangesInContext:&error];
    
    if( error ) {
        LOG(@"error: %@", error);
    }
    
    WeekViewSettingManager* weekSetting = [WeekViewSettingManager sharedManager];
    [weekSetting refresh];
    
}

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"ViewTitle_Setting_FontSizeForWeek", @"フォントサイズ（週）");
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BasicAppSettingManager* manager = [[CalendarManager  sharedManager] basicSettingManager];
    BasicAppSetting* setting = [manager basicAppSetting];
    NSInteger fontSizeNum = 100;
    if( setting.fontSizeForWeek ) {
        fontSizeNum = [setting.fontSizeForWeek intValue];
    } else {
        setting.fontSizeForWeek = [NSNumber numberWithInt:100];
        self.selectedIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        [self saveData];
    }
    
    NSUInteger row = 1;
    switch (fontSizeNum) {
        case 100:
            row = 0;
            break;
        case 110:
            row = 1;
            break;
            
        case 120:
            row = 2;
            break;
        default:
            break;
    }
    self.selectedIndex = [NSIndexPath indexPathForRow:row inSection:0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SettingFontSizeForMonth_Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"10.0";
            break;
        case 1:
            cell.textLabel.text = @"11.0";
            break;
        case 2:
            cell.textLabel.text = @"12.0";
            break;
        default:
            break;
    }
    if( [indexPath compare:self.selectedIndex] == NSOrderedSame ) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    if( [indexPath compare:self.selectedIndex] != NSOrderedSame ) {
        self.selectedIndex = indexPath;
        [self.tableView reloadData];
        
        [self saveData];
    }
}


@end
