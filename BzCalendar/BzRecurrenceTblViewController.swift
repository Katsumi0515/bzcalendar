//
//  BzRecurrenceTblViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/10.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzRecurrenceTblViewController: UITableViewController, RecurrenceRuleChangeProtocol {
    
    var startDate : Date? = nil
    
    var targetCalendar : EKCalendar? = nil
    var recurrenceRule : EKRecurrenceRule? = nil
    var recurrenceRuleProtocol : RecurrenceRuleChangeProtocol? = nil
    var topEditViewController : UIViewController? = nil
    
    fileprivate var selectedIndexPath : IndexPath? = nil
    
    fileprivate func indexPathOfRecurrenceRule() -> IndexPath {
    
        var rtn : IndexPath = IndexPath(row: 0, section: 0)
        guard let recurrenceRule = self.recurrenceRule else {
            return IndexPath(row: 0, section: 0)
        }
        
        rtn = IndexPath(row: 0, section: 1) // カスタム
        
        switch( recurrenceRule.frequency ) {
        case .daily:
            if (recurrenceRule.interval == 1) && (recurrenceRule.recurrenceEnd == nil)  {
                let path = IndexPath(row:1, section:0)
                rtn = path
            }
        case .weekly:
            if (recurrenceRule.interval == 1) && (recurrenceRule.recurrenceEnd == nil)
                && (recurrenceRule.daysOfTheWeek == nil)  {
                let path = IndexPath(row:2, section:0)
                rtn = path
            }
        case .monthly:
            if (recurrenceRule.interval == 1) && (recurrenceRule.recurrenceEnd == nil)
                && (recurrenceRule.daysOfTheMonth == nil) && (recurrenceRule.daysOfTheWeek == nil) {
                let path = IndexPath(row:3, section:0)
                rtn = path
            }
        case .yearly:
            if (recurrenceRule.interval == 1) && (recurrenceRule.recurrenceEnd == nil)
                && (recurrenceRule.daysOfTheYear == nil) && (recurrenceRule.daysOfTheWeek == nil)  {
                let path = IndexPath(row: 4, section: 0) //[NSIndexPath indexPathForRow:0 inSection:0];
                rtn = path
            }
        }
        return rtn;
    }

