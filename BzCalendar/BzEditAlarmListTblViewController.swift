//
//  BzEditAlarmListTblViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/08.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

protocol AlarmsChangeProtocol {
    func alarmsChange(_ newAlarms:Array<EKAlarm>)
}

class BzEditAlarmListTblViewController: UITableViewController, EditEKAlarmProtocol {
   

    fileprivate var editAlarmArray : [EKAlarm] = Array()
    var originalAlarmArray : [EKAlarm]? = Array() {
        didSet {
            if let array = originalAlarmArray {
                editAlarmArray = Array(array)
            }
        }
    }
    
    var alarmsChangeProtocol : AlarmsChangeProtocol? = nil

    fileprivate func notifyUpdatedAlarms() {
        if let delegate = self.alarmsChangeProtocol {
            delegate.alarmsChange(self.editAlarmArray)
        }
    }

    @IBAction func doneClicked(_ sender: Any) {
        
        self.notifyUpdatedAlarms()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("ViewTitle_Event_Alarm", comment:"通知");
        self.tableView.setEditing(true, animated: false)
        self.tableView.allowsSelectionDuringEditing = true
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
        return self.editAlarmArray.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath)

        if indexPath.row < self.editAlarmArray.count {
            let alm = self.editAlarmArray[indexPath.row]
            cell.textLabel?.text = alm.stringValue()
        } else {
            cell.textLabel?.text = NSLocalizedString("Common_Event_AddAlarm", comment:"通知の追加")
        }

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let lastRow = self.editAlarmArray.count
        if tableView.isEditing && lastRow == indexPath.row {
            return .insert
        } else {
            return .delete
        }
    }
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.editAlarmArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            self.performSegue(withIdentifier: "editAlarmSegue", sender: self)
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "editAlarmSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if indexPath.row == self.editAlarmArray.count {
                    if let ctrl = segue.destination as? BzEditAlarmTableViewController {
                        ctrl.addAlarmDelegate = self
                    }
                } else {
                    let alm = self.editAlarmArray[indexPath.row]
                    if let ctrl = segue.destination as? BzEditAlarmTableViewController {
                        ctrl.addAlarmDelegate = self
                        ctrl.setupAlarm(alarm: alm)
                    }
                }
            }
        }
    }

    // MARK: - EditEKAlarmProtocol
    func add(alarm: EKAlarm) {
        if( self.editAlarmArray.contains(alarm) == false ) {
            self.editAlarmArray.append(alarm)
        }
        self.tableView.reloadData()
    }
    
    func replace(alarm originalAlarm: EKAlarm, with newAlarm: EKAlarm) {
        if let originalIdx = self.editAlarmArray.index(of: originalAlarm) {
            self.editAlarmArray[originalIdx] = newAlarm
        }
        self.tableView.reloadData()
    }
    

}
