//
//  BzEventTemplateEditTblViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/03.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

@objc @objcMembers class BzEventTemplateEditTblViewController: UITableViewController,
RecurrenceRuleChangeProtocol,
BzCalendarChooserDelegate,
AlarmsChangeProtocol {
    

    fileprivate func gobackToPrevView() {
        
        DispatchQueue.main.async {
            if let _ = self.presentingViewController {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }

    }
    
    @IBOutlet weak var saveButtonItem: UIBarButtonItem!
    @IBAction func saveClicked(_ sender: Any) {
        guard let editTemplate = self.editTemplate else {
            return
        }
        
        //self.editTemplate.templateGroupName = self.cellForTemplateGroup.
        
        editTemplate.templateName = self.templateNameTextField.text
        editTemplate.title = self.eventNameTextField.text
        editTemplate.location = self.eventPlaceTextField.text

        if let templateName = editTemplate.templateName, templateName.isEmpty == false {
            if self.originalTemplate == nil {
                BzEventExtensionService.shared().add(eventTemplate: editTemplate) {
                    error in
                    
                    self.gobackToPrevView()
                    
                }
                
            } else {
                BzEventExtensionService.shared().update(eventTemplate: editTemplate) {
                    error in
                    self.gobackToPrevView()
                }
            }
        } else {
            let message = NSLocalizedString("ActionSheet_Message_SaveEvenIfNoTemplateName", comment:"テンプレート名がありませんが保存しますか？")
            let cancelTitle = NSLocalizedString("Common_CancelButton_Title", comment:"キャンセル")
            
            let actionSheet = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
            actionSheet.addAction(cancelAction)
            
            let okTitle = NSLocalizedString("Common_ExactWord_OK", comment:"OK")
            
            let okAction = UIAlertAction(title: okTitle, style: .default) {
                action in
                if self.originalTemplate == nil {
                    BzEventExtensionService.shared().add(eventTemplate: editTemplate) {
                        error in
                        self.gobackToPrevView()
                    }

                } else {
                    BzEventExtensionService.shared().update(eventTemplate: editTemplate) {
                        error in
                        self.gobackToPrevView()
                    }
                }
            }
            actionSheet.addAction(okAction)

            self.present(actionSheet, animated: true, completion: nil)
            
        }
    }
    
    @IBOutlet weak var cancelButtonItem: UIBarButtonItem!
    
    @IBAction func cancelClicked(_ sender: Any) {
        // ToDo:
        // ナビゲーションかモーダルから処理を分ける
        if let _ = self.presentingViewController {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func alldaySwitchChanged(_ sender: UISwitch) {
        self.editTemplate?.allDay = self.alldaySwitch.isOn
        self.updateCells()
    }
    // section 0
    @IBOutlet weak var cellForTemplateGroup: UITableViewCell!       // テンプレートグループ
    @IBOutlet weak var cellForTemplateName: UITableViewCell!        // テンプレート名
    @IBOutlet weak var templateNameTextField: UITextField!
    
    // section 1
    @IBOutlet weak var cellForEventTitle: UITableViewCell!          // イベント名称
    @IBOutlet weak var eventNameTextField: UITextField!
    
    @IBOutlet weak var cellForAllday: UITableViewCell!
    
    @IBOutlet weak var alldayLabel: UILabel!
    @IBOutlet weak var alldaySwitch: UISwitch!
    @IBOutlet weak var cellForEventTime: UITableViewCell!           // イベントの時間
    @IBOutlet weak var cellForEventLength: UITableViewCell!         // イベントの長さ
    @IBOutlet weak var cellForEventPlace: UITableViewCell!          // 場所
    
    @IBOutlet weak var eventPlaceTextField: UITextField!
    // section 2
    @IBOutlet weak var cellForEventRepeat: UITableViewCell!         // 繰り返し
    // section 3
    @IBOutlet weak var cellForEventCalendar: UITableViewCell!       // カレンダー
    // section 4
    @IBOutlet weak var cellForEventAlarm: UITableViewCell!          // アラーム
    // section 5
    @IBOutlet weak var cellForEventCustomColor: UITableViewCell!    // イベントのカスタム色
    
    fileprivate var originalTemplate : AppEventTemplate? = nil
    fileprivate var editTemplate : AppEventTemplate? = nil
    
    fileprivate var recurrenceRuleStringFormatter : EKRecurrenceRuleStringFormatter!
    
    fileprivate func updateCells() {
        
        guard let template = self.editTemplate else {
            return
        }
        
         // テンプレート名
        self.templateNameTextField.placeholder = NSLocalizedString("Common_ExactWord_TemplateName",comment:"Template名")
        self.templateNameTextField.text = template.templateName

        // イベントタイトル
        self.eventNameTextField.placeholder = NSLocalizedString("Common_Event_Title", comment:"タイトル")
        self.eventNameTextField.text = template.title

        // 終日
        self.alldayLabel.text = NSLocalizedString(
            "Common_ExactWord_AllDay", comment:"終日").appending(":")
        self.alldaySwitch.isOn = template.allDay
        
        // 開始時間, 長さ
        self.cellForEventTime.textLabel?.text = NSLocalizedString("Common_ExactWord_StartTime", comment:"開始時間").appending(":")
        self.cellForEventLength.textLabel?.text = NSLocalizedString("Common_ExactWord_Duration", comment:"長さ").appending(":")

        self.cellForEventTime.isUserInteractionEnabled = true
        self.cellForEventLength.isUserInteractionEnabled = true
        self.cellForEventTime.accessoryType = .disclosureIndicator
        self.cellForEventLength.accessoryType = .disclosureIndicator
        self.cellForEventTime.textLabel?.isEnabled = true
        self.cellForEventLength.textLabel?.isEnabled = true

        if template.allDay == false {

            if let startComps = template.startTimeComps, let hour = startComps.hour, let minute = startComps.minute {
                
                self.cellForEventTime.detailTextLabel?.text = String(format: "%02d:%02d", hour, minute)
                
            } else {
                self.cellForEventTime.detailTextLabel?.text = NSLocalizedString(
                    "Common_ExactWord_NoSetting", comment:"設定なし");
            }
            
            if let eventLengthComps = template.eventLengthComps {
                var str : String = ""
                if let hour = eventLengthComps.hour, hour > 0 {
                    str = str.appendingFormat("%d", hour)
                    str = str.appending(NSLocalizedString("Common_ExactWord_Hour", comment:"時間"))
                }
                if let minute = eventLengthComps.minute, minute > 0 {
                    str = str.appendingFormat(" %d", minute)
                    str = str.appending(NSLocalizedString("Common_ExactWord_Minute",comment:"分"))
                }
                self.cellForEventLength.detailTextLabel?.text = str
                self.cellForEventLength.detailTextLabel?.textColor = UIColor.black
            } else  {
                self.cellForEventLength.detailTextLabel?.text = ""
            }

        } else {
            self.cellForEventTime.isUserInteractionEnabled = false
            self.cellForEventLength.isUserInteractionEnabled = false
            self.cellForEventTime.accessoryType = .none
            self.cellForEventLength.accessoryType = .none

            self.cellForEventTime.textLabel?.isEnabled = false      // テキストがグレーになる
            self.cellForEventLength.textLabel?.isEnabled = false    // テキストがグレーになる
            
            self.cellForEventTime.detailTextLabel?.text = nil
            self.cellForEventLength.detailTextLabel?.text = nil
        }

        // 場所
        self.eventPlaceTextField.placeholder = NSLocalizedString("Common_Event_Location", comment:"場所")
        self.eventPlaceTextField.text = template.location

        // 繰り返し
        self.cellForEventRepeat.textLabel?.text = NSLocalizedString("Common_Event_Recurrence", comment:"繰り返し")
        
        self.cellForEventRepeat.detailTextLabel?.text = self.recurrenceRuleStringFormatter.string(recurrenceRules: template.recurrenceRules)

        // カレンダー
        self.cellForEventCalendar.textLabel?.text = NSLocalizedString("Common_ExactWord_Calendar", comment:"カレンダー")
        //cell.contentText.userInteractionEnabled = NO;
        
        
        if template.calendar == nil  {
            // ToDo:
            // デフォルトカレンダーは設定から取得する
            var calendarForEdit = CalendarManager.shared().defaultEKCalendar()
            if calendarForEdit == nil  {
                calendarForEdit = AppEventKit.shared.store()?.defaultCalendarForNewEvents //[[AppEventKit sharedEventKit] store].defaultCalendarForNewEvents;
            }

            template.calendar = calendarForEdit;
        }
        if let calendar = template.calendar {
            self.cellForEventCalendar.detailTextLabel?.text = calendar.title
            
            let calendarColor = calendar.bgColor()
            self.cellForEventCalendar.detailTextLabel?.textColor = calendarColor

        }

        // 通知
        self.cellForEventAlarm.textLabel?.text = NSLocalizedString("Common_Event_Alarm", comment:"通知")

        var alarmText : String = ""
        if let alarms = template.alarms, alarms.count > 0 {
            var alm : EKAlarm = alarms.first as! EKAlarm
            alarmText = alarmText.appending(alm.stringValue())
            for idx in 1..<alarms.count {
                alm = alarms[idx] as! EKAlarm
                alarmText = alarmText.appendingFormat(", %@", alm.stringValue())
            }
        } else {
            alarmText = NSLocalizedString("Common_Event_Alarm_None", comment:"なし")
        }
        self.cellForEventAlarm.detailTextLabel?.text = alarmText
        // カスタム色
        
        
        self.tableView.reloadData()

    }
    
    var eventTemplate : AppEventTemplate? {
        didSet {
            if let template = eventTemplate {
                originalTemplate = template
                editTemplate = AppEventTemplate(template: template)
            }
        }
    }
    
    var event: EKEvent? {
        didSet {
            if let ev = event {
                let template = AppEventTemplate(event: ev)
                originalTemplate = nil
                editTemplate = template
            }
        }
    }
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recurrenceRuleStringFormatter = EKRecurrenceRuleStringFormatter()
        
        if self.editTemplate == nil {
            let template = AppEventTemplate()
            template.templateGroupName = nil;
            template.templateName = nil;
            template.title = nil;
            template.startTimeComps = nil;
            
            var lenComps = DateComponents()
            lenComps.hour = 1
            lenComps.minute = 0
            template.eventLengthComps = lenComps
            
            
            self.editTemplate = template
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if self.originalTemplate == nil {
            self.title = NSLocalizedString("ViewTitle_EventTemplate_Add", comment:"テンプレート登録")
        } else {
            self.title = NSLocalizedString("ViewTitle_EventTemplate_Edit", comment:"テンプレート編集")
        }
        self.updateCells()
        
        if self.editTemplate?.templateName == nil {
            self.templateNameTextField.becomeFirstResponder()
        } else if let title = self.editTemplate?.title, title.isEmpty == true {
            self.eventNameTextField.becomeFirstResponder()
        }
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("segue.destination: ", segue.destination)
        if let timeController = segue.destination as? BzTimePickerViewController {
            if let editTemplate = self.editTemplate, let comps = editTemplate.startTimeComps {
                let appCalendar = CalendarManager.shared().appCalendar()
                if let editTime = appCalendar?.date(from: comps) {
                    timeController.editTime(time:editTime)
                    //timeController.timePicker.date = editTime
                }
            }
            return
        }
        if let timeController = segue.destination as? BzTimeLengthPickerViewController {
            if let editTemplate = self.editTemplate, let comps = editTemplate.eventLengthComps {
                    timeController.timeLengthComps = comps
            }
            return
        }
        if segue.identifier == "editRecurrenceSegue" {
            if let recCtrl = segue.destination as? BzRecurrenceTblViewController {
                
                if let startTimeComps = self.editTemplate?.startTimeComps {
                    let appCalendar = CalendarManager.shared().appCalendar()!
                    let flag : Set<Calendar.Component> = [.day, .month, .year]
                    
                    var comps = appCalendar.dateComponents(flag, from: Date())
                    
                    comps.hour = startTimeComps.hour
                    comps.minute = startTimeComps.minute
                    comps.second = 0
                   recCtrl.startDate = appCalendar.date(from: comps)!
                } else {
                    recCtrl.startDate = Date()
                }
                recCtrl.targetCalendar = self.editTemplate?.calendar
                
                if let recurrenceRules = self.editTemplate?.recurrenceRules, let recurrenceRule = recurrenceRules.first as? EKRecurrenceRule {
                    recCtrl.recurrenceRule = recurrenceRule
                }
                recCtrl.recurrenceRuleProtocol = self
                recCtrl.topEditViewController = self
                recCtrl.setMoveToCustomSettingViewIFCustomRule()
                
                //recCtrl.setMoveToRecurrenceEndSetting()

            }
        }
        if segue.identifier == "selectCalendarSegue" {
            let ctrl = segue.destination as! BzSelectedCalendarListTblViewController
            ctrl.markSelectedCalendar = true
            ctrl.calendarDelegate = self
            if let calendar = self.editTemplate?.calendar {
                var calendars : Set<EKCalendar> = Set()
                calendars.insert(calendar)
                ctrl.selectedCalendars = calendars
            } else {
                ctrl.selectedCalendars = Set()
            }
        }
        if segue.identifier == "editAlarmsSegue" {
            let armCtrl = segue.destination as! BzEditAlarmListTblViewController
            armCtrl.alarmsChangeProtocol = self
            if let alarms = self.editTemplate?.alarms {
                armCtrl.originalAlarmArray = alarms
            }
            
        }

    }

    
    func recurrenceRuleChange(_ newRecurrenceRule: EKRecurrenceRule) {
        self.editTemplate?.recurrenceRules = [newRecurrenceRule]
    }
    // MARK: - BzCalendarChooserDelegate
    func selectedCalendar(_ calendar: EKCalendar) {
        self.editTemplate?.calendar = calendar
        self.updateCells()
        self.tableView.reloadData()
    }
    func selectedCalendars(_ calendars: [EKCalendar]) {
        if let calendar = calendars.first {
            self.editTemplate?.calendar = calendar
            self.updateCells()
            self.tableView.reloadData()
        }
    }
    // MARK: - AlarmsChangeProtocol
    func alarmsChange(_ newAlarms: [EKAlarm]) {
        self.editTemplate?.alarms = newAlarms
        self.updateCells()
        self.tableView.reloadData()
    }

}

// MARK: - UnwindSegue  unwindの処理で変更値を取得しeditTemplateに設定する
//
extension BzEventTemplateEditTblViewController {
    @IBAction func unwindToTemplateEdit(segue: UIStoryboardSegue) {
        if let timeController = segue.source as? BzCalendar.BzTimePickerViewController {
            if let time = timeController.selectedTime() {
                if let calendar = CalendarManager.shared().appCalendar() {
                    let comps = calendar.dateComponents([.hour, .minute], from: time)
                    self.editTemplate?.startTimeComps = comps
                    self.updateCells()
                }

            } else {
                self.editTemplate?.startTimeComps = nil
            }
            
        }
    }
    
    @IBAction func unwindToTemplateEditWithTimeLemgth(segue: UIStoryboardSegue) {
        if let timeController = segue.source as? BzCalendar.BzTimeLengthPickerViewController {
            if let calendar = CalendarManager.shared().appCalendar() {
                let comps = calendar.dateComponents([.hour, .minute], from: timeController.timeLengthPicker.date)
                self.editTemplate?.eventLengthComps = comps
                self.updateCells()
            }
        }
    }

}
