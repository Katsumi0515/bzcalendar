//
//  BzEditRecurrenceEndTblViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/08.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

protocol RecurrenceEndChangeProtocol {
    // ToDo: EndDateはオプショナルなので、メソッドの名前を再考する
    func setRecurrenceEndWidhEndDate(_ date:Date?, occurenceCount:Int)
}

class BzEditRecurrenceEndTblViewController: UITableViewController,
UIPickerViewDataSource, UIPickerViewDelegate {

    var recurrenceEndProtocol : RecurrenceEndChangeProtocol? = nil
    var startDate : Date!
    var recurrenceEndDate : Date? = nil
    var occurrenceCount : Int = 0

    @IBAction func doneClicked(_ sender: Any) {
        if let delegate = self.recurrenceEndProtocol {
            var rtnDate : Date? = nil
            var rtnCount : Int = 0
            if let selectedPath = self.selectedPath {
                if selectedPath.section == 1 {
                    rtnDate = self.datePicker.date
                } else if selectedPath.section == 2 {
                    rtnCount = Int(self.numberPicker.selectedRow(inComponent: 0)) + 1
                }
            }
            delegate.setRecurrenceEndWidhEndDate(rtnDate, occurenceCount: rtnCount)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var cellForNone: UITableViewCell!
    
    @IBOutlet weak var cellForDate: UITableViewCell!
    @IBOutlet weak var cellForCount: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var numberPicker: UIPickerView!
    
    
    @IBAction func datePicked(_ sender: Any) {
        let date = self.datePicker.date
        let str = self.dateFormatter?.string(from: date)
        
        self.cellForDate.detailTextLabel?.text = str
    }
    
    fileprivate var selectedPath : IndexPath? = nil
    
    fileprivate var dateFormatter : DateFormatter? = nil
    
    fileprivate func updateCells() {
        cellForDate.detailTextLabel?.text = ""
        cellForCount.detailTextLabel?.text = ""
        if let selectedPath = self.selectedPath {
            if selectedPath.section == 1 {
                let date = self.datePicker.date
                let str = self.dateFormatter?.string(from: date)
                
                self.cellForDate.detailTextLabel?.text = str
            } else if selectedPath.section == 2 {
                let num = self.numberPicker.selectedRow(inComponent: 0) + 1
                let str = String(num).appending(NSLocalizedString("SelectRecurrenceEnd_Times", comment:"回"))
                self.cellForCount.detailTextLabel?.text = str

            }
        }
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("ViewTitle_Event_RecurrenceEnd", comment:"期限");

        self.cellForNone.textLabel?.text = NSLocalizedString("Common_Event_RecurrenceEnd_None", comment:"なし")
        self.cellForDate.textLabel?.text = NSLocalizedString("SelectRecurrenceEnd_ByDate", comment:"日付")
        self.cellForCount.textLabel?.text = NSLocalizedString("SelectRecurrenceEnd_ByCount",comment:"回数")
        
        self.dateFormatter = CalendarManager.shared().dateFormatter_fullStyle()
        //[[CalendarManager sharedManager] dateFormatter_fullStyle];

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        self.datePicker.minimumDate = self.startDate
        if let endDate = self.recurrenceEndDate {
            self.datePicker.date = endDate
            self.selectedPath = IndexPath(row: 0, section: 1)
        } else if self.occurrenceCount > 0 {
            self.numberPicker.selectRow(self.occurrenceCount - 1, inComponent: 0, animated: true)
            self.selectedPath = IndexPath(row: 0, section: 2)
        }
        self.updateCells()
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if let indexPath = self.tableView.indexPathForSelectedRow {
            if indexPath.section == section {
                return 2
            }
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.accessoryType = .none
        if let selectedIndex = self.selectedPath {
            if  indexPath.section == selectedIndex.section && indexPath.row == 0 {
                cell.accessoryType = .checkmark
            }
        }
        return cell
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPath = indexPath
        self.updateCells()
        if let selectedPath = self.selectedPath {
            self.tableView.selectRow(at: selectedPath, animated: true, scrollPosition: .none)
        }
    }
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
        return 100
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row+1)
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let num = self.numberPicker.selectedRow(inComponent: 0) + 1
        let str = String(num).appending(NSLocalizedString("SelectRecurrenceEnd_Times", comment:"回"))
        self.cellForCount.detailTextLabel?.text = str
    }

}
