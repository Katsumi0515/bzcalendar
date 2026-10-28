//
//  BzEventInfoTblViewControllerTableViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/08/02.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

@objc @objcMembers class BzEventInfoTblViewController: UITableViewController {

    fileprivate var dateIntervalFormatter : DateIntervalFormatter = DateIntervalFormatter()
    fileprivate var timeIntervalFormatter : DateIntervalFormatter = DateIntervalFormatter()
    
    fileprivate var dateFormatter : DateFormatter = DateFormatter()
    fileprivate var timeFormatter : DateFormatter = DateFormatter()
    fileprivate var recurrenceRuleStringFormatter : EKRecurrenceRuleStringFormatter = EKRecurrenceRuleStringFormatter()
    
    @IBOutlet weak var eventTitleCell: UITableViewCell!
    @IBOutlet weak var eventLocationCell: UITableViewCell!
    
    @IBOutlet weak var startDateCell: UITableViewCell!
    @IBOutlet weak var endDateCell: UITableViewCell!
    @IBOutlet weak var repeatCell: UITableViewCell!
    @IBOutlet weak var repeatDetailCell: UITableViewCell!
    @IBOutlet weak var calendarCell: UITableViewCell!
    @IBOutlet weak var notesCell: UITableViewCell!
    
    @IBOutlet weak var alarmCell: UITableViewCell!
    @IBOutlet weak var eventNotesTextView: UITextView!
    
    
    @IBOutlet weak var copyButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var templateButtonItem: UIBarButtonItem!
    
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true) {}
    }
    @IBAction func editClicked(_ sender: Any) {
        self.dismiss(animated: true) {
            if let appDelegate = UIApplication.shared.delegate as? BzAppDelegate {
                appDelegate.topViewControllerDelegate().edit(self.event)
            }
        }
    }
//    @IBOutlet weak var notesTextHeightConstraint: NSLayoutConstraint!
    
    // 現在のEKEventをコピーして新規イベントを作成する
    @IBAction func copyClicked(_ sender: Any) {
    
        guard let _event = self.event else {
            return
        }

        guard let eventStore = AppEventKit.shared.store() else {
            return
        }
        
        let newEvent = EKEvent(eventStore: eventStore)
        
        newEvent.title = _event.title;
        newEvent.startDate = _event.startDate;
        newEvent.endDate = _event.endDate;
        newEvent.alarms = _event.alarms;
        newEvent.isAllDay = _event.isAllDay;
        newEvent.calendar = _event.calendar;
        newEvent.location = _event.location;
        newEvent.notes = _event.notes;
        newEvent.recurrenceRules = _event.recurrenceRules;
        newEvent.url = _event.url
        newEvent.availability = _event.availability
        
        // 現在のビューはモーダルビューから削除する
        self.dismiss(animated: false) {
            if let appDelegate = UIApplication.shared.delegate as? BzAppDelegate {
                appDelegate.topViewControllerDelegate().edit(newEvent)
            }
        }

    }
    
    // 現在のEKEventからテンプレートに登録する
    @IBAction func templateClicked(_ sender: Any) {
        guard let _event = self.event else {
            return
        }

        self.dismiss(animated: false) {
            if let appDelegate = UIApplication.shared.delegate as? BzAppDelegate {
                appDelegate.topViewControllerDelegate().addTemplate(_event)
            }
        }
    }
    
    // イベントを削除する
    @IBAction func deleteClicked(_ sender: Any) {
        guard let _event = self.event else {
            return
        }
        if _event.hasRecurrenceRules {
            self.alertThenDeleteRepeatedEvent(_event)
        } else {
            self.alertThenDeleteThisEvent(_event)
        }
    }
    
    var event: EKEvent? = nil {
        didSet {
            if let recurrenceRules = self.event?.recurrenceRules, let rule = recurrenceRules.first {
                self.targetRecurrenceRule = rule
            } else {
                self.targetRecurrenceRule = nil
            }

        }
    }
