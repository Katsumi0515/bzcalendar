//
//  BzDefaultCalendarChooser.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/08/03.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzDefaultCalendarChooser: UITableViewController, BzCalendarChooserDelegate {

    fileprivate var calendarSources : Array<EKSource> = Array()
    fileprivate var calendarDict : Dictionary
        <String, Array<EKCalendar>> = Dictionary()
    // ここまで
    
    var markSelectedCalendar : Bool = true
    var selectedCalendars : Set<EKCalendar> = Set()
    var calendarDelegate : BzCalendarChooserDelegate? = nil
    
    var onlyWritableCalendars: Bool = true
    var isMultiSelect : Bool = false

    
    @IBOutlet weak var saveButtonItem: UIBarButtonItem!
    
    @IBAction func saveClicked(_ sender: Any) {
        
        if let selectedId = self.selectedCalendars.first?.calendarIdentifier {
            
            CalendarManager.shared().basicSettingManager().setDefaultEKCalenarWithID(selectedId)
            do {
                try CalendarManager.shared().basicSettingManager().saveAllChangesInContext()
                self.navigationController?.popViewController(animated: true)
            }
            catch {
                
            }

        }

    }
    
    fileprivate func updateSaveButton() {
        self.saveButtonItem.isEnabled = true
        if let defaultId = CalendarManager.shared().basicSettingManager().defaultEKCalendarID() {
            if let selectedCal = self.selectedCalendars.first {
                if selectedCal.calendarIdentifier == defaultId {
                    self.saveButtonItem.isEnabled = false
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isMultiSelect = false
        self.onlyWritableCalendars = true
        
        self.calendarDelegate = self
        self.calendarSources = Array()
        self.calendarDict = Dictionary()
        
        self.updateCalendarDict()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.title = NSLocalizedString("ViewTitle_Setting_DefaultCalendar", comment:"デフォルトカレンダー")

        if let defaultId = CalendarManager.shared().basicSettingManager().defaultEKCalendarID() {
            if let defaultCalendar = AppEventKit.shared.store()?.calendar(withIdentifier: defaultId) {
                self.selectedCalendars.removeAll()
                self.selectedCalendars.insert(defaultCalendar)
                self.updateSaveButton()
                self.tableView.reloadData()
            }
        }
        super.viewWillAppear(animated)
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
            }
        } else {
            self.selectedCalendars.removeAll()
        }
        self.selectedCalendars.insert(calendar)
        if let delegate = self.calendarDelegate {
            delegate.selectedCalendars(Array(self.selectedCalendars))
            if let calendar = self.selectedCalendars.first {
                delegate.selectedCalendar(calendar)
            }
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

    func selectedCalendar(_ calendar:EKCalendar) {
        
        self.updateSaveButton()
    }
    func selectedCalendars(_ calendars:[EKCalendar]) {
        self.updateSaveButton()
    }

}

extension BzDefaultCalendarChooser {
    
    // ToDo:
    //      ドメインモデルやサービスに移す
    fileprivate func updateCalendarDict() {
        
        guard let store = AppEventKit.shared.store() else {
            return
        }
        let calMgr = BzCalendarSettingManager.shared
        var displayCalendars : Set<EKCalendar> = Set(calMgr.selectedEKCalendars())
        if displayCalendars.count < 1 {
            if let defCal = AppEventKit.shared.store()?.defaultCalendarForNewEvents {
                displayCalendars.insert(defCal)
            }
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
            let calendars = source.calendars(for: .event).filter {
                (calendar) -> Bool in
                if self.onlyWritableCalendars == true {
                    if calendar.isSubscribed == true {
                        return false
                    }
                }
                if displayCalendars.count > 0 {
                    return (displayCalendars.contains(calendar) == true)
                } else {
                    return true
                }
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
    } // func updateCalendarDict()
    
    fileprivate func ekCalendarAtIndexPath(indexPath:IndexPath) -> EKCalendar {
        let source = self.calendarSources[indexPath.section]
        return self.calendarDict[source.sourceIdentifier]![indexPath.row]
        
    }
}

