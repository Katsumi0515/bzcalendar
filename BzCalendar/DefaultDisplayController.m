//
//  DefaultDisplayController.m
//  GSystemT0
//
//  Created by 小林 活水 on 11/01/31.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "DefaultDisplayController.h"
#import "CalendarManager.h"
#import "BasicAppSettingManager.h"
#import "DefaultDisplayTableViewCell.h"

@interface DefaultDisplayController()
@property (nonatomic ,retain) NSArray* selectionArray;
- (void) saveData;
- (void) saveClicked:(id)sender;
@end

@implementation DefaultDisplayController

@synthesize selectionArray;

-(void) saveData {
	BasicAppSettingManager* appSettingMgr = [[CalendarManager sharedManager] basicSettingManager];
	
	NSIndexPath* indexPath = [NSIndexPath indexPathForRow:selectedRow inSection:0];
	DefaultDisplayTableViewCell* cell = (DefaultDisplayTableViewCell*) [self.tableView cellForRowAtIndexPath:indexPath];
	
	[appSettingMgr setDefaultDisplayMode:cell.displayMode];
	
	
	NSError* error = nil;
	[appSettingMgr saveAllChangesInContext:&error];
	
	if( error ) {
		LOG(@"error in save: %@", [error userInfo]);
	}
	
	//[[CalendarManager sharedManager] notifyWeekStartWeekdayChenged];
    
}
- (void) saveClicked:(id)sender {
	LOG_METHOD;
	[self saveData];
	[self.navigationController popViewControllerAnimated:YES];
	
}

#pragma mark -
#pragma mark Initialization

- (id) init {
	if( (self = [super initWithStyle:UITableViewStyleGrouped]) != nil ) {
        self.title = NSLocalizedString(@"ViewTitle_Setting_InitialDisplayView", @"初期表示ビュー");

		NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:5];
        [array insertObject:NSLocalizedString(@"DefaultView_LastView", @"前回終了時の表示") atIndex:0];
		[array insertObject:NSLocalizedString(@"DefaultView_Month", @"Month表示") atIndex:1];
        [array insertObject:NSLocalizedString(@"DefaultView_Week", @"Week表示") atIndex:2];
		[array insertObject:NSLocalizedString(@"DefaultView_Day", @"Day表示") atIndex:3];
		self.selectionArray = array;
		
		
		selectedRow = 0;

	}
	return self;
}



#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	
	NSUInteger mode = [[[CalendarManager sharedManager] basicSettingManager] defaultDisplayMode];
	switch ( mode ) {
        case AppCalendarDisplayModeKeepPreviousMode:
            selectedRow = 0;
            break;
		case AppCalendarDisplayModeMonthly:
			selectedRow = 1;
			break;
        case AppCalendarDisplayModeWeekly:
            selectedRow = 2;
            break;
		case AppCalendarDisplayModeDaily:
			selectedRow = 3;
			break;
		default:
			break;
	}
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
    return [self.selectionArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"DefaultDisplayController_Cell";
    
    DefaultDisplayTableViewCell* cell = 
	(DefaultDisplayTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
        cell = [[DefaultDisplayTableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleDefault 
				 reuseIdentifier:CellIdentifier] ;
    }
    
    // Configure the cell...
    
	switch (indexPath.row) {
        case 0:
            cell.displayMode = AppCalendarDisplayModeKeepPreviousMode;
            cell.textLabel.text = [self.selectionArray objectAtIndex:0];
            break;
		case 1:
			cell.displayMode = AppCalendarDisplayModeMonthly;
			cell.textLabel.text = [self.selectionArray objectAtIndex:1];
			
			break;
        case 2:
            cell.displayMode = AppCalendarDisplayModeWeekly;
            cell.textLabel.text = [self.selectionArray objectAtIndex:2];
            break;
		case 3:
			cell.displayMode = AppCalendarDisplayModeDaily;
			cell.textLabel.text = [self.selectionArray objectAtIndex:3];
			break;
		default:
			break;
	}
	
	if( indexPath.row == selectedRow ) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor=[UIColor blueColor];
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	if( indexPath.row == selectedRow ) {	// 選択の解除はない
		return;
	}
	
	NSUInteger newSelectedRow = indexPath.row;
	UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
    cell.textLabel.textColor=[UIColor blueColor];
	
	NSIndexPath* lastIndexPath = [NSIndexPath indexPathForRow:selectedRow inSection:0];
	UITableViewCell* checkedCell = [tableView cellForRowAtIndexPath:lastIndexPath];
	checkedCell.accessoryType = UITableViewCellAccessoryNone;
	checkedCell.textLabel.textColor=[UIColor blackColor];
	
	selectedRow = newSelectedRow;
	
	cell.selected = NO;

	[self saveData];
}





@end

