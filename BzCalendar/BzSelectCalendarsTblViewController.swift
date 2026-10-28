//
//  BzSelectCalendarsTblViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/08/03.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzSelectCalendarsTblViewController: UITableViewController {

    fileprivate var isSelectAll = true
    fileprivate var iCloudAccountExists = false
    
//    @IBOutlet weak var createCalendarButtonItem: UIBarButtonItem!
    @IBOutlet weak var allCalendarsButtonItem: UIBarButtonItem!
    
    @IBAction func allCalendarsClicked(_ sender: Any) {
        if self.isSelectAll == true {
            let keys = self.calendarDict.keys
            for key in keys {
                if let calendars = self.calendarDict[key] {
                    for cal in calendars {
                        self.selectedCalendars.insert(cal)
                    }
                }
            }
            self.isSelectAll = false
        } else {
            self.selectedCalendars.removeAll()
            self.isSelectAll = true
        }
        
        self.updateButtons()
        self.tableView.reloadData()
    }
    
    @IBOutlet weak var saveButtonItem: UIBarButtonItem!
    
    @IBAction func saveClicked(_ sender: Any) {
    
        let calendars = Array(self.selectedCalendars)
        
        let calMgr = BzCalendarSettingManager.shared
        calMgr.selectEKCalendars(calendars)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    fileprivate func updateButtons() {
        let calMgr = BzCalendarSettingManager.shared
        let ekCalendars = calMgr.selectedEKCalendars()

        self.saveButtonItem.isEnabled =  (self.selectedCalendars != Set(ekCalendars))
        
        if self.isSelectAll == true {
            self.allCalendarsButtonItem.title = NSLocalizedString("SelectCalendars_ShowAll", comment:"Show All")
            //"Show All"
        } else {
            self.allCalendarsButtonItem.title = NSLocalizedString("SelectCalendars_HideAll", comment:"Hide All")
        }
    }
    // EKSource別にEKCalendarをグループ化する
    // EKSourceの順序をkeyOrderArrayで示し
    // calendarDictで、keyをEKSourceのsourceIdentifierで、ソートされているEKCalendarのArrayを格納している
    // ここから
    fileprivate var calendarSources : Array<EKSource> = Array()
    fileprivate var calendarDict : Dictionary
        <String, Array<EKCalendar>> = Dictionary()
    // ここまで
    
    var markSelectedCalendar : Bool = true
    var selectedCalendars : Set<EKCalendar> = Set()
    var calendarDelegate : BzCalendarChooserDelegate? = nil
    
    var onlyWritableCalendars: Bool = false
    var isMultiSelect : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setToolbarHidden(false, animated: false)

        //        self.tableView.register(BzCalendarChooserCell.self, forCellReuseIdentifier: "bzCalendarChooserCell")
        // ToDo: - カラーリング対応
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.title = NSLocalizedString("ViewTitle_CustomSetting_Calendar", comment:"カレンダー")
        
        self.calendarSources = Array()
        self.calendarDict = Dictionary()
        
        self.updateCalendarDict()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title = NSLocalizedString("ViewTitle_Setting_DisplayCalendar", comment:"表示カレンダー")

        let calMgr = BzCalendarSettingManager.shared
        
        let ekCalendars = calMgr.selectedEKCalendars()
        self.selectedCalendars = Set(ekCalendars)
        self.updateButtons()
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.calendarSources.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let source = self.calendarSources[section]
        if let calendars = self.calendarDict[source.sourceIdentifier] {
            return calendars.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellIdentifier = "bzCalendarChooserCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as?
            BzCalendarChooserCell else {
                fatalError()
        }
        
        // Configure the cell...
        let cal : EKCalendar = self.ekCalendarAtIndexPath(indexPath: indexPath)
        
        cell.accessoryType = .none;
        if self.markSelectedCalendar == true {
            if self.selectedCalendars.contains(cal) {
                cell.accessoryType = .checkmark
            }
        }
        cell.colorSampleView.backgroundColor = cal.bgColor()
        cell.calendarTitle.text = cal.title;
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let source = self.calendarSources[section]
        return source.title;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let calendar = self.ekCalendarAtIndexPath(indexPath: indexPath)
        
        if self.isMultiSelect == true {
            if self.selectedCalendars.contains(calendar) {
                self.selectedCalendars.remove(calendar)
            } else {
                self.selectedCalendars.insert(calendar)
            }
        } else {
            self.selectedCalendars.removeAll()
            self.selectedCalendars.insert(calendar)
        }
        if let delegate = self.calendarDelegate {
            delegate.selectedCalendars(Array(self.selectedCalendars))
            if let calendar = self.selectedCalendars.first {
                delegate.selectedCalendar(calendar)
            }
        }
        self.updateButtons()
        self.tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // 選択モードの時はfalseを返すというやり方もある事を示すためにこのコードを残している
        
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "customizeCalendarSegue" {
            if let nextViewController = segue.destination as? BzCustomizeCalendarTblViewController {
                if let selectedIndex = self.tableView.indexPathForSelectedRow {
                    let cal = self.ekCalendarAtIndexPath(indexPath: selectedIndex)
                    nextViewController.calendar = cal
                }
            }
        }
        
    }
    
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        return false
    }
    //    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
    //
    //    }
    
}

// MARK:- 以下はドメインモデルやサービスに移したい
extension BzSelectCalendarsTblViewController {
    
    // ToDo:
    //      ドメインモデルやサービスに移す
    fileprivate func updateCalendarDict() {
        
        guard let store = AppEventKit.shared.store() else {
            return
        }

        let tmpSources = store.sources.filter { (source) -> Bool in
            if self.onlyWritableCalendars == true {
                if source.sourceType == .birthdays {
                    return false
                } else if source.sourceType == .subscribed {
                    return false
                }
            }
            return true
        }
        self.calendarSources = tmpSources.sorted(by: {
            s1, s2 in
            if s1.sourceType.rawValue < s2.sourceType.rawValue {
                return true
            } else if s1.sourceType.rawValue > s2.sourceType.rawValue {
                return false
            }
            switch s1.title.compare(s2.title) {
            case .orderedAscending, .orderedSame:
                return true
            case .orderedDescending:
                return false
            }
        })
        
        for source in self.calendarSources {
            if source.sourceType == .calDAV {
                if source.title == "iCloud" {
                    self.iCloudAccountExists = true
                }
            }

            let calendars = source.calendars(for: .event).filter {
                (calendar) -> Bool in
                if self.onlyWritableCalendars == true {
                    if calendar.isSubscribed == true {
                        return false
                    }
                }
                return true
            }
            self.calendarDict[source.sourceIdentifier] = Array(calendars)
        }
        self.calendarSources = self.calendarSources.filter {
            source in
            if let cals = self.calendarDict[source.sourceIdentifier] {
                if cals.count > 0 {
                    return true
                }
            }
            return false
        }
        
        for source in self.calendarSources {
            if var mutArr = self.calendarDict[source.sourceIdentifier] {
                mutArr.sort {
                    return $0.title < $1.title
                    //return $0.calendarIdentifier < $1.calendarIdentifier
                }
                self.calendarDict[source.sourceIdentifier] = mutArr
            }
        }
        
//        self.createCalendarButtonItem.isEnabled = self.iCloudAccountExists
        
    } // func updateCalendarDict()
    
    fileprivate func ekCalendarAtIndexPath(indexPath:IndexPath) -> EKCalendar {
        let source = self.calendarSources[indexPath.section]
        return self.calendarDict[source.sourceIdentifier]![indexPath.row]
        
    }
}

