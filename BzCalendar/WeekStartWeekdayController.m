//
//  WeekStartWeekdayController.m
//  GSystemT0
//
//  Created by 小林 活水 on 11/01/30.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "WeekStartWeekdayController.h"
#import "BasicAppSettingManager.h"
#import "CalendarManager.h"

@interface WeekStartWeekdayController()

@property (nonatomic, retain) NSArray* weekdaySymbols;

-(void) saveData;

@end

@implementation WeekStartWeekdayController


@synthesize weekdaySymbols;

#pragma mark -
#pragma mark Initialization

- (id) init {
    self = [super initWithStyle:UITableViewStyleGrouped];
	if( self ) {
        self.title = NSLocalizedString(@"ViewTitle_Setting_WeekStartWeekday", @"週の開始曜日");

	}
	return self;
}

#pragma mark -
#pragma mark View lifecycle

-(void) saveData {
	BasicAppSettingManager* appSettingMgr = [[CalendarManager sharedManager] basicSettingManager];
	
	NSIndexPath* indexPath = [NSIndexPath indexPathForRow:selectedRow inSection:0];
	[appSettingMgr setWeekStartWeekday:indexPath.row + 1];
    
	NSError* error = nil;
	[appSettingMgr saveAllChangesInContext:&error];
    
	[[CalendarManager sharedManager] notifyWeekStartWeekdayChenged];
    
}
- (void) saveClicked:(id)sender {
	LOG_METHOD;
    [self saveData];
	[self.navigationController popViewControllerAnimated:YES];
	
}

- (void)viewDidLoad {
    [super viewDidLoad];

	self.weekdaySymbols = [[CalendarManager sharedManager] weekdaySymbols];	
}


- (void)viewWillAppear:(BOOL)animated {
	
	selectedRow = [[CalendarManager sharedManager] weekStartWeekday] - 1;
    [self.tableView reloadData];
    
    [super viewWillAppear:animated];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 7;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"WeekStartWeekdayControllerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    // Configure the cell...
	
	cell.textLabel.text = [self.weekdaySymbols objectAtIndex:indexPath.row];
	if( indexPath.row == selectedRow ) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
	if( indexPath.row == selectedRow ) {
		return;
	}
	
	NSUInteger newSelectedRow = indexPath.row;
	UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
	
	NSIndexPath* lastIndexPath = [NSIndexPath indexPathForRow:selectedRow inSection:0];
	UITableViewCell* checkedCell = [tableView cellForRowAtIndexPath:lastIndexPath];
	checkedCell.accessoryType = UITableViewCellAccessoryNone;
	
	selectedRow = newSelectedRow;
	
	cell.selected = NO;
    
    [self saveData];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    LOG_METHOD;
    if( self.weekdaySymbols ) weekdaySymbols =nil;
   
}


@end

