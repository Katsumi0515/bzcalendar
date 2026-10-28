//
//  BzEditMonthRecurrenceDateTblViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/09.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

protocol BzRecurrenceDaysOfTheMonthChangedDelegate {
    func daysOfTheMonthChanged(array:Array<Int>)
}

protocol BzRecurrenceDaysOfWeekChangeDelegate {
    func daysOfTheWeekChanged(array:Array<EKRecurrenceDayOfWeek>)
}

class BzEditMonthRecurrenceDateTblViewController: UITableViewController,
BzRecurrenceDaysOfTheMonthChangedDelegate, BzRecurrenceDaysOfWeekChangeDelegate {
    
    var recurrenceDateChangeProtocol : BzRecurrenceDateForMonthChangeProtocol? = nil
    

    fileprivate var selectedPathForSectionZero : IndexPath? = nil //IndexPath(row: 0, section: 0)
    fileprivate var daysOfTheMonth : Array<Int> = Array()
    fileprivate var daysOfTheWeek  : Array<EKRecurrenceDayOfWeek> = Array()


    fileprivate var endOfMonthCanBeSet : Bool = false
    fileprivate var weekNumStringList : Array<String> = Array()
    fileprivate var weekdayStringList : Array<String> = Array()
    
    var targetCalendar : EKCalendar? = nil {
        didSet {
            endOfMonthCanBeSet = false
            if let calendar = targetCalendar {
                if calendar.type == .local || calendar.type == .calDAV {
                    endOfMonthCanBeSet = true
                }
            }
        }
    }

    @IBOutlet weak var doneButtonItem: UIBarButtonItem!
    @IBAction func doneClicked(_ sender: Any) {

        guard let selectedPathForSectionZero = self.selectedPathForSectionZero else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        if let delegate = self.recurrenceDateChangeProtocol {
            var newDaysOfTheMonth : Array<
            NSNumber>? = nil
            var newDaysOfTheWeek  : Array<EKRecurrenceDayOfWeek>? = nil
            
            switch (selectedPathForSectionZero.row) {
            case 0:
                // 日付指定なので、曜日設定はnilに
                newDaysOfTheMonth = Array()
                for idx in 0..<self.daysOfTheMonth.count {
                    let num = NSNumber(value:self.daysOfTheMonth[idx])
                    newDaysOfTheMonth?.append(num)
                }
                newDaysOfTheWeek = nil
            case 1:
                newDaysOfTheMonth = Array()
                newDaysOfTheMonth?.append(NSNumber(value:-1))
                newDaysOfTheWeek = nil;
            case 2:
                newDaysOfTheMonth = nil;
                newDaysOfTheWeek = Array(self.daysOfTheWeek)
            default:
                break;
            }
            delegate.monthRecurrenceDateChange(daysOfTheMonth: newDaysOfTheMonth, daysOfTheWeek: newDaysOfTheWeek)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var cellForByDate: UITableViewCell!
    
    
    @IBOutlet weak var cellForEndOfMonth: UITableViewCell!
    
    @IBOutlet weak var cellForByWeekday: UITableViewCell!
    
    @IBOutlet weak var cellForDetail: UITableViewCell!
    
    
    fileprivate func _setDefaultSelectedPath() {
        var isEndOfMonth = false
        
        if self.daysOfTheMonth.count > 0 {
            for day in self.daysOfTheMonth {
                if day <= 0 {
                    isEndOfMonth = true
                    break
                }
            }
            if isEndOfMonth == false {
                self.selectedPathForSectionZero = IndexPath(row: 0, section: 0)
            } else {
                self.selectedPathForSectionZero = IndexPath(row: 1, section: 0)
            }
        } else {
            self.selectedPathForSectionZero = IndexPath(row: 2, section: 0)
        }
    }
    
    func daysOfTheMonth(array:NSArray?) {
        self.daysOfTheMonth = Array()
        if let array = array {
            for item in array {
                if let num = item as? NSNumber {
                    self.daysOfTheMonth.append(num.intValue)
                }
            }
            self.daysOfTheMonth.sort {
                return $0 > $1
            }
        }
        self.tableView.reloadData()
    }
    
    func daysOfTheWeek(array:NSArray?) {
        self.daysOfTheWeek = Array()
        if let array = array {
            for item in array {
                if let recDayOfWeek = item as? EKRecurrenceDayOfWeek {
                    self.daysOfTheWeek.append(recDayOfWeek)
                }
            }
        }
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("ViewTitle_Event_MonthlyRecurrenceDate",
                                       comment:"繰り返し日");

        self.weekNumStringList = [
            NSLocalizedString("Common_Event_RecurrenceDateByWeekday_First", comment:"第１"),
            NSLocalizedString("Common_Event_RecurrenceDateByWeekday_Second", comment:"第２"),
            NSLocalizedString("Common_Event_RecurrenceDateByWeekday_Third", comment:"第３"),
            NSLocalizedString("Common_Event_RecurrenceDateByWeekday_Fourth", comment:"第４"),
            NSLocalizedString("Common_Event_RecurrenceDateByWeekday_Last", comment:"最終")
        ]
        
        self.weekdayStringList = Array()
        if let array = CalendarManager.shared().weekdaySymbols() {
            for idx in 0..<array.count {
                if let item = array[idx] as? String {
                self.weekdayStringList.append(item)
                }
            }
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.cellForByDate.textLabel?.text = NSLocalizedString("Common_Event_MonthRecurrenceDate_ByDate", comment:"日付指定")
        self.cellForEndOfMonth.textLabel?.text = NSLocalizedString("Common_Event_MonthRecurrenceDate_EndOfMonth", comment:"月末")
        self.cellForByWeekday.textLabel?.text = NSLocalizedString("Common_Event_MonthRecurrenceDate_ByWeekday", comment:"曜日指定")
        self.cellForDetail.textLabel?.text = NSLocalizedString("Common_Event_Recurrence_Detail", comment:"詳細")
        
        if self.selectedPathForSectionZero == nil {
            self._setDefaultSelectedPath()
        }
        self.tableView.reloadData()
        super.viewWillAppear(animated)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let selectedPath = self.selectedPathForSectionZero else {
            return 0
        }
        switch (selectedPath.row) {
        case 1:
            return 1
        case 0, 2:
            return 2
        default:
            return 1
        }        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0  {
            return 3
        } else if section == 1  {
            return 1
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        // Configure the cell...
        if indexPath.section == 0 {
            cell.accessoryType = .none
            if let selectedPathForSectionZero = self.selectedPathForSectionZero {
                if indexPath.row == selectedPathForSectionZero.row {
                    cell.accessoryType = .checkmark
                }
            }
            //if self.endOfMonthCanBeSet {
            if self.targetCalendar?.type == .local || self.targetCalendar?.type == .calDAV {
                cell.textLabel?.textColor = UIColor.black
                cell.isEditing = true
            } else {
                // subscription, exchange, birthday
                cell.textLabel?.textColor = UIColor.lightGray
                cell.isEditing = false
            }
            return cell
        }
        cell.detailTextLabel?.text = ""
        guard let selectedPathForSectionZero = self.selectedPathForSectionZero else {
            return cell
        }
        // indexPath.section > 0
        
        if selectedPathForSectionZero.row == 0 {
            if daysOfTheMonth.count < 1 {
                cell.detailTextLabel?.text = ""
            } else {
                var str : String = ""
                let num = daysOfTheMonth[0]
                if( num == -1 ) {
                    str = NSLocalizedString("Common_ExactWord_EndOfMonth", comment:"月末")
                } else  {
                    str = String(num)
                }
                for idx in 1 ..< self.daysOfTheMonth.count {
                    let nextNum = self.daysOfTheMonth[idx]
                    if nextNum == -1 {
                        str = str.appending(", " + NSLocalizedString("Common_ExactWord_EndOfMonth", comment:"月末"))
                    } else {
                        str = str.appending(", " + String(nextNum))
                    }
                }
                cell.detailTextLabel?.text = str
            }
        } else if selectedPathForSectionZero.row == 2 {
            if self.daysOfTheWeek.count < 1 {
                //self._setDefaultDaysOfTheWeek()
                
            } else {
                let dayOfWeek = self.daysOfTheWeek[0] //EKRecurrenceDayOfWeek
                var weekNumRow : Int = dayOfWeek.weekNumber - 1
                let weekdayRow : Int = dayOfWeek.dayOfTheWeek.rawValue - 1
                if( weekNumRow == -2 ) {
                    weekNumRow = 4
                }
                var str = self.weekNumStringList[weekNumRow]
                str = str.appending(self.weekdayStringList[weekdayRow])
                
                for idx in 1 ..< self.daysOfTheWeek.count {
                    let dayOfWeek = self.daysOfTheWeek[idx]
                    var weekNumRow : Int = dayOfWeek.weekNumber - 1
                    let weekdayRow : Int = dayOfWeek.dayOfTheWeek.rawValue - 1
                    if( weekNumRow == -2 ) {
                        weekNumRow = 4
                    }
                    var nextString = ", " + self.weekNumStringList[weekNumRow]
                    nextString = nextString.appending(self.weekdayStringList[weekdayRow])
                    str = str.appending(nextString)
                }

                cell.detailTextLabel?.text = str

            }
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section != 0 {
            return nil
        }
        guard let calendar = self.targetCalendar else {
            return nil
        }

        if calendar.type != .local && calendar.type != .calDAV {
            return NSLocalizedString("SectionHeaderTitle_CustomRecurrence_EndOfMonth",
                                     comment:"月末を有効にするにはアカウントの設定をGMailで行ってください。")
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0  {
            if let selectedPathForSectionZero = self.selectedPathForSectionZero {
                if indexPath.row != selectedPathForSectionZero.row  {
                    self.selectedPathForSectionZero = indexPath
                }
            } else {
                self.selectedPathForSectionZero = indexPath
            }
            self.tableView.reloadData()
        } else if indexPath.section == 1  {
            guard let selectedPathForSectionZero = self.selectedPathForSectionZero else {
                return
            }
            let storyboard = UIStoryboard(name: "Event", bundle: nil)

            switch (selectedPathForSectionZero.row) {
            case 0:
                if let ctrl = storyboard.instantiateViewController(withIdentifier: "BzEditRecurrenceDateByDatesTblViewController") as? BzEditRecurrenceDateByDatesTblViewController {
                    
                    ctrl.recurrenceDateChangeProtocol = self
                    ctrl.daysOfTheMonth(array: self.daysOfTheMonth)
                    ctrl.canSelectEndOfMonth = self.endOfMonthCanBeSet
                    self.navigationController?.pushViewController(ctrl, animated: true)
                }
            case 2:
                if let ctrl = storyboard.instantiateViewController(withIdentifier: "BzRecurrenceDateByWeeksTblViewController") as? BzRecurrenceDateByWeeksTblViewController {
                    ctrl.recurrenceDaysOfWeekProtocol = self;
                    ctrl.daysOfTheWeek(array: self.daysOfTheWeek)
                    self.navigationController?.pushViewController(ctrl, animated: true)
                }
                //let ctrl = AddRecurrenceDateByWeeksViewController()
            default:
                break;
            }
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - BzRecurrenceDaysOfTheMonthChangedDelegate
    func daysOfTheMonthChanged(array: Array<Int>) {
        self.daysOfTheMonth = array
    }
    // MARK: - BzRecurrenceDaysOfWeekChangeDelegate
    func daysOfTheWeekChanged(array: Array<EKRecurrenceDayOfWeek>) {
        self.daysOfTheWeek = array
    }

}
