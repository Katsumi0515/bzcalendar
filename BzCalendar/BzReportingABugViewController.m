//
//  BzReportingABugViewController.m
//  BzCalendar
//
//  Created by 小林 活水 on 12/05/27.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import "BzReportingABugViewController.h"
#import "BzReportingABugByMailViewController.h"
#import "SupportByFacebookViewController.h"

@interface BzReportingABugViewController() 

@property(nonatomic, retain) UITableView* _tableView;

@end

@implementation BzReportingABugViewController

@synthesize _tableView;

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"ViewTitle_ReportingABug", @"不具合の報告");
    }
    return self;
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    LOG_METHOD;
    [super viewDidLoad];
    
    CGRect tblRect = self.view.bounds;
    UITableView* tblView = [[UITableView alloc] initWithFrame:tblRect style:UITableViewStyleGrouped];
    self._tableView = tblView;
    self._tableView.delegate = self;
    self._tableView.dataSource = self;
    self._tableView.scrollEnabled = NO;
    [self.view addSubview:self._tableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma marks -
#pragma marks UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BzReportingABugViewController_Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"e-mail";
            if( [BzReportingABugByMailViewController canSendMail] ) {
                cell.userInteractionEnabled = true;
                cell.textLabel.enabled = true;
            } else {
                cell.userInteractionEnabled = false;
                cell.textLabel.enabled = false;
            }
            break;
        case 1:
            cell.textLabel.text = @"facebook";
            break;
        default:
            cell.textLabel.text = EMPTY_STRING;
            break;
    }
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString(@"ReportingABug_Section_Title",
                             @"不具合の報告は下記いずれかの方法でお願い致します");
}

#pragma marks -
#pragma marks UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // BzReportingABugByMailViewController
    switch (indexPath.row) {
        case 0: {
            if( [BzReportingABugByMailViewController canSendMail] ) {
            
                BzReportingABugByMailViewController* ctrl = [[BzReportingABugByMailViewController alloc] init];
                
                [self presentViewController:ctrl animated:TRUE completion:^{
				
				}];
                
                
            } else {
                
            }
        }
            break;
        case 1:{
            SupportByFacebookViewController* ctrl = 
            [[SupportByFacebookViewController alloc] init];
            [self.navigationController pushViewController:ctrl animated:YES];
           
        }
            break;
        default:
            break;
    }

}

@end
