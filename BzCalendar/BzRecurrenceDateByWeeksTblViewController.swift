//
//  BzRecurrenceDateByWeeksTblViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/09.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzRecurrenceDateByWeeksTblViewController: UITableViewController,
UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var doneButtonItem: UIBarButtonItem!
    
    @IBAction func doneClicked(_ sender: Any) {
        if let delegate = self.recurrenceDaysOfWeekProtocol {

            var weekNum = self.weekPickerView.selectedRow(inComponent: 0) + 1
            if( weekNum == 5 ) {
                weekNum = -1
            }
            
            let weekdayNum = self.weekPickerView.selectedRow(inComponent: 1) + 1
            if let weekday = EKWeekday(rawValue: weekdayNum) {
                let dayOfWeek = EKRecurrenceDayOfWeek.init(weekday, weekNumber: weekNum)
                self.daysOfTheWeek = Array()
                self.daysOfTheWeek.append(dayOfWeek)
                delegate.daysOfTheWeekChanged(array: self.daysOfTheWeek)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var cellForSelectedWeek: UITableViewCell!
    
    @IBOutlet weak var weekPickerView: UIPickerView!
    fileprivate var daysOfTheWeek : Array<EKRecurrenceDayOfWeek> = Array()
    fileprivate var weekNumStringList : Array<String> = Array()
    fileprivate var weekdayStringList : Array<String> = Array()
    
    func daysOfTheWeek(array:Array<EKRecurrenceDayOfWeek>) {
        self.daysOfTheWeek = Array(array)
    }
    var recurrenceDaysOfWeekProtocol : BzRecurrenceDaysOfWeekChangeDelegate?  = nil

    fileprivate func updateCellForSelectedWeek() {
        let weekNumRow = self.weekPickerView.selectedRow(inComponent: 0)
        let weekdayRow = self.weekPickerView.selectedRow(inComponent: 1)
        
        var str = self.weekNumStringList[weekNumRow]
        str.append(self.weekdayStringList[weekdayRow])
        
        self.cellForSelectedWeek.textLabel?.text = str
        self.cellForSelectedWeek.setNeedsLayout()
    }
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("ViewTitle_Event_RecurrenceDateByWeeks", comment:"曜日指定")
        
        self.weekNumStringList = [
            NSLocalizedString("Common_Event_RecurrenceDateByWeekday_First", comment:"第１"),
            NSLocalizedString("Common_Event_RecurrenceDateByWeekday_Second", comment:"第２"),
            NSLocalizedString("Common_Event_RecurrenceDateByWeekday_Third", comment:"第３"),
            NSLocalizedString("Common_Event_RecurrenceDateByWeekday_Fourth", comment:"第４"),
            NSLocalizedString("Common_Event_RecurrenceDateByWeekday_Last", comment:"最終")
        ]
        
        if let weekdaySymbols = CalendarManager.shared().weekdaySymbols() {
            self.weekdayStringList = Array()
            for idx in 0..<weekdaySymbols.count {
                if let str = weekdaySymbols[idx] as? String {
                    self.weekdayStringList.append(str)
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        for dayOfWeek in self.daysOfTheWeek {
            var weekRow = dayOfWeek.weekNumber - 1
            if( weekRow == -2 ) {
                weekRow = 4;
            }
            let weekdayRow = dayOfWeek.dayOfTheWeek.rawValue - 1
            
            self.weekPickerView.selectRow(weekRow, inComponent: 0, animated: true)
            self.weekPickerView.selectRow(weekdayRow, inComponent: 1, animated: true)
        }
        self.updateCellForSelectedWeek()
        self.tableView.reloadData()

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
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch (component) {
        case 0:
            return self.weekNumStringList.count
        case 1:
            return self.weekdayStringList.count
        default:
            break;
        }
        return 0
    }

    // MARK: - UIPickerViewDelegate
    //func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat
    
    //func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    
    
    // these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
    // for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
    // If you return back a different object, the old one will be released. the view will be centered in the row rect
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch (component) {
        case 0:
            return self.weekNumStringList[row]
        case 1:
            return self.weekdayStringList[row]
        default:
            break;
        }
        return nil
    }
    
    //func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? // attributed title is favored if both methods are implemented
    
    //func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.updateCellForSelectedWeek()
        
        self.tableView.reloadData()
    }
}
