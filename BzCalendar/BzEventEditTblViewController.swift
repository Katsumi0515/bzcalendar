//
//  BzEventEditTblViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/11.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

@objc @objcMembers class BzEventEditTblViewController: UITableViewController,
UITextFieldDelegate,
BzEventDateViewControllerDelegate,
RecurrenceRuleChangeProtocol,
BzCalendarChooserDelegate,
AlarmsChangeProtocol,
BzEventNotesChangeProtocol,
BzSelectEventTemplateDelegate {
    
    fileprivate var editEvent:  EKEvent? = nil
    fileprivate var eventStore: EKEventStore? = nil
    
    fileprivate var eventCalendar : EKCalendar? = nil
    fileprivate var eventTitle    : String? = nil
    fileprivate var eventLocation : String? = nil
    fileprivate var eventNotes    : String? = nil
    fileprivate var startDate     : Date = Date()
    fileprivate var endDate : Date = Date()
    fileprivate var allday  : Bool = false
    fileprivate var alarms  : [EKAlarm]? = nil
    fileprivate var originalRecurrenceRule : EKRecurrenceRule? = nil
    fileprivate var targetRecurrenceRule   : EKRecurrenceRule? = nil
    fileprivate var availability : EKEventAvailability? = nil
    
    fileprivate var _customColor : UIColor? = nil
    
    fileprivate var titleTextField : UITextField? = nil
    fileprivate var locationTextField : UITextField? = nil
    
    fileprivate var dateFormatter : DateFormatter? = nil
    
    
    @IBOutlet weak var saveButtonItem: UIBarButtonItem!
    fileprivate var weekNumStringList : Array<String> = Array()
    fileprivate var weekdayStringList : Array<String> = Array()
    
    // section 0
    fileprivate var indexPathForTitle    : IndexPath = IndexPath(row: 0, section: 0)
    fileprivate var indexPathForLocation : IndexPath = IndexPath(row: 1, section: 0)
    // section 1
    fileprivate var indexPathForTimes         : IndexPath = IndexPath(row: 0, section: 1)
    fileprivate var indexPathForRecurrence    : IndexPath = IndexPath(row: 1, section: 1)
    fileprivate var indexPathForRecurrenceEnd : IndexPath = IndexPath(row: 2, section: 1)
    // section 2
    fileprivate var indexPathForCalendar : IndexPath = IndexPath(row: 0, section: 2)
    // section 3
    fileprivate var indexPathForAlarms : IndexPath = IndexPath(row: 0, section: 3)
    // section 4
    fileprivate var indexPathForNotes : IndexPath = IndexPath(row: 0, section: 4)
    // section 5
    fileprivate var indexPathForCustomColor : IndexPath = IndexPath(row: 0, section: 5)
    
    fileprivate var recurrenceRuleStringFormatter : EKRecurrenceRuleStringFormatter!
    
    @IBAction func cancelClicked(_ sender: Any) {
        //self.modalPresentationStyle
        self.dismiss(animated: true) {}
    }

    @IBAction func saveClicked(_ sender: Any) {
        guard let editEvent = self.editEvent else {
            fatalError("editEvent is nil")
        }
        // Note: delegate for those text is tableViewCell, so need to set back in here
        self.eventTitle = self.titleTextField?.text
        self.eventLocation = self.locationTextField?.text
        
        if editEvent.hasRecurrenceRules == false {
            
            editEvent.calendar = self.eventCalendar!
            if let title = self.eventTitle {
                editEvent.title = title
            } else {
                editEvent.title = ""
            }
            editEvent.location = self.eventLocation
            editEvent.notes = self.eventNotes
            editEvent.startDate = self.startDate
            editEvent.endDate = self.endDate
            editEvent.isAllDay = self.allday
            editEvent.alarms = self.alarms
            if let rule = self.targetRecurrenceRule {
                editEvent.addRecurrenceRule(rule)
            }
            if let availability = self.availability {
                editEvent.availability = availability
            }
            
            do {
                try self.eventStore?.save(editEvent, span: .thisEvent, commit: true)
            }
            catch {
                print("error: ", error)
            }
            
            self._updateAndSaveExtension()
            
            self.dismiss(animated: true) {}
            
        } else {
            // ActionSheetで３択
            let title = NSLocalizedString("SheetTitle_Change_RecurrenceEvent", comment:"繰り返しイベントの変更")
            
            
            let actionSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: NSLocalizedString("Common_CancelButton_Title", comment:"キャンセル"), style: .cancel) {
                action in
                
            }
            actionSheet.addAction(cancelAction)
            
            let allEventsActionTitle = NSLocalizedString("Sheet_ButtonTitle_Apply_AllEventsAfterThis", comment:"今後の全イベントに反映")
            let allEventsAction = UIAlertAction(title: allEventsActionTitle, style: .default) {
                action in
                
                self._setEKEventFromElements()
                do {
                    try self.eventStore?.save(self.editEvent!, span: .futureEvents, commit: true)
                    self.dismiss(animated: true, completion: nil)
                }
                catch {
                    // ToDo: あらーと画面表示（またはログ）
                    print("error: ", error)
                }
            }
            actionSheet.addAction(allEventsAction)
            
            let thisEventActionTitle = NSLocalizedString("Sheet_ButtonTitle_Apply_OnlyThisEvent", comment:"このイベントのみに反映")
            let thisEventAction = UIAlertAction(title: thisEventActionTitle, style: .default) {
                action in
                self._setEKEventFromElements()
                do {
                    try self.eventStore?.save(self.editEvent!, span: .thisEvent, commit: true)
                    self.dismiss(animated: true, completion: nil)
                }
                catch {
                    // ToDo: あらーと画面表示（またはログ）
                    print("error: ", error)
                }
                
            }
            actionSheet.addAction(thisEventAction)
            self.present(actionSheet, animated: true, completion: nil)
            
        }
    }

    // targetEvent
    // storyboardの流れからviewDidLoad()前に呼ばれるので、それを考慮して処理を組み立てる
    func targetEvent(event:EKEvent?, store:EKEventStore) {
        self.editEvent = event
        self.eventStore = store
        self._setEventElementsFromEKEvent()
    }
    
    // MARK : - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recurrenceRuleStringFormatter = EKRecurrenceRuleStringFormatter()
        
        self.tableView.estimatedRowHeight = 44
        if self.editEvent == nil {
            self.title = NSLocalizedString("ViewTitle_Event_AddEvent", comment:"イベントの追加")
            
            self.editEvent = EKEvent(eventStore: self.eventStore!)
            self.fillEventWithDefaultValues()
        } else {
            self.title = NSLocalizedString("ViewTitle_Event_EditEvent", comment:"イベントの編集")
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
        self.tableView.reloadData()
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        if section == 1 {
            if self.targetRecurrenceRule != nil {
                return 3
            }
            return 2
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var rtnCell : UITableViewCell!
        
        if indexPath == self.indexPathForTitle {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellForTitle", for: indexPath) as! BzEventTextFieldTableViewCell
            guard let textField = cell.textField else {
                fatalError("textFieldをStoryboard上のセルと連結していないのでは？")
            }
            textField.placeholder = NSLocalizedString("Common_Event_Title", comment:"タイトル")
            textField.delegate = self
            textField.text = self.eventTitle
            self.titleTextField = textField
            return cell
        }
        
        if indexPath == self.indexPathForLocation {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellForLocation", for: indexPath) as! BzEventTextFieldTableViewCell
            guard let textField = cell.textField else {
                fatalError("textFieldをStoryboard上のセルと連結していないのでは？")
            }
            textField.placeholder = NSLocalizedString("Common_Event_Location", comment:"場所")
            textField.delegate = self
            textField.text = self.eventLocation
            self.locationTextField = textField
            return cell
        }
        
        if indexPath == self.indexPathForTimes {
            return self.cellForTime(tableView:tableView, indexPath: indexPath)
        }
        
        if indexPath == self.indexPathForRecurrence {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellForRecurrence", for: indexPath)
            cell.textLabel?.text = NSLocalizedString("Common_Event_Recurrence", comment:"繰り返し")
            cell.detailTextLabel?.text = self.recurrenceRuleStringFormatter.string(recurrenceRule:self.targetRecurrenceRule)
            return cell
        }
        
        if indexPath == self.indexPathForRecurrenceEnd {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellForRecurrenceEnd", for: indexPath)
            cell.textLabel?.text = NSLocalizedString("Common_Event_RecurrenceEnd", comment:"期限")
            if let recurrenceEnd = self.targetRecurrenceRule!.recurrenceEnd {
                cell.detailTextLabel?.text = recurrenceEnd.stringValue()
            } else {
                cell.detailTextLabel?.text = NSLocalizedString("Common_Event_RecurrenceEnd_None", comment:"なし")
            }
            return cell
        }
        
        if indexPath == self.indexPathForCalendar {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellForCalendar", for: indexPath)
            cell.textLabel?.text = NSLocalizedString("Common_ExactWord_Calendar", comment:"カレンダー")
            // ToDo:
            // デフォルトカレンダーは設定から取得する
            var calendarForEdit = CalendarManager.shared().defaultEKCalendar()
            if calendarForEdit == nil  {
                calendarForEdit = self.eventStore?.defaultCalendarForNewEvents
            }
            
            if self.eventCalendar == nil {
                self.eventCalendar = calendarForEdit
            }
            if let cal = self.eventCalendar {
                cell.detailTextLabel?.text = cal.title
                cell.detailTextLabel?.textColor = cal.bgColor()
            }
            return cell
        }
        
        if indexPath == self.indexPathForAlarms {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellForAlarms", for: indexPath)
            cell.textLabel?.text = NSLocalizedString("Common_Event_Alarm", comment:"通知")
            var str = ""
            if let alarms = self.alarms, alarms.count > 0  {
                var alm = alarms[0]
                str = str.appending(alm.stringValue())
                for idx in 1..<alarms.count {
                    alm = alarms[idx]
                    str = str.appendingFormat(", %@", alm.stringValue())
                }
            } else {
                str = NSLocalizedString("Common_Event_Alarm_None", comment:"なし")
            }
            
            cell.detailTextLabel?.text = str
            return cell

        }
        
        if indexPath == self.indexPathForNotes {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellForNote", for: indexPath)
            cell.textLabel?.text = NSLocalizedString("Common_Event_Memo", comment:"メモ")
            
            cell.detailTextLabel?.text = self.eventNotes
            
            return cell
        }
        
        if indexPath == self.indexPathForCustomColor {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellForCustomColor", for: indexPath)
            cell.textLabel?.text = NSLocalizedString("Common_ExactWord_CustomColor", comment:"カスタム色")
            return cell
        }
        
        if rtnCell == nil {
            rtnCell = UITableViewCell()
        }
        
        return rtnCell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "eventTimesSegue" {
            if let dateViewController = segue.destination as? BzEventDateViewController {
                dateViewController.editStartDate = self.startDate
                dateViewController.editEndDate = self.endDate
                dateViewController.editAllday = self.allday
                
                dateViewController.eventDateChangeProtocol = self
                
                return
            }
        }
        if segue.identifier == "editRecurrenceSegue" {
            let recCtrl = segue.destination as! BzRecurrenceTblViewController
            recCtrl.startDate = self.startDate
            recCtrl.targetCalendar = self.eventCalendar
            
            recCtrl.recurrenceRule = self.targetRecurrenceRule
            recCtrl.recurrenceRuleProtocol = self
            recCtrl.topEditViewController = self
            recCtrl.setMoveToCustomSettingViewIFCustomRule()

            return
        }
        
        if segue.identifier == "editRecurrenceEndSegue" {
            let recCtrl = segue.destination as! BzRecurrenceTblViewController
            recCtrl.startDate = self.startDate
            recCtrl.targetCalendar = self.eventCalendar
            
            recCtrl.recurrenceRule = self.targetRecurrenceRule
            recCtrl.recurrenceRuleProtocol = self
            recCtrl.topEditViewController = self
            recCtrl.setMoveToCustomSettingViewIFCustomRule()

            recCtrl.setMoveToRecurrenceEndSetting()
            
            return
        }
        if segue.identifier == "editEventCalendarSegue" {
            let ctrl = segue.destination as! BzSelectedCalendarListTblViewController
            ctrl.markSelectedCalendar = true
            ctrl.calendarDelegate = self
            if let calendar = self.eventCalendar {
                var calendars : Set<EKCalendar> = Set()
                calendars.insert(calendar)
                ctrl.selectedCalendars = calendars
            } else {
                ctrl.selectedCalendars = Set()
            }
            
            return
        }
        if segue.identifier == "editAlarmsSegue" {
            let armCtrl = segue.destination as! BzEditAlarmListTblViewController
            armCtrl.alarmsChangeProtocol = self
            armCtrl.originalAlarmArray = self.alarms
            return
        }
        if segue.identifier == "editEventNotesSegue" {
            let notesCtrl = segue.destination as! BzEventNoteViewController
            notesCtrl.notesChangeDelegate = self
            notesCtrl.eventNotes = self.eventNotes
            return
        }
        if segue.identifier == "selectEventTemplageSegue" {
            let templateCtrl = segue.destination as! BzSelectEventTemplateTblViewController
            templateCtrl.eventTemplateDelegate = self
            return
        }
        
    }

    // MARK:- UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        if textField == self.titleTextField {
            self.eventTitle = textField.text
        } else if textField == self.locationTextField {
            self.eventLocation = textField.text
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.titleTextField {
            self.eventTitle = textField.text
        } else if textField == self.locationTextField {
            self.eventLocation = textField.text
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        
        textField.resignFirstResponder()
        if textField == self.titleTextField {
            // 次Cellにフォーカスをあてる
            if let locationTextField = self.locationTextField {
                locationTextField.becomeFirstResponder()
            }
        }
        return true
    }
}

