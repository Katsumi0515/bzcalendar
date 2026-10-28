//
//  BzCurrentColorCodeSettingViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/04/09.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

protocol BzChangedColorCodeHandleProtocol {
    func selectedColorCode(colorCode:String, object:Any?)
}

class BzCurrentColorCodeSettingViewController: UITableViewController,
BzChangedColorCodeHandleProtocol {

    fileprivate var colorManager  : ColorSettingManager!
    fileprivate var selectedIndex : IndexPath = IndexPath(row: 0, section: 0)

    fileprivate let settingItems = [
        NSLocalizedString("ColorSetting_Today", comment: "今日"),
        NSLocalizedString("ColorSetting_Selected", comment: "選択"),
        NSLocalizedString("ColorSetting_Saturday", comment: "土曜日"),
        NSLocalizedString("ColorSetting_Sunday", comment: "日曜日"),
        NSLocalizedString("ColorSetting_Holiday", comment: "祝日"),
        NSLocalizedString("ColorSetting_CustomHoliday", comment: "カスタム休日"),
    ]
    
    @IBOutlet weak var doneButtonItem: UIBarButtonItem!
    
    @IBAction func doneClicked(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("ViewTitle_Setting_BasicColor"
            , comment:"色設定")

        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableView.automaticDimension

    }

    override func viewWillAppear(_ animated: Bool) {
            
        self.colorManager = CalendarManager.shared().appSettingColorManager()
        self.tableView.reloadData()
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "BzCurrentColorCodeSettingViewControllerCell";
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as? BzColorSettingTableViewCell else {
            return UITableViewCell.init()
        }

        var str = self.settingItems[indexPath.row]
        str.append(": ")
        cell.colorName.text = str;
        
        // Configure the cell...
        cell.accessoryType = .none;
        var colorCode : String? = ""
        

        switch ( indexPath.row ) {
        case 0:
            colorCode = self.colorManager.today()
            break;
        case 1:
            colorCode = self.colorManager.selected()
            break;
        case 2:
            colorCode = self.colorManager.saturday()
            break;
        case 3:
            colorCode = self.colorManager.sunday()
            break;
        case 4:
            colorCode = self.colorManager.holiday()
            break;
        case 5:
            colorCode = self.colorManager.nonWork()
            break;
        default:
            break;
        }
        
        if let colorCode = colorCode, colorCode.isEmpty == false {
            let color = ColorUtil.shared.UIColorFromColorCode(colorCode)
            cell.colorSampleView.backgroundColor = color

            let noshadow = self.traitCollection.userInterfaceStyle == .dark
            cell.colorCode.attributedText = ColorUtil.shared.atributedColorCode(code: colorCode, noShadow: noshadow)
            cell.accessoryType = .disclosureIndicator;
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath
        
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        guard let nextController = storyboard.instantiateViewController(withIdentifier: "BzSelectColorCodeViewController") as? BzSelectColorCodeViewController else {
            return
        }
        
        //nextController.hidesBottomBarWhenPushed = YES;
        
        nextController.colorCodeDelegate = self;
        nextController.title = self.settingItems[indexPath.row]
        var colorCode = "#333333";
        switch (indexPath.row) {
        case 0:
            if let code = self.colorManager.today() {
                colorCode = code
            }
            break;
        case 1:
            if let code = self.colorManager.selected() {
                colorCode = code
            }
            break;
        case 2:
            if let code = self.colorManager.saturday() {
                colorCode = code
            }
            break;
        case 3:
            if let code = self.colorManager.sunday() {
                colorCode = code
            }
            break;
        case 4:
            if let code = self.colorManager.holiday() {
                colorCode = code
            }
            break;
        case 5:
            if let code = self.colorManager.nonWork() {
                colorCode = code
            }
            break;
        default:
            colorCode = "#333333";
            break;
        }
        nextController.originalColorCode = colorCode;
        
        let backTitle = NSLocalizedString("Common_CancelButton_Title", comment: "キャンセル")
        
        let backBarButtonItem = UIBarButtonItem(title: backTitle, style: .done, target: nil, action: nil)
        backBarButtonItem.tintColor = UIColor.white

        self.navigationItem.backBarButtonItem = backBarButtonItem
        // Set custom back button.
        
        self.navigationController?.pushViewController(nextController, animated: true)
        
    }
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

    //#pragma mark ChangedColorCodeHangleProtocol
    
    func selectedColorCode(colorCode:String, object:Any?) {
        switch( self.selectedIndex.row ) {
        case 0:
            self.colorManager.changeTodayColorCode(colorCode)
        case 1:
            self.colorManager.changeSelectedColorCode(colorCode)
        case 2:
            self.colorManager.changeSaturdayColorCode(colorCode)
        case 3:
            self.colorManager.changeSundayColorCode(colorCode)
        case 4:
            self.colorManager.changeHolidayColorCode(colorCode)
        case 5:
            self.colorManager.changeNonWorkColorCode(colorCode)
        default:
            break;
        }
    }

}
