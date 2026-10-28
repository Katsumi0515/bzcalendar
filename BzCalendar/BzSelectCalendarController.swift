//
//  BzSelectCalendarController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/03.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzSelectCalendarController: EKCalendarChooser, EKCalendarChooserDelegate {

    @objc fileprivate func closeClicked(sendar:Any?) {
        self.navigationController?.popToRootViewController(animated: true)

//        if let appDelegate = UIApplication.shared.delegate as? BzAppDelegate {
//            appDelegate.topViewControllerDelegate().showMainView()
//        }
    }
    
    func saveData() {

        let calMgr = BzCalendarSettingManager.shared
        calMgr.selectEKCalendars(Array(self.selectedCalendars))
        
//        let calMgr = CalendarSettingManager.shared()! //BzCalendarSettingManager.shared
//        calMgr.select(Array(self.selectedCalendars))
    }

    // MARK: - インスタンス
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        self.title = NSLocalizedString("ViewTitle_Setting_DisplayCalendar", comment:"表示カレンダー")
    }
    
    init() {
        super.init(selectionStyle: .multiple, displayStyle: .allCalendars, entityType: .event, eventStore: AppEventKit.shared.store()!)
        self.delegate = self
        self.title = NSLocalizedString("ViewTitle_Setting_DisplayCalendar", comment:"表示カレンダー")
    }

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if var sources = AppEventKit.shared.store()?.sources {
            sources = sources.sorted(by: {
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
            for source in sources {
                print("type:  ", source.sourceType.rawValue)
                print("title: ", source.title)
                let cals = Array(source.calendars(for: .event))
//                let cals = source.calendars(for: .event).sorted(by: {
//                    c1, c2 in
//                    return c1.calendarIdentifier < c2.calendarIdentifier
//                })
                
//                for cal in cals {
//                    print("cal: ", cal.title, cal.isSubscribed, cal.type.rawValue)
//                }
            }
        }
        
        if let calendars = AppEventKit.shared.store()?.calendars(for: .event) {
            for cal in calendars {
                cal.source.title
                cal.source.sourceType.rawValue
            }
        }
        
        //let calMgr = CalendarSettingManager.shared()! //
        let calMgr = BzCalendarSettingManager.shared
        
        let ekCalendars = calMgr.selectedEKCalendars()
        self.selectedCalendars = Set(ekCalendars)

        //self.selectedCalendars = Set(ekCalendars)

        let itemClose = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closeClicked))
        itemClose.tintColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem = itemClose
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

    // MARK: - EKCalendarChooserDelegate
    // Called whenever the selection is changed by the user
    func calendarChooserSelectionDidChange(_ calendarChooser: EKCalendarChooser) {
        self.saveData()
    }
    
    // These are called when the corresponding button is pressed to dismiss the
    // controller. It is up to the recipient to dismiss the chooser.
    func calendarChooserDidFinish(_ calendarChooser: EKCalendarChooser) {
        
    }
    
    func calendarChooserDidCancel(_ calendarChooser: EKCalendarChooser) {
        
    }

}