//    - (void) recurrenceRuleChange:(EKRecurrenceRule*)newRecurrenceRule;

    // ToDo: 外から言われなくても本クラス内で遷移の判断可能では？
    // pushした後、popでこの画面に戻ってきた時に再度遷移してしまうのを防ぎたいのだと思う
    // unwindSegueを使って対応可能か？
    func setMoveToCustomSettingViewIFCustomRule() {
        self.moveToCustomSettingViewIFCustomRule = true
//        if self.moveToRecurrenceEndSetting == true {
//            moveToRecurrenceEndSetting = false
//        }
    }
    // ToDo: 外から言われなくても本クラス内で遷移の判断可能では？
    // pushした後、popでこの画面に戻ってきた時に再度遷移してしまうのを防ぎたいのだと思う
    // unwindSegueを使って対応可能か？
    func setMoveToRecurrenceEndSetting() {
        self.moveToRecurrenceEndSetting = true
//        if self.moveToCustomSettingViewIFCustomRule == true {
//            moveToCustomSettingViewIFCustomRule = false
//        }
    }

    @IBOutlet weak var doneButtonItem: UIBarButtonItem!
    @IBAction func doneClicked(_ sender: Any) {
        if let delegate = self.recurrenceRuleProtocol, let rule = self.recurrenceRule {
            delegate.recurrenceRuleChange(rule)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var cellForNoneFrequency: UITableViewCell!
    @IBOutlet weak var cellForDailyFrequency: UITableViewCell!
    @IBOutlet weak var cellForWeeklyFrequency: UITableViewCell!
    @IBOutlet weak var cellForMonthlyFrequency: UITableViewCell!
    @IBOutlet weak var cellForYearlyFrequency: UITableViewCell!
    
    @IBOutlet weak var cellForCustomFrequency: UITableViewCell!
    
    var moveToCustomSettingViewIFCustomRule : Bool = false
    var moveToRecurrenceEndSetting : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = NSLocalizedString("ViewTitle_Event_Recurrence",
                                                      comment:"繰り返し")

        // section 0
        self.cellForNoneFrequency.textLabel?.text = NSLocalizedString("Common_ExactJapaneseWord_Nashi", comment:"なし")
        self.cellForDailyFrequency.textLabel?.text = NSLocalizedString("Common_ExactWord_EveryDay", comment:"毎日")
        self.cellForWeeklyFrequency.textLabel?.text = NSLocalizedString("Common_ExactWord_EveryWeek", comment:"毎週")
        self.cellForMonthlyFrequency.textLabel?.text = NSLocalizedString("Common_ExactWord_EveryMonth", comment:"毎月")
        self.cellForYearlyFrequency.textLabel?.text = NSLocalizedString("Common_ExactWord_EveryYear", comment:"毎年")
        // sction 1
        self.cellForCustomFrequency.textLabel?.text = NSLocalizedString("Common_ExactWord_Custom", comment:"カスタム")

        
        
        
        self.selectedIndexPath = self.indexPathOfRecurrenceRule()
        self.updateCells()
        self.tableView.reloadData()
        super.viewWillAppear(animated)
    }
    
    fileprivate func isCustomRecurrenceRule(recurrenceRule:EKRecurrenceRule?) -> Bool {
        
        guard let recurrenceRule = recurrenceRule else {
            return false
        }
        
        var rtn : Bool = true

        print("interval: ", recurrenceRule.interval)
        print("end:      ", recurrenceRule.recurrenceEnd)
        print("month:    ", recurrenceRule.daysOfTheMonth)
        print("week:     ", recurrenceRule.daysOfTheWeek)
        
        switch( recurrenceRule.frequency ) {
        case .daily:
            if (recurrenceRule.interval == 1) && (recurrenceRule.recurrenceEnd == nil)  {
                // 毎日で、期限がなければカスタムではない
                rtn = false
            }
        case .weekly:
            if (recurrenceRule.interval == 1) && (recurrenceRule.recurrenceEnd == nil)
                && (recurrenceRule.daysOfTheWeek == nil) {
                // 毎週で、期限がなくて、曜日指定もなければカスタムではない
                rtn = false
            }
        case .monthly:
            if (recurrenceRule.interval == 1) && (recurrenceRule.recurrenceEnd == nil)
                && (recurrenceRule.daysOfTheMonth == nil) && (recurrenceRule.daysOfTheWeek == nil) {
                // 毎月で、期限がなく、日付指定もなく、曜日指定もなければカスタムではない
                rtn = false
            }
        case .yearly:
            if (recurrenceRule.interval == 1) && (recurrenceRule.recurrenceEnd == nil)
                && (recurrenceRule.daysOfTheYear == nil) && (recurrenceRule.daysOfTheWeek == nil) {
                // 毎年で、期限がなく、日付してもなく、曜日指定もなければカスタムではない
                // ToDo: そもそも年のカスタムでは日付も曜日も指定できないのでは？現行しようでは。
                rtn = false
            }
        }
        return rtn;

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (self.moveToCustomSettingViewIFCustomRule == true)
            && (self.isCustomRecurrenceRule(recurrenceRule: self.recurrenceRule) == true) {
            
                self.performSegue(withIdentifier: "customRecurrenceSegue", sender: self)
            
            
//            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Event" bundle:nil];
//            BzCustomRecurrenceTblViewController* customCtrl = [storyboard instantiateViewControllerWithIdentifier:@"BzCustomRecurrenceTblViewController"];
//
//            //CustomRecurrenceViewController* customCtrl = [[CustomRecurrenceViewController alloc] init];
//            customCtrl.startDate = self.startDate;
//            [customCtrl setRecurrenceRuleWithRecurrenceRule:self.recurrenceRule];
//            customCtrl.recurrenceRuleProtocol = self;
//            customCtrl.topEditViewController = self.topEditViewController;
//
//            customCtrl.frequency = self.recurrenceRule.frequency;
//            [self.navigationController pushViewController:customCtrl animated:YES];
            
        } else if self.moveToRecurrenceEndSetting == true {
            
            self.performSegue(withIdentifier: "customRecurrenceSegue", sender: self)

//            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Event" bundle:nil];
//            BzCustomRecurrenceTblViewController* customCtrl = [storyboard instantiateViewControllerWithIdentifier:@"BzCustomRecurrenceTblViewController"];
            
//            customCtrl.startDate = self.startDate;
//            [customCtrl setRecurrenceRuleWithRecurrenceRule:self.recurrenceRule];
//            customCtrl.recurrenceRuleProtocol = self;
//            customCtrl.topEditViewController = self.topEditViewController;
//
//            customCtrl.frequency = self.recurrenceRule.frequency;
//            [self.navigationController pushViewController:customCtrl animated:YES];
            
        }
        
        // reset
        // ナビゲーションでpush した後、popで戻ってきた時に再度pushしてしまうのを防ぐため
        self.moveToCustomSettingViewIFCustomRule = false
        self.moveToRecurrenceEndSetting = false

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

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    fileprivate func updateCells() {
        self.cellForNoneFrequency.accessoryType = .none
        self.cellForDailyFrequency.accessoryType = .none
        self.cellForWeeklyFrequency.accessoryType = .none
        self.cellForMonthlyFrequency.accessoryType = .none
        self.cellForYearlyFrequency.accessoryType = .none
        // sction 1
        self.cellForCustomFrequency.accessoryType = .disclosureIndicator
        
        if self.isCustomRecurrenceRule(recurrenceRule: self.recurrenceRule) == true {
            self.cellForCustomFrequency.detailTextLabel?.text = "*"
        } else {
            if let indexPath = self.selectedIndexPath {
                switch( indexPath.row ) {
                case 0: self.cellForNoneFrequency.accessoryType = .checkmark
                case 1: self.cellForDailyFrequency.accessoryType = .checkmark
                case 2: self.cellForWeeklyFrequency.accessoryType = .checkmark
                case 3: self.cellForMonthlyFrequency.accessoryType = .checkmark
                case 4: self.cellForCustomFrequency.accessoryType = .checkmark
                default:
                    break
                }
            }
        }
    }
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//
//        // Configure the cell...
//
//        return cell
//    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            return
        }
        if let selectedPath = self.selectedIndexPath,  indexPath.row != selectedPath.row {
            self.selectedIndexPath = indexPath
            switch(indexPath.row) {
            case 0:
                self.recurrenceRule = nil
            case 1:
                self.recurrenceRule = EKRecurrenceRule(recurrenceWith: .daily, interval: 1, end: nil)
            case 2:
                self.recurrenceRule = EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, end: nil)
            case 3:
                self.recurrenceRule = EKRecurrenceRule(recurrenceWith: .monthly, interval: 1, end: nil)
            case 4:
                self.recurrenceRule = EKRecurrenceRule(recurrenceWith: .yearly, interval: 1, end: nil)
            default:
                break
            }
            
            self.updateCells()
            self.tableView.reloadData()
        }
        
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "customRecurrenceSegue" {
            if let customCtrl = segue.destination as? BzCustomRecurrenceTblViewController {
                customCtrl.startDate = self.startDate
                customCtrl.targetCalendar = self.targetCalendar
                customCtrl.setRecurrenceRule(recurrenceRule: self.recurrenceRule)
                
                customCtrl.recurrenceRuleProtocol = self
                customCtrl.topEditViewController = self.topEditViewController;
                
                if self.moveToRecurrenceEndSetting == true {
                    // ToDo: 伝えなくていいか、要検証
                }
                
                //customCtrl.frequency = self.recurrenceRule.frequency;

            }
            
        }
    }

    // MARK: -
    func recurrenceRuleChange(_ newRecurrenceRule: EKRecurrenceRule) {
        self.recurrenceRule = newRecurrenceRule
        if self.topEditViewController != nil {
            if let delegate = self.recurrenceRuleProtocol {
                delegate.recurrenceRuleChange(newRecurrenceRule)
            }
        }
        
    }
    

}
