//
//  BzEditWeekRecurrenceDateTblViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/08.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

//protocol RecurrenceDateForWeekChangeProtocol {
//    func weekRecurrenceDateChange(_ newDaysOfTheWeek:Array<EKRecurrenceDayOfWeek>)
//}

class BzEditWeekRecurrenceDateTblViewController: UITableViewController {

    // プライベート属性
    fileprivate var weekdayStringList : Array<String> = Array()
    fileprivate var selectedWeekdaySet : Set<EKWeekday> = Set()
    fileprivate var originalDaysOfTheWeek : Set<EKWeekday> = Set()

    // Public
    // ストーリーボードと接続
    @IBOutlet weak var doneButtonItem: UIBarButtonItem!
    @IBAction func doneClicked(_ sender: Any) {
        
        if let delegate = self.recurrenceDateChangeProtocol {
            delegate.weekRecurrenceDateChange(daysOfTheWeek: self.daysOfTheWeek())
        }
        self.navigationController?.popViewController(animated: true)
        
    }

    // パブリック（その他）
    var recurrenceDateChangeProtocol : BzRecurrenceDateForWeekChangeProtocol? = nil
    
    // daysOfTheWeek
    // 外部から編集対象のdaysOfTheWeekを設定する
    //  selectedWeekdaySetを編集対象のEKWeekdayのセットとして生成し、
    //  originalDaysOfTheWeekにもセットする。originalDaysOfTheWeekは以後変更しない事とする
    func daysOfTheWeek(array : Array<EKRecurrenceDayOfWeek>?) {
        self.selectedWeekdaySet = Set()
        if let array = array {
            for dayOfWeek in array {
                let weekday : EKWeekday = dayOfWeek.dayOfTheWeek; //EKWeekday
                self.selectedWeekdaySet.insert(weekday)
            }
        }
        self.originalDaysOfTheWeek = self.selectedWeekdaySet
        self.tableView.reloadData()
    }
    
    func daysOfTheWeek() -> Array<EKRecurrenceDayOfWeek> {
        var arr = Array(self.selectedWeekdaySet)
        arr.sort {
            return $0.rawValue > $1.rawValue
        }
        var rtnArray : Array<EKRecurrenceDayOfWeek> = Array()
        
        for weekday in arr {
            let newDayOfWeek = EKRecurrenceDayOfWeek(weekday)
            rtnArray.append(newDayOfWeek)
        }

        return rtnArray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("ViewTitle_Event_WeeklyRecurrenceDate", comment:"繰り返し日")
        self.doneButtonItem.isEnabled = false

        for item in CalendarManager.shared().weekdaySymbols() {
            if let weekdayString = item as? String {
                self.weekdayStringList.append(weekdayString)
            }
        }

    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weekdayStringList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weekdayCell", for: indexPath)

        cell.textLabel?.text = self.weekdayStringList[indexPath.row]
        cell.accessoryType = .none
        if let weekday = EKWeekday(rawValue: indexPath.row + 1) {
            if self.selectedWeekdaySet.contains(weekday) {
                cell.accessoryType = .checkmark
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let weekday  = EKWeekday(rawValue: indexPath.row + 1) else {
            return
        }
        if self.selectedWeekdaySet.contains(weekday) {
            self.selectedWeekdaySet.remove(weekday)
        } else {
            self.selectedWeekdaySet.insert(weekday)
        }
        
        if self.selectedWeekdaySet.elementsEqual(self.originalDaysOfTheWeek) {
            self.doneButtonItem.isEnabled = false
        } else {
            self.doneButtonItem.isEnabled = true
        }
        self.tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
