//
//  BzEventDetailViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/19.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzEventDetailViewController: UIViewController, EKEventViewDelegate {

    var event : EKEvent!
    var eventViewController : EKEventViewController!
    
    var dismissIsCalled : Bool = false
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var copyButtonItem: UIBarButtonItem!
    @IBOutlet weak var templateButtonItem: UIBarButtonItem!
    
    
    fileprivate func dismissThisView() {
        if self.dismissIsCalled == true {
            return
        }
        self.dismissIsCalled = true
        self.dismiss(animated: true, completion: {})
    }
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismissThisView()
    }
    @IBAction func editClicked(_ sender: Any) {
        
        self.dismiss(animated: true) {
            if let appDelegate = UIApplication.shared.delegate as? BzAppDelegate {
                appDelegate.topViewControllerDelegate().edit(self.event)
            }
        }
        
    }
    
    
    @IBAction func copyClicked(_ sender: Any) {
        
        guard let eventStore = AppEventKit.shared.store() else {
            return
        }
        
//        let eventStore = AppEventKit.shared().store()!


        let newEvent = EKEvent(eventStore: eventStore)
        
        let _event = self.eventViewController.event!
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
    
    
    @IBAction func templateClicked(_ sender: Any) {
        
        self.dismiss(animated: false) {
            if let appDelegate = UIApplication.shared.delegate as? BzAppDelegate {
                appDelegate.topViewControllerDelegate().addTemplate(self.eventViewController.event)
            }
        }
    }
    
    
    fileprivate func alertThenDeleteRepeatedEvent() {
    
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
                                                    try store.remove(self.eventViewController.event, span: .thisEvent)
                                                    
                                                    self.dismissThisView()
                                                }
                                                catch {
                                                    
                                                }
                                                
        }
        actionSheet.addAction(deleteThisEvent)
        let deleteFutureEvents = UIAlertAction(title: NSLocalizedString("SheetTitle_Delete_AllEventsAfterThis", comment:"今後の全イベントを削除"), style: .default) {
            action in
            do {
                let store = AppEventKit.shared.store()!
                try store.remove(self.eventViewController.event, span: .futureEvents)
                self.dismissThisView()

            }
            catch {
                
            }
            
        }
        actionSheet.addAction(deleteFutureEvents)
        
        self.present(actionSheet, animated: true, completion: nil)
        

    }
    
    fileprivate func alertThenDeleteThisEvent() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Common_CancelButton_Title", comment:"キャンセル"),
                                         style: .cancel) { action in }
        actionSheet.addAction(cancelAction)


        let deleteEvent = UIAlertAction(title: NSLocalizedString("SheetTitle_DeleteEvent", comment:"イベントを削除"), style: .default) {
            action in
            do {
                let store = AppEventKit.shared.store()!
                try store.remove(self.eventViewController.event, span: .futureEvents)
                self.dismissThisView()

            }
            catch {
                
            }
            
        }

        actionSheet.addAction(deleteEvent)
        
        self.present(actionSheet, animated: true, completion: nil)

    }
    
    @IBAction func deleteClicked(_ sender: Any) {
        if self.eventViewController.event.hasRecurrenceRules {
            self.alertThenDeleteRepeatedEvent()
        } else {
            self.alertThenDeleteThisEvent()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissIsCalled = false
    }
    override func viewWillAppear(_ animated: Bool) {

        self.title = NSLocalizedString("ViewTitle_Event_Detail", comment:"イベントの詳細")

        self.copyButtonItem.title = NSLocalizedString("Common_ExactWord_Copy", comment:"コピー")
        self.templateButtonItem.title = NSLocalizedString("Common_ExactWord_Add_Template", comment:"テンプレート登録")


        
        if self.event != nil {
            self.eventViewController = EKEventViewController()
            self.eventViewController.delegate = self
            self.eventViewController.event = self.event
            self.eventViewController.allowsCalendarPreview = false
            self.eventViewController.allowsEditing = false
            
            self.addChild(self.eventViewController)
            self.eventViewController.view.translatesAutoresizingMaskIntoConstraints = false

            
//            self.navigationController?.pushViewController(self.eventViewController, animated: true)
            self.containerView.addSubview( self.eventViewController.view )
            NSLayoutConstraint.activate([
                eventViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                eventViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                eventViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
                eventViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
                ])
            
            eventViewController.didMove(toParent: self)

        }
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
    func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
        if action == .deleted {
            self.dismissThisView()
        }
    }

}
