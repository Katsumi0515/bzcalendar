//
//  BzEventDateViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/05.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

protocol BzEventDateViewControllerDelegate {
    func eventStartDateChange(newStartDate:Date)
    func eventEndDateChange(newEndDate:Date)
    func eventAllDayChange(newAllDay:Bool)
}

class BzEventDateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate let dateFormatter = DateFormatter()
    fileprivate let timeFormatter = DateFormatter()
    fileprivate var lastIndex : IndexPath? = nil
    
    var editStartDate: Date!
    var editEndDate:   Date!
    var editAllday: Bool = false
    
    var eventDateChangeProtocol : BzEventDateViewControllerDelegate? = nil

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate func updateDateFormatter() {
        if self.editAllday == true {
            //[dateFormatter setDateFormat:kDateFormatString];
            dateFormatter.dateStyle =  .full;
            dateFormatter.timeStyle = .none;
            timeFormatter.dateStyle = .none
            timeFormatter.timeStyle = .none
            
        } else {
            //[dateFormatter setDateFormat:kDateTimeFormatString];
            dateFormatter.dateStyle =  .full;
            dateFormatter.timeStyle = .none;
            timeFormatter.dateStyle = .none;
            timeFormatter.timeStyle = .short
            
        }
    }
    
    @IBAction func alldaySwitchChanged(_ alldaySwitch: UISwitch) {
        
        self.editAllday = alldaySwitch.isOn
        
        if alldaySwitch.isOn == true {
            self.datePicker.datePickerMode = .date;
        } else {
            datePicker.datePickerMode = .dateAndTime;
        }
        
        self.updateDateFormatter()
        self.tableView.reloadData()
        
        if let lastIndex = self.lastIndex {
            if lastIndex.row == 2 {
                self.datePicker.isEnabled = false
            } else {
                self.datePicker.isEnabled = true
            }
            self.tableView.selectRow(at: lastIndex, animated: true, scrollPosition: .none)

        }
        
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        
        if let changeDelegate = self.eventDateChangeProtocol {
            changeDelegate.eventStartDateChange(newStartDate:self.editStartDate)
            changeDelegate.eventEndDateChange(newEndDate: self.editEndDate)
            changeDelegate.eventAllDayChange(newAllDay: self.editAllday)
        }
        self.navigationController?.popViewController(animated: true)
    }
        
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBAction func datePickerChanged(_ sender: Any) {
        
        guard let lastIndex = self.lastIndex else {
            return
        }
        let row = lastIndex.row
        
        guard let appCalendar = CalendarManager.shared().appCalendar() else {
            return
        }
        
        let calendarCompSet : Set<Calendar.Component> = [.year, .month, .day, .hour, .minute]
        
        //NSUInteger unitFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
        //    NSCalendarUnitHour | NSCalendarUnitMinute;
        
        // 開始日　< 終了日　とならない場合はもとの時間差をキープするように日時をセットする
        //NSDateComponents* comps = nil;
        
        
        switch (row) {
        case 0:
            guard let oldStartDate = self.editStartDate else {
                return
            }
            self.editStartDate = self.datePicker.date
            if self.editAllday == true  {
                // 同じ日時でもOK(allDayなので）
                if self.editStartDate.compare(self.editEndDate) == .orderedDescending {
                    var comps = appCalendar.dateComponents(calendarCompSet, from: oldStartDate, to:self.editEndDate)
                    comps.hour = 0
                    comps.minute = 0
                    let tmpDate = appCalendar.date(byAdding: comps, to: self.editStartDate)
                    self.editEndDate = tmpDate
                }
            } else {
                let comps = appCalendar.dateComponents(calendarCompSet, from: oldStartDate, to:self.editEndDate)
                let tmpDate = appCalendar.date(byAdding: comps, to: self.editStartDate)
                self.editEndDate = tmpDate
            }
        case 1:
            guard let oldEndDate = self.editEndDate else {
                return
            }

            self.editEndDate = self.datePicker.date
            if self.editAllday == true {
                if self.editStartDate.compare(self.editEndDate) == .orderedDescending {
                    var comps = appCalendar.dateComponents(calendarCompSet, from: oldEndDate, to:self.editStartDate)
                    comps.hour = 0
                    comps.minute = 0
                    let tmpDate = appCalendar.date(byAdding: comps, to: self.editEndDate)
                    self.editStartDate = tmpDate
                }
                
            } else {
                let result = self.editStartDate.compare(self.editEndDate)
                if result == .orderedDescending {
                    let comps = appCalendar.dateComponents(calendarCompSet, from: oldEndDate, to:self.editStartDate)
                    let tmpDate = appCalendar.date(byAdding: comps, to: self.editEndDate)
                    self.editStartDate = tmpDate
                } else if result == .orderedSame {
                    // startとendが同じ時間では保存できない？
                    var comps = DateComponents()
                    comps.second = 1
                    self.editEndDate = appCalendar.date(byAdding: comps, to: self.editEndDate)
                }
            }
        default:
            break;
        }
        
        self.tableView.reloadData()
        
        self.tableView.selectRow(at: lastIndex, animated: true, scrollPosition: .none)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("ViewTitle_Event_StartAndEnd",
                                       comment:"開始と終了");

        self.datePicker.isEnabled = false
        
        // ToDo:- 設定からロケールを取得
        let local = NSLocale.current
        
        self.datePicker.locale = local
        self.updateDateFormatter()


        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if self.lastIndex == nil {
            if self.editAllday == true {
                self.lastIndex = IndexPath(row: 2, section: 0)
            } else {
                self.lastIndex = IndexPath(row: 0, section: 0)
            }
            self.tableView.selectRow(at: self.lastIndex!, animated: true, scrollPosition: .top)
        }
        self.updateDatePicker()
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK:-
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "startTimeCell", for: indexPath)
            cell.textLabel?.text = NSLocalizedString("Common_ExactWord_Start", comment:"開始")
            var text = self.dateFormatter.string(from: self.editStartDate)
            let timeText = self.timeFormatter.string(from: self.editStartDate)
            if timeText.isEmpty == false {
                text = text + " " + timeText
            }
            cell.detailTextLabel?.text = text
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier:  "endTimeCell", for: indexPath)
            cell.textLabel?.text = NSLocalizedString("Common_ExactWord_End", comment:"終了")
            var text = self.dateFormatter.string(from: self.editEndDate)
            let timeText = self.timeFormatter.string(from: self.editEndDate)
            if timeText.isEmpty == false {
                text = text + " " + timeText
            }
            cell.detailTextLabel?.text = text
            return cell
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier:  "alldayCell", for: indexPath) as? BzAlldayTableViewCell {
                cell.alldayLabel?.text = NSLocalizedString("Common_ExactWord_AllDay", comment:"終日")
                cell.alldaySwitch.isOn = self.editAllday
                cell.detailTextLabel?.text = "allday value"
                return cell
            }
            fallthrough
        default:
            print("dummy")
        }
        fatalError()
    }
    
    fileprivate func updateDatePicker() {
        guard let indexPath = self.lastIndex else {
            return
        }
        if indexPath.row == 0 {
            self.datePicker.isEnabled = true
            self.datePicker.date = self.editStartDate
        } else if indexPath.row == 1 {
            self.datePicker.isEnabled = true
            self.datePicker.date = self.editEndDate
        } else {
            self.datePicker.isEnabled = false
        }
        self.datePicker.setNeedsLayout()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.lastIndex = indexPath
        self.updateDatePicker()
    }
    
}
