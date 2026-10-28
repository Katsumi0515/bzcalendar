//
//  BzCustomRecurrenceTblViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/09.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

protocol BzRecurrenceDateForMonthChangeProtocol {
    func monthRecurrenceDateChange(daysOfTheMonth:Array<NSNumber>?, daysOfTheWeek:Array<EKRecurrenceDayOfWeek>?)
}
protocol BzRecurrenceDateForWeekChangeProtocol {
    func weekRecurrenceDateChange(daysOfTheWeek:Array<EKRecurrenceDayOfWeek>?)
}
protocol BzRecurrenceDateForYearChangeProtocol {
    func yearRecurrenceDateChange(daysOfTheYear:Array<Any>)
}

class BzCustomRecurrenceTblViewController: UITableViewController,
    RecurrenceIntervalChangeProtocol,
    RecurrenceEndChangeProtocol,
    BzRecurrenceDateForWeekChangeProtocol,
    BzRecurrenceDateForMonthChangeProtocol,
    BzRecurrenceDateForYearChangeProtocol {

    fileprivate var weekNumStringList : Array<String> = Array()
    fileprivate var weekdayStringList : Array<String> = Array()
    
    fileprivate var daysOfTheWeek : Array<EKRecurrenceDayOfWeek>? = nil // element: EKRecurrenceDayOfWeek
//    fileprivate var daysOfTheMonth : Array<Int> = Array() // element: NSNumber(1 to 31, -1 to -31)
    fileprivate var daysOfTheMonth : Array<NSNumber>? = nil // element: NSNumber(1 to 31, -1 to -31)
    fileprivate var daysOfTheYear  : Array<NSNumber>? = nil
    
    fileprivate var monthsOfTheYear : Array<NSNumber>? = nil
    fileprivate var weeksOfTheYear : Array<NSNumber>? = nil
    fileprivate var setPositions : Array<NSNumber>? = nil

    @IBOutlet weak var doneButtonItem: UIBarButtonItem!
    
    @IBAction func doneClicked(_ sender: Any) {
        
        
        let newRecurrenceRule = EKRecurrenceRule(
            recurrenceWith: self.frequency,         //
            interval: self.interval,
            daysOfTheWeek: self.daysOfTheWeek,
            daysOfTheMonth: self.daysOfTheMonth,
            monthsOfTheYear: self.monthsOfTheYear,
            weeksOfTheYear: self.weeksOfTheYear,
            daysOfTheYear: self.daysOfTheYear,
            setPositions: self.setPositions,
            end: self.recurrenceEnd)

        if let delegate = self.recurrenceRuleProtocol {
            delegate.recurrenceRuleChange(newRecurrenceRule)
        }
        
        if let topViewController = self.topEditViewController  {
            self.navigationController?.popToViewController(topViewController, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }

    }
    
    @IBOutlet weak var cellForDayFreq: UITableViewCell!
    @IBOutlet weak var cellForWeekFreq: UITableViewCell!
    @IBOutlet weak var cellForMonthFreq: UITableViewCell!
    @IBOutlet weak var cellForYearFreq: UITableViewCell!
    
    @IBOutlet weak var cellForInterval: UITableViewCell!
    
    @IBOutlet weak var cellForEndDate: UITableViewCell!
    
    @IBOutlet weak var cellForRepeatDetail: UITableViewCell!
    
    fileprivate var editFrequency : EKRecurrenceFrequency = .daily
    //@property (nonatomic, retain) EKRecurrenceEnd* recurrenceEnd;
    fileprivate var recurrenceEnd : EKRecurrenceEnd? = nil
    
    var recurrenceRuleProtocol : RecurrenceRuleChangeProtocol? = nil
    var startDate : Date? = nil
    var targetCalendar : EKCalendar!

    var frequency : EKRecurrenceFrequency = .daily {
        didSet {
            self.editFrequency = frequency
        }
    }
    var interval : Int = 1
    fileprivate var originalRecurrenceRule : EKRecurrenceRule? = nil

    func setRecurrenceRule(recurrenceRule:EKRecurrenceRule?) {
        self.originalRecurrenceRule = recurrenceRule
        
        if let recurrenceRule = self.originalRecurrenceRule {
            // initWithArray:nil でも大丈夫？
            self.frequency = recurrenceRule.frequency;
            self.interval = recurrenceRule.interval;
            
            self.daysOfTheMonth = recurrenceRule.daysOfTheMonth
            //self.daysOfTheMonth = Array()
//            if let daysOfTheMonth = recurrenceRule.daysOfTheMonth {
//                for num in daysOfTheMonth {
//                    self.daysOfTheMonth.append(num.intValue)
//                }
//            }
            self.daysOfTheWeek = recurrenceRule.daysOfTheWeek
//            self.daysOfTheWeek = Array()
//            if let daysOfTheWeek = recurrenceRule.daysOfTheWeek {
//                self.daysOfTheWeek = daysOfTheWeek;
//            }
            self.daysOfTheYear = recurrenceRule.daysOfTheYear;
            
            self.recurrenceEnd = recurrenceRule.recurrenceEnd;
            self.monthsOfTheYear = recurrenceRule.monthsOfTheYear;
            self.weeksOfTheYear = recurrenceRule.weeksOfTheYear;
            self.setPositions = recurrenceRule.setPositions;
            // ToDo: setPositionsを想定していないので、編集モード作成時再度検討する
            //
            if( recurrenceRule.setPositions != nil ) {
                print("setPositions not supported!");
            }

        } else {
            // recurrenceRuleはnil
            self.frequency = .daily
            self.interval = 1
            
            self.daysOfTheMonth = nil;
            self.daysOfTheWeek = nil;
            self.daysOfTheYear = nil;
            
            self.recurrenceEnd = nil;
            self.monthsOfTheYear = nil;
            self.weeksOfTheYear = nil;
            self.setPositions = nil;

        }
    }
    var topEditViewController : UIViewController? = nil

    
    fileprivate func updateCells() {
        var intervalTailString = ""
        var daysString = ""

        self.cellForDayFreq.accessoryType = .none
        self.cellForWeekFreq.accessoryType = .none
        self.cellForMonthFreq.accessoryType = .none
        self.cellForYearFreq.accessoryType = .none
        
        switch( self.editFrequency ) {
        case .daily:
            intervalTailString = NSLocalizedString("Common_Event_Recurrence_ByDayInterval", comment:"日ごと")
            self.cellForDayFreq.accessoryType = .checkmark
        case .weekly:
            intervalTailString = NSLocalizedString("Common_Event_Recurrence_ByWeekInterval", comment:"週ごと")
            self.cellForWeekFreq.accessoryType = .checkmark
            var str = ""
            if let daysOfTheWeek = self.daysOfTheWeek {
                for dayOfWeek in daysOfTheWeek {
                    let weekdayRow = dayOfWeek.dayOfTheWeek.rawValue - 1;
                    //str = [str stringByAppendingFormat:@"%@ ", [weekdayStringList objectAtIndex:weekdayRow]];
                    str = str.appending(self.weekdayStringList[weekdayRow] + " ")
                }
            }
            daysString = str;
        case .monthly:
            intervalTailString = NSLocalizedString("Common_Event_Recurrence_ByMonthInterval", comment:"ヵ月ごと")
            self.cellForMonthFreq.accessoryType = .checkmark
            
            var str = ""
            if let daysOfTheMonth = self.daysOfTheMonth, daysOfTheMonth.count > 0  {
                let day = daysOfTheMonth[0]
                if day.intValue == -1  {
                    str = NSLocalizedString("Common_ExactWord_EndOfMonth", comment:"月末")
                } else {
                    str = String(day.intValue)
                }
                for idx in 1..<daysOfTheMonth.count {
                    let num = daysOfTheMonth[idx]
                    str = str.appending(", " + String(num.intValue))
                }
                str = str.appending(NSLocalizedString("CustomRecurrenceViewController_JapaneseWord_Nichi",
                                                      comment:"日"))
                
            } else if let daysOfTheWeek = self.daysOfTheWeek, daysOfTheWeek.count > 0 {
                let dayOfWeek : EKRecurrenceDayOfWeek = daysOfTheWeek[0]
                var weekNumRow = dayOfWeek.weekNumber - 1
                if weekNumRow == -2  {
                    weekNumRow = 4
                }
                let weekdayRow = dayOfWeek.dayOfTheWeek.rawValue - 1
                
                str = self.weekNumStringList[weekNumRow]
                str = str.appending(self.weekdayStringList[weekdayRow])
            }
            daysString = str;

        case .yearly:
            intervalTailString = NSLocalizedString("Common_Event_Recurrence_ByYearInterval", comment:"年ごと")
            self.cellForYearFreq.accessoryType = .checkmark
        }
        self.cellForInterval.detailTextLabel?.text =  String(self.interval).appending(intervalTailString)
        
        
        if let recurrenceEnd = self.recurrenceEnd {
            let str = recurrenceEnd.stringValue()
            self.cellForEndDate.detailTextLabel?.text = str
//            if( recurrenceEnd.endDate ) {
//                self.cellForEndDate.detailTextLabel?.text = str
//            } else {
//                self.cellForEndDate.detailTextLabel?.text = str
//            }
        } else {
            // self.recurrenceEnd == nil
            self.cellForEndDate.detailTextLabel?.text = NSLocalizedString("Common_Event_RecurrenceEnd_None", comment:"なし")
        }

        self.cellForRepeatDetail.detailTextLabel?.text = daysString
        
    }
    
    fileprivate func _resetTempRecurrenceRuleElementsForSelectedRow(frequency:EKRecurrenceFrequency) {
        self.frequency = frequency
        
        if let originalRecurrenceRule = self.originalRecurrenceRule {
            if( self.frequency == originalRecurrenceRule.frequency ) {
                self.interval = originalRecurrenceRule.interval;
                self.daysOfTheMonth = originalRecurrenceRule.daysOfTheMonth;
                self.daysOfTheWeek = originalRecurrenceRule.daysOfTheWeek;
                self.daysOfTheYear = originalRecurrenceRule.daysOfTheYear;
                self.recurrenceEnd = originalRecurrenceRule.recurrenceEnd;
                self.monthsOfTheYear = originalRecurrenceRule.monthsOfTheYear;
                self.weeksOfTheYear = originalRecurrenceRule.weeksOfTheYear;
                self.setPositions = originalRecurrenceRule.setPositions;
            } else {
                self.interval = 1;
                self.daysOfTheMonth = nil;
                self.daysOfTheWeek = nil;
                self.daysOfTheYear = nil;
                self.recurrenceEnd = nil;
                self.monthsOfTheYear = nil;
                self.weeksOfTheYear = nil;
                self.setPositions = nil;
                
                guard let appCalendar = CalendarManager.shared().appCalendar() else {
                    fatalError()
                }
                let comps = appCalendar.dateComponents([.day, .weekday], from: self.startDate!)
                
                switch (self.frequency) {
                case .weekly:
                    let weekday = EKWeekday(rawValue: comps.weekday!)
                    let dayOfTheWeek = EKRecurrenceDayOfWeek(weekday!)
                    self.daysOfTheWeek = Array()
                    self.daysOfTheWeek?.append(dayOfTheWeek)
                case .monthly:
                    self.daysOfTheMonth = Array()
                    let num = NSNumber(value:comps.day!)
                    self.daysOfTheMonth?.append(num)
                case .daily, .yearly:
                    break;
                }
                
            }
            
        } else {
            //originalRecurrenceRule is nil
            self.interval = 1;
            self.daysOfTheMonth = nil;
            self.daysOfTheWeek = nil;
            self.daysOfTheYear = nil;
            
            self.recurrenceEnd = nil;
            self.monthsOfTheYear = nil;
            self.weeksOfTheYear = nil;
            self.setPositions = nil;
            
            guard let appCalendar = CalendarManager.shared().appCalendar() else {
                fatalError()
            }
            let comps = appCalendar.dateComponents([.day, .weekday], from: self.startDate!)
            
            switch (self.frequency) {
            case .weekly:
                if let weekday = EKWeekday(rawValue: comps.weekday!) {
                    let dayOfTheWeek = EKRecurrenceDayOfWeek(weekday)
                    self.daysOfTheWeek = Array() //[NSArray arrayWithObject:dayOfTheWeek];
                    self.daysOfTheWeek?.append(dayOfTheWeek)
                }
            case .monthly:
                let num = NSNumber(value:comps.day!)
                self.daysOfTheMonth = Array()
                self.daysOfTheMonth?.append(num)
                break;
            case .daily, .yearly:
                break
            }
        }

    }
    // MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("ViewTitle_Event_CustomRecurrence", comment:"カスタム");
        if self.originalRecurrenceRule == nil {
            self.setRecurrenceRule(recurrenceRule: nil)
        }
        // ToDo: あちこちのクラスにある同じ週指定の文言を１クラスに集約したい
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
                if let weekday = array[idx] as? String {
                    self.weekdayStringList.append(weekday)
                }
            }
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        // section 0
        self.cellForDayFreq.textLabel?.text = NSLocalizedString("Common_Event_DayFrequency", comment:"日間隔")
        self.cellForWeekFreq.textLabel?.text = NSLocalizedString("Common_Event_WeekFrequency", comment:"週間隔")
        self.cellForMonthFreq.textLabel?.text = NSLocalizedString("Common_Event_MonthFrequency", comment:"月間隔")
        self.cellForYearFreq.textLabel?.text = NSLocalizedString("Common_Event_YearFrequency", comment:"年間隔")
        // section 1
        self.cellForInterval.textLabel?.text = NSLocalizedString("Common_Event_RecurrenceInterval", comment:"繰り返し間隔")
        self.cellForEndDate.textLabel?.text = NSLocalizedString("Common_Event_RecurrenceEnd", comment:"期限")
        // section 2
        self.cellForRepeatDetail.textLabel?.text = NSLocalizedString("Common_Event_RecurrenceDate", comment:"繰り返し日")

        print("self.frequency.rawValue: ", self.frequency.rawValue)
        
        self.updateCells()
        self.tableView.reloadData()
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        switch (self.frequency) {
        case .daily, .yearly:
            return 2
        case .weekly, .monthly:
            return 3
        }
    }
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

    fileprivate func row(frequency:EKRecurrenceFrequency) -> Int {
        switch (frequency) {
        case .daily:
            return 0
        case .weekly:
            return 1
        case .monthly:
            return 2
        case .yearly:
            return 3
        }

    }
    fileprivate func frequency(row:Int) -> EKRecurrenceFrequency {
        switch (row) {
        case 0:
            return .daily
        case 1:
            return .weekly
        case 2:
            return .monthly
        case 3:
            return .yearly
        default:
            return .daily
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            // 間隔を選択した
            if self.row(frequency: self.frequency) != indexPath.row  {
                let newFreq = self.frequency(row: indexPath.row)
                self._resetTempRecurrenceRuleElementsForSelectedRow(frequency: newFreq)
                self.updateCells()
            }
            self.tableView.reloadData()
            return
        }
        
        if indexPath.section == 2, indexPath.row == 0 {
            switch( self.frequency ) {
            case .monthly:
                self.performSegue(withIdentifier: "editMonthRecurrenceSegue", sender: self)
                break
            case .weekly:
                self.performSegue(withIdentifier: "editWeekRecurrenceSegue", sender: self)
                break
            case .daily, .yearly:
                break
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "editIntervalSegue" {
            guard let slctNumCtrl = segue.destination as? BzEditRecurrenceIntervalTblViewController else {
                fatalError()
            }
            
            slctNumCtrl.selectedInterval = self.interval;
            slctNumCtrl.intervalDelegate = self;

            return
        }
        if segue.identifier == "editRecurrenceEndSegue" {
            guard let slctRecEndCtrl = segue.destination as? BzEditRecurrenceEndTblViewController else {
                fatalError()
            }
            slctRecEndCtrl.startDate = self.startDate;
            slctRecEndCtrl.recurrenceEndProtocol = self;
            
            if let recurrenceEnd = self.recurrenceEnd {
                slctRecEndCtrl.recurrenceEndDate = recurrenceEnd.endDate;
                slctRecEndCtrl.occurrenceCount = recurrenceEnd.occurrenceCount;

            } else {
                slctRecEndCtrl.recurrenceEndDate = nil;
                slctRecEndCtrl.occurrenceCount = 0;
            }
            return
        }
        if segue.identifier == "editWeekRecurrenceSegue" {
            guard let weekCtrl = segue.destination as? BzEditWeekRecurrenceDateTblViewController else {
                fatalError()
            }
            weekCtrl.recurrenceDateChangeProtocol = self
            weekCtrl.daysOfTheWeek(array: daysOfTheWeek)
            
        }
        if segue.identifier == "editMonthRecurrenceSegue" {
            guard let dateCtrl = segue.destination as? BzEditMonthRecurrenceDateTblViewController else {
                fatalError()
            }
            // ToDo: このIF分をやらないとエラーになることを回避するようにする
            //          => daysOfTheMonthがある時はdaysOfTheWeekはnilになっていなくてはならない
            if let daysOfTheMonth = self.daysOfTheMonth,  daysOfTheMonth.count > 0  {
                dateCtrl.daysOfTheMonth(array: daysOfTheMonth as NSArray)
                dateCtrl.daysOfTheWeek(array: nil)
            } else if let daysOfTheWeek = self.daysOfTheWeek, daysOfTheWeek.count > 0  {
                dateCtrl.daysOfTheMonth(array: nil)
                dateCtrl.daysOfTheWeek(array: daysOfTheWeek as NSArray)
            }
            dateCtrl.targetCalendar = self.targetCalendar;
            dateCtrl.recurrenceDateChangeProtocol = self;

            return
        }

    }

}

extension BzCustomRecurrenceTblViewController {
    // MARK:- RecurrenceIntervalChangeProtocol
    func setRecurrenceInterval(_ interval: Int) {
        self.interval = interval
    }

    // MARK:-  RecurrenceEndChangeProtocol
    func setRecurrenceEndWidhEndDate(_ date: Date?, occurenceCount count: Int) {
        if let date = date  {
            self.recurrenceEnd = EKRecurrenceEnd(end: date)
        } else if ( count > 0 ) {
            self.recurrenceEnd = EKRecurrenceEnd(occurrenceCount: Int(count))
        } else {
            self.recurrenceEnd = nil;
        }
        self.tableView.reloadData()
    }

    // MARK:- RecurrenceDateForWeekChangeProtocol
    func weekRecurrenceDateChange(daysOfTheWeek:Array<EKRecurrenceDayOfWeek>?) {
        self.daysOfTheWeek = daysOfTheWeek
        
        //[self _updateCurrentRecurrenceRule];
        self.tableView.reloadData()
    }

    // MARK:- RecurrenceDateForMonthChangeProtocol
    func monthRecurrenceDateChange(daysOfTheMonth:Array<NSNumber>?, daysOfTheWeek:Array<EKRecurrenceDayOfWeek>?) {
        self.daysOfTheMonth = daysOfTheMonth
        self.daysOfTheWeek = daysOfTheWeek
        //[self _updateCurrentRecurrenceRule];
        self.updateCells()
        self.tableView.reloadData()

    }
    func monthRecurrenceDateChangeDays(ofTheMonth newDaysOfTheMonth: [Any]!, weekOfTheMonth newDaysOfTheWeek: [Any]!) {
        
        //self.daysOfTheMonth = Array(newDaysOfTheMonth)
        //self.daysOfTheWeek = [NSMutableArray arrayWithArray:newDaysOfTheWeek];
        //[self _updateCurrentRecurrenceRule];
        
        self.tableView.reloadData()
    }
    // MARK:- BzRecurrenceDateForYearChangeProtocol
    func yearRecurrenceDateChange(daysOfTheYear: Array<Any>) {
        
    }
}