extension BzEventEditTblViewController {
    
    func cellForTime(tableView:UITableView, indexPath:IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cellForTimes", for: indexPath) as? BzStartAndEndDateTblViewCell {
            cell.updateCell(startDate: self.startDate, endDate:self.endDate, allday:self.allday)
            cell.layoutIfNeeded()

            return cell
        }
        fatalError("UITableViewCellの取得失敗。cellForTime")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1 && indexPath.row == 0 {
            return 70
        }
        return UITableView.automaticDimension
        
    }

}

extension BzEventEditTblViewController {
    
    // MARK: - BzSelectEventTemplateDelegate
    func selectedEventTemplate(template: AppEventTemplate) {
    
        guard let appCalendar = CalendarManager.shared().appCalendar() else {
            return
        }
        
        let flag : Set<Calendar.Component> = [.day, .month, .year]
        
        if template.title == nil {
            let _title : String? = nil
            let _message = NSLocalizedString("Your selected template does not have a title.", comment:"選択したテンプレートにタイトルは含まれていません。")
            
            let alert = UIAlertController(title: _title, message: _message, preferredStyle: .alert)
            
            let okActionTitle = NSLocalizedString("Common_ExactWord_OK", comment:"OK")
            let okAction = UIAlertAction(title: okActionTitle, style: .default) {
                action in
                
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        self.eventTitle = template.title
        
        if template.allDay == true {
            self.allday = template.allDay
        } else {
            self.allday = false
        }
        if let array = template.alarms {
            self.alarms = Array()
            for idx in 0..<array.count {
                if let alm = array[idx] as? EKAlarm {
                    self.alarms?.append(alm)
                }
            }
        }
        
        if let recurrenceRules = template.recurrenceRules, let rule = recurrenceRules.first as? EKRecurrenceRule {
            self.targetRecurrenceRule = rule
        } else {
            self.targetRecurrenceRule = nil
        }
        
        self.eventNotes = template.notes;
        self.eventLocation = template.location;
        
        if let cal = template.calendar {
            self.eventCalendar = cal
        } else {
            self.eventCalendar = CalendarManager.shared().defaultEKCalendar()
        }

        if self.allday != true  {
            if let startTimeComps = template.startTimeComps {
                var comps = appCalendar.dateComponents(flag, from: self.startDate)
                let diff  = appCalendar.dateComponents(flag, from: self.startDate, to: self.endDate)
                comps.hour = startTimeComps.hour
                comps.minute = startTimeComps.minute
                comps.second = 0
                self.startDate = appCalendar.date(from: comps)!
                self.endDate = appCalendar.date(byAdding: diff, to: self.startDate)!
            }
            if let eventLengthComps = template.eventLengthComps {
                self.endDate = appCalendar.date(byAdding: eventLengthComps, to: self.startDate)!
            }
        }
        
        if let customColor = template.customColor {
            self._customColor = customColor
        }
        self.tableView.reloadData()

    }

    // MARK: - EventDateChangeProtocol
    func eventStartDateChange(newStartDate:Date) {
        self.startDate = newStartDate
        self.tableView.reloadData()
    }
    func eventEndDateChange(newEndDate:Date) {
        self.endDate = newEndDate
        self.tableView.reloadData()
    }
    func eventAllDayChange(newAllDay:Bool) {
        self.allday = newAllDay
        self.tableView.reloadData()
    }

    // MARK: - RecurrenceRuleChangeProtocol
    func recurrenceRuleChange(_ newRecurrenceRule: EKRecurrenceRule) {
        self.targetRecurrenceRule = newRecurrenceRule
        self.tableView.reloadData()
    }

    //MARK: - BzCalendarChooserDelegate
    func selectedCalendar(_ calendar: EKCalendar) {
        self.eventCalendar = calendar
        self.tableView.reloadData()
    }
    func selectedCalendars(_ calendars: [EKCalendar]) {
        if let cal = calendars.first {
            self.eventCalendar = cal
        }
    }
    // MARK: - AlarmsChangeProtocol
    func alarmsChange(_ newAlarms: [EKAlarm]) {
        self.alarms = newAlarms
        self.tableView.reloadData()
    }
    
    // MARK: - BzEventNotesChangeProtocol
    func eventNotesChange(_ newNotes: String) {
        self.eventNotes = newNotes
        self.tableView.reloadData()
    }

}

extension BzEventEditTblViewController {
    fileprivate func _setEKEventFromElements() {
        guard let editEvent = self.editEvent else {
            fatalError("editEvent is nil")
        }
        editEvent.calendar = self.eventCalendar!
        
        if let title = self.eventTitle {
            editEvent.title = title
        } else {
            editEvent.title = ""
        }
        
        editEvent.location = self.eventLocation
        editEvent.notes = self.eventNotes
        editEvent.startDate = self.startDate
        editEvent.endDate = self.endDate
        editEvent.isAllDay = self.allday
        editEvent.alarms = self.alarms
        
        if let originalRecurrenceRule = self.originalRecurrenceRule {
            editEvent.removeRecurrenceRule(originalRecurrenceRule)
        }
        if let rule = self.targetRecurrenceRule {
            editEvent.addRecurrenceRule(rule)
        }
        if let availability = self.availability {
            editEvent.availability = availability
        }
    }
    
    fileprivate func _setEventElementsFromEKEvent() {
        guard let editEvent = self.editEvent else {
            return
        }
        self.eventCalendar = editEvent.calendar
        self.eventTitle = editEvent.title
        self.eventLocation = editEvent.location
        self.eventNotes = editEvent.notes
        self.startDate = editEvent.startDate
        self.endDate = editEvent.endDate
        self.allday = editEvent.isAllDay
        self.alarms = editEvent.alarms
        if editEvent.hasRecurrenceRules == true {
            self.originalRecurrenceRule = editEvent.recurrenceRules?.first
            self.targetRecurrenceRule = self.originalRecurrenceRule
        } else {
            self.originalRecurrenceRule = nil
            self.targetRecurrenceRule = nil
        }
        self.availability = editEvent.availability
        
    }
    

}
// MARK: - モデルに移動すべき処理
// ToDo: モデルに移動すべき処理
extension BzEventEditTblViewController {
    
    fileprivate func fillEventWithDefaultValues() {
        
        guard let appCalender = CalendarManager.shared().appCalendar() else {
            return
        }
        guard let selectedDate = CalendarManager.shared().selectedDate else {
            return
        }
        
        let todayComps = appCalender.dateComponents([.hour, .minute], from: Date())
        let defaultHour = todayComps.hour
    
        var diffComps = DateComponents()
        diffComps.hour = 1
        
        // 開始日時の計算（初期提案用）
        var startComps = appCalender.dateComponents([.year, .month, .day, .hour, .minute], from: selectedDate)
        startComps.hour = defaultHour
        startComps.minute = 0
        
        guard let tmpDate = appCalender.date(from: startComps) else {
            return
        }
        
        if let startDate = appCalender.date(byAdding: diffComps, to: tmpDate) {
            self.startDate = startDate
            // ToDo: 時間の長さは設定より取得
            // 終了日時の計算（初期提案用）
            if let endDate = appCalender.date(byAdding: diffComps, to: self.startDate) {
                self.endDate = endDate
            }
        }
    
    }

}

extension BzEventEditTblViewController {
    fileprivate func _updateAndSaveExtension() {
        //        LOG_METHOD;
        //        LOG(@"self._customColor: %@", self._customColor);
        //        EventExtension* ext = [[BzEventExtensionService shared] eventExtensionWithEvent:self.editEvent];
        //
        //        // 新規
        //        if( ext == nil && (self._customColor || self._customTextColor )) {
        //            EventExtension* newExt = [[BzEventExtensionService shared] addExtensionWithEvent:self.editEvent];
        //            if( newExt == nil ) {
        //                return;
        //            } else {
        //                newExt.calendarIdentifier = self.editEvent.calendar.calendarIdentifier;
        //
        //                if( self._customColor != nil ) {
        //                    newExt.bgColorCode = [[ColorUtil sharedManager] colorCodeFromUIColor:self._customColor];
        //                }
        //                if( self._customTextColor ) {
        //                    newExt.textColorCode = [[ColorUtil sharedManager] colorCodeFromUIColor:self._customTextColor];
        //                }
        //
        //                [[BzEventExtensionService shared] saveAllChangesInEventExtensionsWithCompletionHandler:^(NSError* error) {
        //                    if( error ) {
        //                    NSLog(@"error: %@", error);
        //                    } else {
        //                    NSLog(@"Custom Color saved: %@", newExt.bgColorCode);
        //                    }
        //                    return;
        //                    }];
        //
        //            }
        //        }
        //        if( ext && (self._customColor || self._customTextColor) ) {
        //            BOOL _updated = NO;
        //            NSString* currentBgColor = [[ColorUtil sharedManager] colorCodeFromUIColor:self._customColor];
        //            NSString* currentTxColor = [[ColorUtil sharedManager] colorCodeFromUIColor:self._customTextColor];
        //
        //            if( [ext.bgColorCode compare:currentBgColor] != NSOrderedSame ) {
        //                ext.bgColorCode = currentBgColor;
        //                _updated = YES;
        //            }
        //            if( [ext.textColorCode compare:currentTxColor] != NSOrderedSame ) {
        //                ext.textColorCode = currentTxColor;
        //                _updated = YES;
        //            }
        //            if( _updated ) {
        //                [[BzEventExtensionService shared] saveAllChangesInEventExtensionsWithCompletionHandler:^(NSError* error) {
        //                    if( error ) {
        //                    NSLog(@"error: %@", error);
        //                    } else {
        //
        //                    }
        //                    return;
        //                    }];
        //            } else {
        //                return;
        //            }
        //        }
        //        if( ext && (self._customColor == nil && self._customTextColor == nil) ) {
        //            [[BzEventExtensionService shared] deleteAndSaveWithEventExtension:ext completionHandler:^(NSError* error) {
        //
        //                }];
        //        }
    }

}

