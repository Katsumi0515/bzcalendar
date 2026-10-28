//
//  BzCustomizeCalendarTblViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/04/27.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzCustomizeCalendarTblViewController: UITableViewController {

    var calendar : EKCalendar?


    @IBOutlet weak var calendarColorCell: UITableViewCell!
    
    @IBAction func goToTopViewClicked(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
//        [self.navigationController popToRootViewControllerAnimated:NO];
//        
//        BzAppDelegate* appDelegate = (BzAppDelegate*)[[UIApplication sharedApplication] delegate];;
//        [[appDelegate topViewControllerDelegate] showMainView];

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Calendar", comment:"カレンダーのカスタマイズ")
        
        //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "customCalendarColorCell")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        //var cell = tableView.dequeueReusableCell(withIdentifier:"customCalendarColorCell", for:indexPath)
//        if cell == nil {
//            cell = UITableViewCell(style: .default, reuseIdentifier: "customCalendarColorCell")
//            cell?.accessoryType = .disclosureIndicator
//            cell?.selectionStyle = .none
//        }
        //let cell = tableView.dequeueReusableCell(withIdentifier: "customCalendarColorCell")
        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        switch (indexPath.row) {
        case 0:
            cell.textLabel?.text = NSLocalizedString("Common_ExactWord_Color", comment:"色")
            break;
        default:
            break;
        }
        

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let rtnVal = NSLocalizedString("CustomizeSetting_Calendar_Text", comment:"現時点では色のカスタマイズのみとなります")
        
        return rtnVal
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        guard segue.identifier == "customizeCalendarColorSegue" else {
            return
        }
        
        if let ctrl = segue.destination as? BzCustomCalendarColorViewController {
            ctrl.calendar = self.calendar
        }
        
//        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
//        
//        BzCustomCalendarColorViewController* ctrl = [storyboard instantiateViewControllerWithIdentifier:@"BzCustomCalendarColorViewController"];
//        
//        ctrl.calendar = self.calendar;
//        NSString* backTitle = NSLocalizedString(@"Common_CancelButton_Title", @"キャンセル");
//        UIBarButtonItem* backBarButtonItem = [[UIBarButtonItem alloc]
//            initWithTitle: backTitle
//            style:UIBarButtonItemStyleDone
//            target:nil
//            action:nil];
//        [backBarButtonItem setTintColor:[UIColor whiteColor]];
//        // Set custom back button.
//        [self.navigationItem setBackBarButtonItem:backBarButtonItem];
//        
//        
//        [self.navigationController pushViewController:ctrl animated:YES];
//    }

        
    }

}
