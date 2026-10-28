//
//  BzSettingsRootViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/12.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzSettingsRootViewController: UITableViewController {

    
    @IBOutlet weak var selectCalendarCell: UITableViewCell!
    @IBOutlet weak var defaultCalendarCell: UITableViewCell!
    @IBOutlet weak var holidayCalendarCell: UITableViewCell!
    @IBOutlet weak var customHolidayCell: UITableViewCell!
    @IBOutlet weak var activeTimeCell: UITableViewCell!
    @IBOutlet weak var weekStartCell: UITableViewCell!
    @IBOutlet weak var defaultViewCell: UITableViewCell!
    @IBOutlet weak var colorSettingCell: UITableViewCell!
    
    @IBOutlet weak var monthFontSizeCell: UITableViewCell!
    
    @IBOutlet weak var weekFontSizeCell: UITableViewCell!
    
    @IBOutlet weak var rokuyoCell: UITableViewCell!
    
    @IBAction func doneClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("ViewTitle_Setting", comment:"設定")
        
        self.navigationController?.setToolbarHidden(true, animated: false)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: false)
        
        self.selectCalendarCell.textLabel?.text = NSLocalizedString("ViewTitle_Setting_DisplayCalendar", comment:"表示カレンダー")
        self.defaultCalendarCell.textLabel?.text = NSLocalizedString("ViewTitle_Setting_DefaultCalendar", comment:"デフォルトカレンダー")
        self.holidayCalendarCell.textLabel?.text = NSLocalizedString("ViewTitle_Setting_HolidayCalendars",
                                                                     comment:"祝日カレンダー")
        self.customHolidayCell.textLabel?.text = NSLocalizedString("ViewTitle_Setting_CustomHolidayCalendars",
                                                                   comment:"カスタム休日カレンダー")

        self.activeTimeCell.textLabel?.text = NSLocalizedString("ViewTitle_Setting_ActiveTime", comment: "活動時間")

        self.weekStartCell.textLabel?.text = NSLocalizedString("ViewTitle_Setting_WeekStartWeekday", comment:"週の開始曜日");

        self.defaultViewCell.textLabel?.text = NSLocalizedString("ViewTitle_Setting_InitialDisplayView", comment:"初期表示ビュー")
        self.colorSettingCell.textLabel?.text = NSLocalizedString("ViewTitle_Setting_BasicColor"
            , comment:"色の設定")
        
        self.monthFontSizeCell.textLabel?.text = NSLocalizedString("SettingView_Title_FontSize", comment:"フォントサイズ")
        
        self.weekFontSizeCell.textLabel?.text = NSLocalizedString("SettingView_Title_FontSize", comment:"フォントサイズ")
        
        self.rokuyoCell.textLabel?.text = NSLocalizedString("ViewTitle_Setting_Rokuyo",
                                                            comment:"六曜表示")

        super.viewWillAppear(animated)
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = self.tableView.cellForRow(at: indexPath)
        
        if cell == self.selectCalendarCell {
            let storyboard = UIStoryboard(name: "Setting", bundle: nil)
            let ctrl = storyboard.instantiateViewController(withIdentifier: "BzSelectCalendarsTblViewController") as! BzSelectCalendarsTblViewController

            
            self._pushViewController(ctrl: ctrl, hidesBottomBarWhenPushed: false)
            return
        }
        if cell == self.defaultCalendarCell {
            let storyboard = UIStoryboard(name: "Setting", bundle: nil)
            let ctrl = storyboard.instantiateViewController(withIdentifier: "BzDefaultCalendarChooser") as! BzDefaultCalendarChooser
//            ctrl.isMultiSelect = false
//            
//            if let defaultId = CalendarManager.shared().basicSettingManager().defaultEKCalendarID() {
//                if let defaultCalendar = AppEventKit.shared.store()?.calendar(withIdentifier: defaultId) {
//                    var calendars : Set<EKCalendar> = Set()
//                    calendars.insert(defaultCalendar)
//                    ctrl.selectedCalendars = calendars
//                }
//            }

            //let ctrl = BzCalendarChooser()
            self._pushViewController(ctrl: ctrl)
//            self._pushViewController(ctrl: ctrl)
            return
        }
        if cell == self.holidayCalendarCell {
            let ctrl = HolidaySelectionViewController()
            self._pushViewController(ctrl: ctrl)
            return
        }
        if cell == self.customHolidayCell {
            let ctrl = BzOffdayCalendarTblViewController()
            self._pushViewController(ctrl: ctrl)
            return
        }
        if cell == self.activeTimeCell {
//            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
//
//            BzActiveTimeTableViewController* activeTimeViewController = [storyboard instantiateViewControllerWithIdentifier:@"BzActiveTimeTableViewController"];
//            self._pushViewController(ctrl: ctrl)
            return
        }
        if cell == self.weekStartCell {
            let ctrl = WeekStartWeekdayController()
            self._pushViewController(ctrl: ctrl)
            return
        }
        if cell == self.defaultViewCell {
            let ctrl = DefaultDisplayController()
            self._pushViewController(ctrl: ctrl)
            return
        }
        if cell == self.colorSettingCell {
//            BzCurrentColorCodeSettingViewController* colorSettingController = [storyboard instantiateViewControllerWithIdentifier:@"BzCurrentColorCodeSettingViewController"];
//            self._pushViewController(ctrl: ctrl)
            return
        }
        
        if cell == self.monthFontSizeCell {
            let ctrl = SettingFontSizeForMonthTblViewController()
            self._pushViewController(ctrl: ctrl)
            return
        }
        if cell == self.weekFontSizeCell {
            let ctrl = SettingFontSizeForWeekTblViewController()
            self._pushViewController(ctrl: ctrl)
            return
        }
        if cell == self.rokuyoCell {
//            NSLocale* locale = [NSLocale currentLocale];
//            NSString* countryCode = [locale objectForKey:NSLocaleCountryCode];
//            NSString* langCode = [locale objectForKey:NSLocaleLanguageCode];
//            LOG(@"langCode: %@", langCode);
//
//            // 国が日本または、使用言語が日本語の時六曜を表示
//            if( ([countryCode compare:@"JP"] == NSOrderedSame) ||
//                ([langCode compare:@"ja"] == NSOrderedSame) ) {
//                RokuyoSettingController* rokuyoSettingCtrl = [[RokuyoSettingController alloc] init];
//                [self.localeSpecialsList addObject:rokuyoSettingCtrl];
//                [self.localeSpecialsTextList addObject:rokuyoSettingCtrl.title];
//            }
            let ctrl = RokuyoSettingController()
            self._pushViewController(ctrl: ctrl)
            return
        }

    }
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

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return NSLocalizedString("SettingView_SectionTitle_BasicSetting", comment:"基本設定")
        case 1:
            return NSLocalizedString("SettingView_SectionTitle_MonthViewSetting", comment:"月ビューの設定")
        case 2:
            return NSLocalizedString("SettingView_SectionTitle_WeekViewSetting", comment:"週ビューの設定")
        case 3:
            return NSLocalizedString("SettingView_SectionTitle_SpecialSetting", comment:"特殊設定")
        default:
            break
        }
        return nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    fileprivate func _pushViewController(ctrl:UIViewController, hidesBottomBarWhenPushed:Bool = true ) {
        ctrl.hidesBottomBarWhenPushed = hidesBottomBarWhenPushed
        self.navigationController?.pushViewController(ctrl, animated: true)
    }

}
