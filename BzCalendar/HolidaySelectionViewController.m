//
//  HolidaySelectionViewController.m
//  GSystemT0
//
//  Created by 小林 活水 on 11/02/28.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "HolidaySelectionViewController.h"
#import "CalendarManager.h"
#import "BasicAppSettingManager.h"

#import "BzCalendar-Swift.h"

@interface HolidaySelectionViewController()

@property(nonatomic, retain) WorldCalendarManager* holidayMgr;
@property(nonatomic, retain) NSMutableArray* selectionNameList;
@property(nonatomic, retain) NSArray* allWorldCalendars;

-(void) saveData;

@end

@implementation HolidaySelectionViewController

@synthesize holidayMgr;
@synthesize selectionNameList;
@synthesize allWorldCalendars;

#pragma mark -
#pragma mark Initialization

- (void) saveData {

    if( selectedRow == 0 ) {
        BasicAppSettingManager* basicMgr = [BasicAppSettingManager sharedManager];
        [basicMgr setAutoHolidayDetect:NO];
        NSError* basicError = nil;
        [basicMgr saveAllChangesInContext:&basicError];
        //NSError* selectError =
        [self.holidayMgr saveHolidayCalendarsWithIdentifierList:nil];
    } else if( selectedRow == 1 ) {
        BasicAppSettingManager* basicMgr = [BasicAppSettingManager sharedManager];
        [basicMgr setAutoHolidayDetect:YES];
        NSError* basicError = nil;
        [basicMgr saveAllChangesInContext:&basicError];
        //NSError* selectError =
        [self.holidayMgr saveHolidayCalendarsWithIdentifierList:nil];
        
    } else {
        BasicAppSettingManager* basicMgr = [BasicAppSettingManager sharedManager];
        [basicMgr setAutoHolidayDetect:NO];
        NSError* basicError = nil;
        [basicMgr saveAllChangesInContext:&basicError];
        
        NSUInteger calIdx = selectedRow - 2;
        WorldCalendarElement* elm = [self.allWorldCalendars objectAtIndex:calIdx];
        LOG(@"elm: %@", elm.identifier);
        NSArray* arr = [NSArray arrayWithObject:elm.identifier];
        //NSError* selectError = nil;
        [self.holidayMgr saveHolidayCalendarsWithIdentifierList:arr];
    }
    [[WorldCalendarManager shared] update];
	[[CalendarManager sharedManager] notifyHolidaySelectionChanged];
    
}
- (void) changeClicked:(id)sender {
	LOG_METHOD;
    [self saveData];
	[self.navigationController popViewControllerAnimated:YES];
	
}

- (id) init {
	if( (self = [super initWithStyle:UITableViewStyleGrouped]) != nil ) {
        self.title = NSLocalizedString(@"ViewTitle_Setting_HolidayCalendars", 
                                       @"祝日カレンダー");

		self.holidayMgr = [WorldCalendarManager shared];

	}
	return self;
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	/*
    UIBarButtonItem* button =  
    [[UIBarButtonItem alloc] initWithTitle:@"変更"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(changeClicked:)];
	
	self.navigationItem.rightBarButtonItem = button;
    [button release];
	*/
    
}



- (void)viewWillAppear:(BOOL)animated {
    
    self.allWorldCalendars = [WorldCalendarFactory.shared sharedList];
	
	self.selectionNameList = [NSMutableArray arrayWithCapacity:5];
	[self.selectionNameList addObject:NSLocalizedString(@"HolidaySelection_None", @"なし")];    // index: 0
    [self.selectionNameList addObject:NSLocalizedString(@"HolidaySelection_AutoSelection",@"自動選択")]; // index: 1
    for(WorldCalendarElement* elm in self.allWorldCalendars) {
        [self.selectionNameList addObject:elm.displayName];
    }
    
    BasicAppSettingManager* basicMgr = [BasicAppSettingManager sharedManager];
    
	NSUInteger idx = 0;
    if( basicMgr.isAutoHolidayDetect ) {
        idx = 1;
    } else if( holidayMgr.isHolidayOn ) {
        NSArray* arr = [holidayMgr selectedHolidayIdentifiers];
        // ToDo: 封数選択に対応した場合は、コードを変更する
        NSString* idName = [arr objectAtIndex:0];
        for (int i =0; i < self.allWorldCalendars.count; i++) {
            WorldCalendarElement* elm = [self.allWorldCalendars objectAtIndex:i];
            if( [elm.identifier compare:idName] == NSOrderedSame ) {
                idx = i + 2;
            }
        }    
    }
	selectedRow = idx;
    	
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
    return [self.selectionNameList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"HolidaySelectionViewController_Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    // Configure the cell...

    cell.textLabel.text = [self.selectionNameList objectAtIndex:indexPath.row];
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
    
	if( indexPath.row == selectedRow ) {
		return;
	}
			
	selectedRow = indexPath.row;
		
    [self saveData];
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	LOG_METHOD;
}




@end

