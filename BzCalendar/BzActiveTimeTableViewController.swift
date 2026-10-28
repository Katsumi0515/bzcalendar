//
//  BzActiveTimeTableViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/06/28.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzActiveTimeTableViewController: UITableViewController {
    
    fileprivate var activeTimeFromHour : Int = 0
    fileprivate var activeTimeFromMinute : Int = 0
    fileprivate var activeTimeToHour : Int = 24
    fileprivate var activeTimeToMinute : Int = 0

    //fileprivate var numFormatter : NumberFormatter = NumberFormatter()
    fileprivate var timeFormatter : DateFormatter = DateFormatter()
    fileprivate var selectedPath : IndexPath = IndexPath(row: 0, section: 0)
    
    @IBOutlet weak var activeTimeFromCell: UITableViewCell!
    @IBOutlet weak var activeTimeToCell: UITableViewCell!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    // MARK: - 保存
    fileprivate func saveActiveTimes() {
        
        let basicSettingManager = CalendarManager.shared().basicSettingManager()!

        basicSettingManager.changeActiveTime(fromHour: NSNumber(value:self.activeTimeFromHour))
        basicSettingManager.setActiveTimeFromMinute(NSNumber(value:self.activeTimeFromMinute))
        

        basicSettingManager.setActiveTimeToHour(NSNumber(value:self.activeTimeToHour))
        basicSettingManager.setActiveTimeToMinute(NSNumber(value:self.activeTimeToMinute))

        do {
            try basicSettingManager.saveAllChangesInContext()
        }
        catch {
            print("error: ", error)
        }
    }
    
    // MARK: - Doneボタン押下
    @IBOutlet weak var doneButtonItem: UIBarButtonItem!
    @IBAction func doneClicked(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: false)
        if let appDelegate = UIApplication.shared.delegate as? BzAppDelegate {
            appDelegate.topViewControllerDelegate().showMainView()
        }
        
    }

    @IBAction func pickerValueChanged(_ sender: Any) {
        let appCalendar = CalendarManager.shared().appCalendar()!
        
        let pickDt = self.timePicker.date
        let flag : Set<Calendar.Component> = [.year, .month, .day, .hour, .minute ]
        var comps = appCalendar.dateComponents(flag, from: pickDt)

        guard let path = self.tableView.indexPathForSelectedRow else {
            return
        }
        
        let selectedRow = path.row
        var hour = comps.hour!
        var minute = comps.minute!

        switch (selectedRow) {
        case 0:
            self.activeTimeFromHour = hour
            self.activeTimeFromMinute = minute
            break;
        case 1:
            if( (hour == 0) && (minute == 0) ) {
                hour = 24
                minute = 0
                comps.hour = hour
                comps.minute = 0
                
            }
            self.activeTimeToHour = hour
            self.activeTimeToMinute = minute
            break;
        default:
            break;
        }
        let fromVal : CGFloat = CGFloat(self.activeTimeFromHour) + CGFloat(self.activeTimeFromMinute) / CGFloat(60.0)
        let toVal   : CGFloat = CGFloat(self.activeTimeToHour)   + CGFloat(self.activeTimeToMinute) / CGFloat(60.0)
        if( toVal <= fromVal ) {
            if (fromVal+1.0) <= 24.0 {
                self.activeTimeToHour = self.activeTimeFromHour + 1
                if self.activeTimeFromHour == 24 {
                    self.activeTimeFromMinute = 0
                }
            } else {
                self.activeTimeToHour = 24
                self.activeTimeToMinute = 0
            }
        }
        
        self.saveActiveTimes()
        
        self.updateCells()
        
    }
    
    fileprivate func updateCells() {
        
        let appCalendar = CalendarManager.shared().appCalendar()!
        
        let dt = Date()
        let flag : Set<Calendar.Component> = [ .year, .month, .day ]
        var fromComps = appCalendar.dateComponents(flag, from: dt)
        var toComps   = appCalendar.dateComponents(flag, from: dt)
        
        fromComps.hour = self.activeTimeFromHour
        fromComps.minute = self.activeTimeFromMinute
        toComps.hour = self.activeTimeToHour
        toComps.minute = self.activeTimeToMinute
        
        let activeTimeFromDate = appCalendar.date(from: fromComps)!
        let activeTimeToDate   = appCalendar.date(from: toComps)!

        self.activeTimeFromCell.textLabel?.text = NSLocalizedString("Common_ExactWord_Start", comment: "開始")
        self.activeTimeFromCell.detailTextLabel?.text = self.timeFormatter.string(from: activeTimeFromDate)

        self.activeTimeToCell.textLabel?.text = NSLocalizedString("Common_ExactWord_End", comment: "終了")
        self.activeTimeToCell.detailTextLabel?.text = self.timeFormatter.string(from: activeTimeToDate)

        self.tableView.selectRow(at: self.selectedPath, animated: true, scrollPosition: .none)
        self.tableView.setNeedsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = NSLocalizedString("ViewTitle_Setting_ActiveTime", comment: "活動時間")

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("ViewTitle_Setting_ActiveTime", comment: "活動時間")
        self.timeFormatter.dateStyle = .none
        self.timeFormatter.timeStyle = .short
        let appCalendar = CalendarManager.shared().appCalendar()!
        if let locale = appCalendar.locale {
            self.timeFormatter.locale = locale
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appCalendar = CalendarManager.shared().appCalendar()!

        let basicSettingManager = CalendarManager.shared().basicSettingManager()!
        
        self.activeTimeFromHour = basicSettingManager.activeTimeFromHour().intValue
        self.activeTimeFromMinute = basicSettingManager.activeTimeFromMinute().intValue
        self.activeTimeToHour = basicSettingManager.activeTimeToHour().intValue
        self.activeTimeToMinute = basicSettingManager.activeTimeToMinute().intValue
        
        let dt = Date()
        let flag : Set<Calendar.Component> = [ .year, .month, .day ]
        var fromComps = appCalendar.dateComponents(flag, from: dt)
        var toComps   = appCalendar.dateComponents(flag, from: dt)
        
        fromComps.hour = self.activeTimeFromHour
        fromComps.minute = self.activeTimeFromMinute
        toComps.hour = self.activeTimeToHour
        toComps.minute = self.activeTimeToMinute

        self.selectedPath = IndexPath(row: 0, section: 0)
        self.updatePickerDate()
        self.updateCells()
        
    }
    override func viewDidLayoutSubviews() {
        self.tableView.selectRow(at: self.selectedPath, animated: false, scrollPosition: .none)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.selectRow(at: self.selectedPath, animated: false, scrollPosition: .none)
        self.tableView.setNeedsLayout()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if indexPath == self.selectedPath {
            cell.setSelected(true, animated: false)
        }
        return cell
    }
    
    fileprivate func updatePickerDate() {
        let appCalendar = CalendarManager.shared().appCalendar()!
        let dt = Date()
        let flag : Set<Calendar.Component> = [ .year, .month, .day ]
        var fromComps = appCalendar.dateComponents(flag, from: dt)
        var toComps   = appCalendar.dateComponents(flag, from: dt)
        
        fromComps.hour = self.activeTimeFromHour
        fromComps.minute = self.activeTimeFromMinute
        toComps.hour = self.activeTimeToHour
        toComps.minute = self.activeTimeToMinute
        
        let row = self.selectedPath.row
        switch (row) {
        case 0:
            let setDate = appCalendar.date(from: fromComps)!
            self.timePicker.setDate(setDate, animated: true)
            
            toComps.hour = self.activeTimeToHour - 4
            break;
        case 1:
            let setDate = appCalendar.date(from: toComps)!
            self.timePicker.setDate(setDate, animated: true)
            
            fromComps.hour = self.activeTimeFromHour + 4
            break;
        default:
            break;
        }

    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedPath = indexPath
        
        self.updatePickerDate()
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
