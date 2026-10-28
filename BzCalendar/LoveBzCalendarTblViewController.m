//
//  LoveBzCalendarTblViewController.m
//  BzCalendar
//
//  Created by 小林 活水 on 12/07/17.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import "LoveBzCalendarTblViewController.h"
#import "BzAppDelegate.h"
#import "BzApplicationTopViewControllerDelegate.h"
#import "SupportByFacebookViewController.h"
#import <StoreKit/StoreKit.h>

@interface LoveBzCalendarTblViewController ()


@end

@implementation LoveBzCalendarTblViewController

- (id) init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"ViewTitle_LinkTo_UserReview", 
                                       @"ユーザーレビュー");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem* backBarButtonItem = [[UIBarButtonItem alloc]
                                          initWithTitle:NSLocalizedString(@"Common_BarButtonItem_Back", @"戻る")
                                          style:UIBarButtonItemStyleDone
                                          target:self
                                          action:@selector(actionBack:)];
    [backBarButtonItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
}

-(void)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rtnVal = 2;
    return rtnVal;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LoveBzCalendarTblViewController_Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = NSLocalizedString(@"GoTo_AppStore_ReviewSite",
                                                    @"レビューをする");
            break;
        case 1:
            cell.textLabel.text = NSLocalizedString(@"SupportSite_Title_Facebook",
                                                    @"フェースブック");
            break;
        default:
            break;
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if( indexPath.row == 0 ) {
        if (@available(iOS 10.3, *)) {
            [SKStoreReviewController requestReview];
        }
    } else if (indexPath.row == 1 ) {
        SupportByFacebookViewController* ctrl =
        [[SupportByFacebookViewController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

#pragma marks - UITableViewDataSource

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString* rtnVal = nil;
    if( section == 0 ) {
        rtnVal = NSLocalizedString(@"LinkTo_UserReview_Text", 
                                   @"本アプリのレビューをどうぞよろしくお願い致します。");
    } 
    return rtnVal;
}

#pragma mark - Optional UIWebViewDelegate delegate methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
