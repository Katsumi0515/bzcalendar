//
//  BzExtFunctionListController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/01.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzExtFunctionListController: UITableViewController {

    
    @IBOutlet weak var calendarExtCell: UITableViewCell!
    
    @IBOutlet weak var eventTemplateCell: UITableViewCell!
    
    @IBOutlet weak var eventCustomColorCell: UITableViewCell!
    
    
    @IBAction func doneClicked(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
        //[self.navigationController popToRootViewControllerAnimated:NO];
        
//        BzAppDelegate* appDelegate = (BzAppDelegate*)[[UIApplication sharedApplication] delegate];;
//        [[appDelegate topViewControllerDelegate] showMainView];

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Viewtitle_ExtFunction", comment:"拡張機能");


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        if let cell = self.calendarExtCell, let textLabel = cell.textLabel {
            textLabel.text = NSLocalizedString("Common_ExactWord_Calendar", comment:"カレンダー")
            cell.accessoryType = .disclosureIndicator
            
        }
        if let cell = self.eventTemplateCell, let textLabel = cell.textLabel {
            textLabel.text = NSLocalizedString("ViewTitle_CustomSetting_EventTemplate", comment:"イベントテンプレート")
            cell.accessoryType = .disclosureIndicator
            
        }
        if let cell = self.eventCustomColorCell, let textLabel = cell.textLabel {
            textLabel.text = NSLocalizedString("CellTitle_ExtFunction_EventCustomColor", comment:"イベントのカスタム色");
        }
        
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // カスタム色の廃止
        
//        var rtnVal : Int = 2
//        if BzEventExtensionService.shared().iCloudReadyToUser() == false {
//            rtnVal = 1
//        }
//        return rtnVal
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var rtnVal : Int = 0
        switch (section) {
        case 0:
            rtnVal = 2
        case 1:
            rtnVal = 1
        default:
            rtnVal = 0
        }
        return rtnVal;
    }

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//        let cell = super.tableView(tableView, cellForRowAt: indexPath)
//        return cell
//    }

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
        
        if segue.identifier == "customCalendarSelectSegue" {
            if let ctrl = segue.destination as? BzSelectedCalendarListTblViewController {
                ctrl.onlyWritableCalendars = false
            }
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if( indexPath.section == 0 ) {
            if BzEventExtensionService.shared().iCloudReadyToUser() {
                
                if( indexPath.row == 0 ) {
                    //self.performSegue(withIdentifier: "", sender: self)
                } else if (indexPath.row == 1) {
//                    let storyboard = UIStoryboard(name: "Setting", bundle: nil)
//                    let ctrl = storyboard.instantiateViewController(withIdentifier: "BzEventTemplateTblViewController")
//                    
//                    //let ctrl = BzEventTemplateTblViewController()
//                    self.navigationController?.pushViewController(ctrl, animated: true)
                    
                }
            }
        }

    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var rtnVal = ""
        if section == 0  {
            if BzEventExtensionService.shared().iCloudReadyToUser() == false {
                rtnVal = NSLocalizedString("SectionTitle_CustomSetting_iCloudNotReady",
                                           comment:"iCloudの準備中です。しばらくしてからご利用ください。")
            } else {
                rtnVal = NSLocalizedString("SectionTitle_ExtFunctions_SettingsList", comment:"設定可能な拡張機能");
            }
        } else if( section == 1 ) {
            
            rtnVal = NSLocalizedString("SectionTitle_ExtFunctions_EnabledFunctionList",comment:"有効化された拡張機能");
        }
        return rtnVal

    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if BzEventExtensionService.shared().iCloudReadyToUser() {
            return true
        }
        return false

    }
}