//    fileprivate var eventStore: EKEventStore? = nil
    fileprivate var targetRecurrenceRule: EKRecurrenceRule? = nil
    
    
    // targetEvent
    // storyboardの流れからviewDidLoad()前に呼ばれるので、それを考慮して処理を組み立てる
    func targetEvent(event:EKEvent?, store:EKEventStore) {
        self.event = event
    
        if let recurrenceRules = self.event?.recurrenceRules, let rule = recurrenceRules.first {
            self.targetRecurrenceRule = rule
        } else {
            self.targetRecurrenceRule = nil
        }

        //self._setEventElementsFromEKEvent()
    }
    fileprivate func updateDateFormatter(allday:Bool) {
        
        if allday == true {
            self.dateIntervalFormatter.dateStyle = .full
            self.dateIntervalFormatter.timeStyle = .none
            dateFormatter.dateStyle = .full;
            dateFormatter.timeStyle = .none;
            timeFormatter.dateStyle = .none
            timeFormatter.timeStyle = .none
        } else {
            self.dateIntervalFormatter.dateStyle = .full
            self.dateIntervalFormatter.timeStyle = .none
            self.timeIntervalFormatter.dateStyle = .none
            self.timeIntervalFormatter.timeStyle = .short
            
            dateFormatter.dateStyle = .full;
            dateFormatter.timeStyle = .none;
            timeFormatter.dateStyle = .none;
            timeFormatter.timeStyle = .short
        }
    }

    fileprivate func updateUI() {
        guard let event = self.event else {
            return
        }
        self.updateDateFormatter(allday: event.isAllDay)
        
        // タイトルおよび場所
        self.eventTitleCell.textLabel?.text = event.title
        self.eventLocationCell.textLabel?.text = event.location
        
        // 日時
        self.startDateCell.textLabel?.text = NSLocalizedString("Common_ExactWord_Start", comment:"開始")
        self.endDateCell.textLabel?.text   = NSLocalizedString("Common_ExactWord_End", comment:"終了")
        self.startDateCell.detailTextLabel?.text = ""
        self.endDateCell.detailTextLabel?.text = ""
        
        let startDateText = self.dateFormatter.string(from: event.startDate)
        let startTimeText = self.timeFormatter.string(from: event.startDate)
        let endDateText = self.dateFormatter.string(from: event.endDate)
        let endTimeText = self.timeFormatter.string(from: event.endDate)
        
        if event.isAllDay {
            self.startDateCell.detailTextLabel?.text = startDateText
            self.endDateCell.detailTextLabel?.text = endDateText
        } else if startDateText == endDateText {
            // 同じ日に開始および終了
            self.startDateCell.textLabel?.text = startDateText
            self.endDateCell.textLabel?.text = self.timeIntervalFormatter.string(from: event.startDate, to: event.endDate)
        } else {
            var startText = startDateText
            if startTimeText.isEmpty == false {
                startText = startText + " " + startTimeText
            }
            self.startDateCell.detailTextLabel?.text = startText
            var endText = endDateText
            if endTimeText.isEmpty == false {
                endText = endText + " " + endTimeText
            }
            self.endDateCell.detailTextLabel?.text = endText
        }
        

        // 繰り返し
        self.repeatCell.textLabel?.text = NSLocalizedString("Common_Event_Recurrence", comment:"繰り返し")
        self.repeatCell.detailTextLabel?.text = self.recurrenceRuleStringFormatter.string(recurrenceRule:self.targetRecurrenceRule)

        self.repeatDetailCell.textLabel?.text = NSLocalizedString("Common_Event_RecurrenceEnd", comment:"期限")
        if let recurrenceEnd = self.targetRecurrenceRule?.recurrenceEnd {
            self.repeatDetailCell.detailTextLabel?.text = recurrenceEnd.stringValue()
        } else {
            self.repeatDetailCell.detailTextLabel?.text = NSLocalizedString("Common_Event_RecurrenceEnd_None", comment:"なし")
        }

        // アラーム
        self.alarmCell.textLabel?.text = NSLocalizedString("Common_Event_Alarm", comment:"通知")
        var almStr = ""
        if let alarms = event.alarms, alarms.count > 0  {
            var alm = alarms[0]
            almStr = almStr.appending(alm.stringValue())
            for idx in 1..<alarms.count {
                alm = alarms[idx]
                almStr = almStr.appendingFormat(", %@", alm.stringValue())
            }
        } else {
            almStr = NSLocalizedString("Common_Event_Alarm_None", comment:"なし")
        }
        self.alarmCell.detailTextLabel?.text = almStr

        // カレンダー
        self.calendarCell.textLabel?.text = NSLocalizedString("Common_ExactWord_Calendar", comment:"カレンダー")
        self.calendarCell.detailTextLabel?.text = event.calendar.title
        self.calendarCell.detailTextLabel?.textColor = event.calendar.bgColor()
        
        // ノート
        self.eventNotesTextView.text = event.notes
        self.eventNotesTextView.isEditable = false
        
        let fullSize = self.view.bounds.size
        let height = self.eventNotesTextView.sizeThatFits(fullSize).height
//        self.notesTextHeightConstraint.constant = height
        
        

    }
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = false
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title = NSLocalizedString("ViewTitle_Event_Detail", comment:"イベントの詳細")
        self.copyButtonItem.title = NSLocalizedString("Common_ExactWord_Copy", comment:"コピー")
        self.templateButtonItem.title = NSLocalizedString("Common_ExactWord_Add_Template", comment:"テンプレート登録")

        self.updateUI()
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if let event = self.event, event.notes?.isEmpty == false {
            return super.numberOfSections(in: tableView)
        }
        return super.numberOfSections(in: tableView) - 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            if self.targetRecurrenceRule != nil {
                return 4
            }
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4 {
            let fullSize = self.view.bounds.size
            let height = self.eventNotesTextView.sizeThatFits(fullSize).height
            //            self.notesTextHeightConstraint.constant = height
            return height + 8
            
        } else {
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4 {
            let fullSize = self.view.bounds.size
            let height = self.eventNotesTextView.sizeThatFits(fullSize).height
//            self.notesTextHeightConstraint.constant = height
            return height + 8

        } else {
            return UITableView.automaticDimension
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

}

extension BzEventInfoTblViewController {
    
    fileprivate func alertThenDeleteRepeatedEvent(_ event:EKEvent) {
        
        let title = NSLocalizedString("SheetTitle_Delete_RecurrenceEvent", comment:"繰り返しイベントの削除")
        let actionSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Common_CancelButton_Title", comment:"キャンセル"),
                                         style: .cancel) { action in }
        actionSheet.addAction(cancelAction)
        
        let deleteThisEvent = UIAlertAction(title: NSLocalizedString("SheetTitle_Delete_OnlyThisEvent", comment:"このイベントのみを削除"),
                                            style: .default) {
                                                action in
                                                
                                                do {
                                                    let store = AppEventKit.shared.store()!
                                                    try store.remove(event, span: .thisEvent)
                                                    
                                                    self.dismiss(animated: true) {}
                                                }
                                                catch {
                                                    
                                                }
                                                
        }
        actionSheet.addAction(deleteThisEvent)
        let deleteFutureEvents = UIAlertAction(title: NSLocalizedString("SheetTitle_Delete_AllEventsAfterThis", comment:"今後の全イベントを削除"), style: .default) {
            action in
            do {
                let store = AppEventKit.shared.store()!
                try store.remove(event, span: .futureEvents)
                self.dismiss(animated: true) {}

            }
            catch {
                
            }
            
        }
        actionSheet.addAction(deleteFutureEvents)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    fileprivate func alertThenDeleteThisEvent(_ event:EKEvent) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Common_CancelButton_Title", comment:"キャンセル"),
                                         style: .cancel) { action in }
        actionSheet.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("SheetTitle_DeleteEvent", comment:"イベントを削除"), style: .default) {
            action in
            do {
                let store = AppEventKit.shared.store()!
                try store.remove(event, span: .futureEvents)
                self.dismiss(animated: true) {}
                
            }
            catch {
                
            }
            
        }
        
        actionSheet.addAction(deleteAction)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }

}
