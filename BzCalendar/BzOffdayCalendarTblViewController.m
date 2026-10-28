//
//  BzOffdayCalendarTblViewController.m
//  BzCalendar
//
//  Created by 小林 活水 on 12/07/09.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import "BzOffdayCalendarTblViewController.h"
#import <EventKit/EventKit.h>
//#import "AppEventKit.h"
#import "BasicAppSettingManager.h"

#import "BzCalendar-Swift.h"

@interface BzOffdayCalendarTblViewController ()

@property (nonatomic, retain) NSArray* selectableCalendars;
@property (nonatomic, retain) EKCalendar* curOffdayCalendar;
@property (nonatomic, retain) NSIndexPath* selectedIndexPath;
-(void) saveData;

@end

@implementation BzOffdayCalendarTblViewController

@synthesize selectableCalendars;
@synthesize curOffdayCalendar;
@synthesize selectedIndexPath;

-(void) saveData {
    NSString* newID = nil;
    if( self.selectedIndexPath.section == 0 ) {
        newID = nil;
    } else {
        EKCalendar* cal = [self.selectableCalendars objectAtIndex:self.selectedIndexPath.row];
        newID = cal.calendarIdentifier;
    }
    [[BasicAppSettingManager sharedManager] setCustomHolidayID:newID];
    NSError* error = nil;
    [[BasicAppSettingManager sharedManager] saveAllChangesInContext:&error];
    
}
/*
- (void)saveClicked:(id)sender {
    LOG_METHOD;
    [self saveData];
	[self.navigationController popViewControllerAnimated:YES];
}
 */

- (id) init {
    self = [super initWithStyle:UITableViewStyleGrouped];
	if( self ) {
        self.title = NSLocalizedString(@"ViewTitle_Setting_CustomHolidayCalendars",
                                       @"カスタム休日カレンダー");
        
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSMutableArray* tmpArray = [NSMutableArray arrayWithCapacity:10];
    EKEventStore* store = [[AppEventKit shared] store];
	
    NSArray* array = [store calendarsForEntityType:EKEntityTypeEvent];
   
    for( EKCalendar* cal in array ) {
        if( cal.type != EKCalendarTypeBirthday ) {
            [tmpArray addObject:cal];
        }
    }
    
    self.selectableCalendars = tmpArray;

    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSString* calID = [[BasicAppSettingManager sharedManager] customHolidayID];
    if( calID ) {
        self.curOffdayCalendar = nil;
        for (int idx=0; idx<[self.selectableCalendars count]; idx++) {
            EKCalendar* cal = [self.selectableCalendars objectAtIndex:idx];
            if( [cal.calendarIdentifier compare:calID] == NSOrderedSame ) {
                self.curOffdayCalendar = cal;
                self.selectedIndexPath = [NSIndexPath indexPathForRow:idx inSection:1];
                break;
            }
        }
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rtnVal = 0;
    if( section == 0 ) {
        rtnVal = 1;
    } else {
        if( self.selectableCalendars ) {
            rtnVal = [self.selectableCalendars count];
        }
    }
    return rtnVal;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BzCustomHolidayCalendarTblViewController_Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = NSLocalizedString(@"Common_ExactJapaneseWord_Nashi",@"なし");
            break;
        case 1: {
            EKCalendar* cal = [self.selectableCalendars objectAtIndex:indexPath.row];
            cell.textLabel.text = cal.title;
        }
            break;
        default:
            break;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    if( [self.selectedIndexPath compare:indexPath] == NSOrderedSame ) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (void)dealloc {
    if( self.selectableCalendars ) self.selectableCalendars = nil;
    if( self.curOffdayCalendar ) self.curOffdayCalendar = nil;
    if( self.selectedIndexPath ) self.selectedIndexPath = nil;

    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString* rtnVal = nil;
    if( section == 1 ) {
        rtnVal = NSLocalizedString(@"SectionHeaderTitle_CostomHolidayCalendar_Desc",
                                   @"選択したカレンダーにイベントが登録されている日を休日として処理します。");
    }
    return rtnVal;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( [indexPath compare:self.selectedIndexPath] != NSOrderedSame ) {
        self.selectedIndexPath = indexPath;
        [self saveData];
        [self.tableView reloadData];
    }
}

@end
