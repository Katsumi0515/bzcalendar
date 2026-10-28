//
//  BzEventTemplateListTblViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/02.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzEventTemplateListTblViewController: UITableViewController {

    @IBAction func doneClicked(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        
        //    BzAppDelegate* appDelegate = (BzAppDelegate*)[[UIApplication sharedApplication] delegate];
        //    [[appDelegate topViewControllerDelegate] showMainView];

    }
    fileprivate var eventTemplateArray = NSMutableArray(capacity:10)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = NotificationCenter.default
        nc.addObserver(forName: NSNotification.Name.NSManagedObjectContextDidSave, object: nil, queue: nil) {
            note in
            print("hi!")
        }
//        UIBarButtonItem* itemClose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
//            target:self
//            action:@selector(closeClicked:)];
//        [itemClose setTintColor:[UIColor whiteColor]];
//
//        self.navigationItem.rightBarButtonItem = itemClose;
        
        
        self.title = NSLocalizedString("Common_ExactWord_Template", comment:"テンプレート");
        self.tableView.isEditing = true
        self.tableView.allowsSelectionDuringEditing = true
        //[self.tableView setEditing:YES animated:NO];
        //[self.tableView setAllowsSelectionDuringEditing:YES];
        
        
        self.eventTemplateArray =  NSMutableArray(array: BzEventExtensionService.shared().eventTemplate())

    }

    override func viewWillAppear(_ animated: Bool) {
    
        self.eventTemplateArray =  NSMutableArray(array: BzEventExtensionService.shared().eventTemplate())
        
        self.tableView.reloadData()

        super.viewWillAppear(animated)
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
        var rowCount : Int = 1
        if self.eventTemplateArray.count > 0 {
            rowCount = self.eventTemplateArray.count + 1
        }
        return rowCount;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //super.tableView.cellForRow(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventTemplateCell", for: indexPath)

        if indexPath.row == 0  {
            cell.textLabel?.text = NSLocalizedString("Common_ExactWord_Add_Template", comment:"テンプレート登録")
            
        } else {
            if let tmp = self.eventTemplateArray.object(at: indexPath.row - 1) as? AppEventTemplate {
                cell.textLabel?.text = tmp.templateName
            }
        }
        cell.editingAccessoryType = .disclosureIndicator
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

   // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
            if( tableView.isEditing && 0 == indexPath.row) {
                return .insert;
            } else {
                return .delete;
            }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            if let template = self.eventTemplateArray[indexPath.row - 1] as? AppEventTemplate {
                BzEventExtensionService.shared().delete(eventTemplate: template)
                self.eventTemplateArray.remove(template)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        else if editingStyle == .insert {
            let storyboard = UIStoryboard(name: "EventTemplate", bundle: nil)

            if let addCtrl = storyboard.instantiateViewController(withIdentifier: "BzEventTemplateEditTblViewController") as? BzEventTemplateEditTblViewController {
                
                self.navigationController?.pushViewController(addCtrl, animated: true)
            }

        }

    }
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        
//        if editingStyle == .delete {
//            if let template = self.eventTemplateArray.object(at: indexPath.row - 1) as? AppEventTemplate {
//                BzEventExtensionService.shared().delete(eventTemplate: template)
//                self.tableView.deleteRows(at: [indexPath], with: .fade)
//            }
//        }
//        else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//            
//            let storyboard = UIStoryboard(name: "EventTemplate", bundle: nil)
//            
//            
//            if let addCtrl = storyboard.instantiateViewController(withIdentifier: "BzEventTemplateEditTblViewController") as? BzEventTemplateEditTblViewController {
//                
//                self.navigationController?.pushViewController(addCtrl, animated: true)
//            }
//            
//        }
//        
//    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        UIBarButtonItem* backBarButtonItem = [[UIBarButtonItem alloc]
//            initWithTitle: backTitle
//            style:UIBarButtonItemStyleDone
//            target:nil
//            action:nil];
//
//        [backBarButtonItem setTintColor:[UIColor whiteColor]];
//        // Set custom back button.
//        [self.navigationItem setBackBarButtonItem:backBarButtonItem];
        
        
        let storyboard = UIStoryboard(name: "EventTemplate", bundle: nil)
        if( indexPath.row == 0 ) {
            
            if let addCtrl = storyboard.instantiateViewController(withIdentifier: "BzEventTemplateEditTblViewController") as? BzEventTemplateEditTblViewController {
                
                self.navigationController?.pushViewController(addCtrl, animated: true)
            }
            
        } else {
            if let template = self.eventTemplateArray.object(at: indexPath.row - 1) as? AppEventTemplate {
                if let addCtrl = storyboard.instantiateViewController(withIdentifier: "BzEventTemplateEditTblViewController") as? BzEventTemplateEditTblViewController {
                    addCtrl.eventTemplate = template
                    self.navigationController?.pushViewController(addCtrl, animated: true)
                }
            }
        }

        
    }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    

}
