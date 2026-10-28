//
//  BzSelectColorFromListTblViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/04/09.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzSelectColorFromListTblViewController: UITableViewController {

    fileprivate var colorPalletManager : ColorPalletManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.colorPalletManager = ColorPalletManager.shared

        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let palletMgr = self.colorPalletManager else {
            return 0
        }
        return palletMgr.palletCount()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let palletMgr = self.colorPalletManager else {
            return 0
        }
        let dataArray = palletMgr.palletData(at: section) 
        return dataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BzSelectColorCodeViewController_CustomColorCell", for: indexPath) as? BzColorSettingTableViewCell else {
            return UITableViewCell.init()
        }

        let palletIndex = indexPath.section
        
        let row  = indexPath.row;
        // Set up the cell...
        if let palletMgr = self.colorPalletManager {
            let palletData = palletMgr.palletData(at: palletIndex)
            if row < palletData.count {
                let colorCD = palletData[row]
                let color =  ColorUtil.shared.UIColorFromColorCode(colorCD.colorCode)
                
                cell.colorSampleView.backgroundColor = color
                cell.colorName.text = colorCD.colorName
                //cell.colorCode.text = colorCD.colorCode
                let noshadow = self.traitCollection.userInterfaceStyle == .dark

                cell.colorCode.attributedText = ColorUtil.shared.atributedColorCode(code: colorCD.colorCode, noShadow: noshadow)
            }
        }
    
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var rtnVal : String = ""
        
        guard let palletManager = self.colorPalletManager else {
            return rtnVal
        }
        rtnVal = palletManager.palletName(at: section)
        return rtnVal;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let palletManager = self.colorPalletManager else {
            return
        }
        let colors = palletManager.palletData(at: indexPath.section)
        let colorCD = colors[indexPath.row] 
        
        // コンテナコントローラーに選択したものを伝える
        
        guard let parent = self.parent as? BzSelectColorCodeViewControllerDelegate else {
            return
        }
        parent.updateCurrentColorCode(colorCode: colorCD.colorCode)
        //self.currentColorCode colorCD.colorCode
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

}

