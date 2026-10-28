//
//  BzEditRecurrenceIntervalTblViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/08.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

protocol RecurrenceIntervalChangeProtocol {
    func setRecurrenceInterval(_ interval:Int)
}

class BzEditRecurrenceIntervalTblViewController: UITableViewController,
UIPickerViewDataSource, UIPickerViewDelegate {

    var intervalDelegate : RecurrenceIntervalChangeProtocol?  = nil
    var selectedInterval : Int = 0
    var numberUnitString : String = ""
    
    fileprivate let minInterval : Int = 1
    fileprivate let maxInterval : Int = 100

    @IBAction func doneClicked(_ sender: Any) {
        if let delegate = self.intervalDelegate {
            delegate.setRecurrenceInterval(self.selectedInterval)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var cellForInterval: UITableViewCell!
    
    @IBOutlet weak var numberPickerView: UIPickerView!
    
    fileprivate func updateCell() {
        let num = self.numberPickerView.selectedRow(inComponent: 0) + 1
        var str = String(num)
        if self.numberUnitString.isEmpty == false {
            str = str.appending(" " + self.numberUnitString)
        }
        self.cellForInterval.detailTextLabel?.text = String(num)
        self.cellForInterval.setNeedsLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("ViewTitle_Event_Interval",
                                       comment:"間隔数の決定")

        self.cellForInterval.textLabel?.text = NSLocalizedString("Common_Event_RecurrenceInterval", comment:"繰り返し間隔")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        
        if self.selectedInterval > 0 {
            self.numberPickerView.selectRow(self.selectedInterval - 1, inComponent: 0, animated: true)
        } else {
            self.numberPickerView.selectRow(0, inComponent: 0, animated: true)
        }
        self.updateCell()
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (self.maxInterval - self.minInterval) + 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row+1)
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let num = self.numberPickerView.selectedRow(inComponent: 0) + 1
        self.selectedInterval = num
        self.updateCell()
    }

}
