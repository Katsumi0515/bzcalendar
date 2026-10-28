//
//  BzSelectOthersTblViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/10.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzSelectOthersTblViewController: UITableViewController {
    
    @IBOutlet weak var settingCell: UITableViewCell!
    
    @IBOutlet weak var appThemeCell: UITableViewCell!
    @IBOutlet weak var extensionCell: BzSelectOthersTblViewExtFunctionCell!
    @IBOutlet weak var googleSyncCell: UITableViewCell!

    @IBOutlet weak var reportCell: UITableViewCell!
    @IBOutlet weak var supportCell: UITableViewCell!
    @IBOutlet weak var appRatingCell: UITableViewCell!

    @IBAction func extSwitchChanged(_ sender: UISwitch) {
        
        if self.extensionCell.extSwitch.isOn == true {
            if CalendarManager.shared().iCloudCapable() {
                BzCloudExtensionManager.shared.set_iCloudEnabled(true)
                UIView.animate(withDuration: 1.0,
                               animations: {
                                self.extensionCell.accessoryType = .detailDisclosureButton

                },
                               completion: {
                                bool in
                                self.tableView.reloadData()
                })
            }
        } else {
            BzCloudExtensionManager.shared.set_iCloudEnabled(false)
            UIView.animate(withDuration: 1.0,
                           animations: {
                            self.extensionCell.accessoryType = .none
                            
            },
                           completion: {
                            bool in
                            self.tableView.reloadData()

            })

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("ViewTitle_SelectOthers", comment:"その他")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        
        // カレンダーの選択などから戻ってきたら、toolBarがhiddenになっていない事に対応
        // CalendarCooserの子クラスを作成するのではな
        self.navigationController?.setToolbarHidden(true, animated: false)
        
        self.settingCell.textLabel?.text = NSLocalizedString("SelectOthers_CellTitle_Setting", comment:"設定")
        self.appThemeCell.textLabel?.text = NSLocalizedString("SelectOthers_CellTitle_AppTheme", comment: "テーマ")
        self.googleSyncCell.textLabel?.text = NSLocalizedString("SelectOthers_CellTitle_GoogleSync", comment:"グーグルカレンダー連携")
        
        self.reportCell.textLabel?.text = NSLocalizedString("SelectOthers_CellTitle_ReportingBug", comment:"不具合の報告")
        self.supportCell.textLabel?.text = NSLocalizedString("SelectOthers_CellTitle_SupportSite", comment:"サポートサイト")
        self.appRatingCell.textLabel?.text = NSLocalizedString("SelectOthers_CellTitle_WeLoveBzCalender", comment:"アプリを応援！")
        
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("SelectOthers_Section_SettingRelated", comment:"設定関連")
        case 1:
            return NSLocalizedString("SelectOthers_Section_UserCommunity", comment:"ユーザーコミュニティ");
        default:
            return ""
        }
    }

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 2
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 3
//    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let extCell = cell as? BzSelectOthersTblViewExtFunctionCell {
            if CalendarManager.shared().iCloudCapable() == true {
                extCell.extSwitch.isEnabled = true
                extCell.extSwitch.isOn = CalendarManager.shared().iCloudEnabledByUserAndSystem()
                if extCell.extSwitch.isOn == true {
                    extCell.accessoryType = .detailDisclosureButton
                } else {
                    extCell.accessoryType = .none
                }
                extCell.extLabel.text = NSLocalizedString("Selectothers_CellTitle_ExtFunction", comment:"拡張機能")
                extCell.extDetailLabel.text = "iCloud"
                extCell.extDetailLabel.isHidden = false
            } else {
                extCell.extSwitch.isEnabled = false
                extCell.accessoryType = .disclosureIndicator
                
                var text = NSLocalizedString("Selectothers_CellTitle_ExtFunction", comment:"拡張機能")
                text = text.appending( NSLocalizedString("Document_HowToSet_iCloud_DocumentTitle", comment: "iCloudの設定") )

                extCell.extLabel.text = text
                extCell.extDetailLabel.text = "iCloud"
                extCell.extDetailLabel.isHidden = true
            }
            
        }

        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath)
        
        if cell == self.settingCell {
//            let ctrl = SettingsRootViewController()
//            self._pushViewController(ctrl: ctrl)
        } else if cell == self.extensionCell {
            if let extSiwtch = self.extensionCell.extSwitch, extSiwtch.isEnabled == true {
                if extSiwtch.isOn == true {
                    let storyboard = UIStoryboard(name: "ExtensionSetting", bundle: nil)
                    let extCtrl = storyboard.instantiateViewController(withIdentifier: "BzExtFunctionListController")
                    self._pushViewController(ctrl: extCtrl)
                }
            } else {
                let ctrl = BzHowToSet_iCloudViewController()
                self._pushViewController(ctrl: ctrl)
            }
        } else if cell == self.googleSyncCell {
            let ctrl = HowToLinkWithGoogleCalsTableViewController()
            self._pushViewController(ctrl: ctrl)
        } else if cell == self.reportCell {
            let ctrl = BzReportingABugViewController()
            self._pushViewController(ctrl: ctrl)
        } else if cell == self.supportCell {
            let ctrl = SupportByFacebookViewController()
            self._pushViewController(ctrl: ctrl)
        } else if cell == self.appRatingCell {
            let ctrl = LoveBzCalendarTblViewController()
            self._pushViewController(ctrl: ctrl)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.tableView(tableView, didSelectRowAt: indexPath)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    fileprivate func _pushViewController(ctrl:UIViewController) {
        ctrl.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(ctrl, animated: true)
    }

}
