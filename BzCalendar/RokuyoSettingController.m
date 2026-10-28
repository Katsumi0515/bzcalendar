//
//  RokuyoSettingController.m
//  GSystemT0
//
//  Created by 小林 活水 on 11/02/12.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "RokuyoSettingController.h"
#import "CalendarManager.h"

@interface RokuyoSettingController()

@property(nonatomic, retain) UISwitch* rokuyoSwitch;

- (void) flip:(id)sendar;
- (void) saveData;

@end

@implementation RokuyoSettingController

@synthesize rokuyoSwitch;

#pragma mark -
#pragma mark Initialization

- (id) init {
	if( (self = [super initWithStyle:UITableViewStyleGrouped]) != nil ) {
        self.title = NSLocalizedString(@"ViewTitle_Setting_Rokuyo", 
                                       @"六曜表示");

	}
	return self;	
}

- (void) flip:(id)sendar {
    [self saveData];
}
- (void) saveData {
	BasicAppSettingManager* appSettingMgr = [[CalendarManager sharedManager] basicSettingManager];
	
	[appSettingMgr setRokuyoOn:self.rokuyoSwitch.on];
	
	NSError* error = nil;
	[appSettingMgr saveAllChangesInContext:&error];
	//[[CalendarManager sharedManager] notifyRokuyoSettingChanged];
	    
}
- (void) saveClicked:(id)sender {
	LOG_METHOD;
    [self saveData];
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    /*
    UIBarButtonItem* saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(saveClicked:)];
    self.navigationItem.rightBarButtonItem =  saveBtn;
    [saveBtn release];
	*/
    
	UISwitch* tmpSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [tmpSwitch addTarget: self action: @selector(flip:) forControlEvents: UIControlEventValueChanged];
    self.rokuyoSwitch = tmpSwitch;
  }



- (void)viewWillAppear:(BOOL)animated {
	BasicAppSettingManager* appSetting = [[CalendarManager sharedManager] basicSettingManager]; 
	
	

	self.rokuyoSwitch.on = appSetting.isRokuyoOn;
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
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"RokuyoSettingController_CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Configure the cell...
    
	cell.textLabel.text = NSLocalizedString(@"Common_ExactWord_ShowRokuyo", @"六曜表示");
	cell.accessoryView = self.rokuyoSwitch;	
	
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


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
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}




@end

