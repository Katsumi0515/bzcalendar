//
//  BzDefaultCalendarColorTableViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/04/27.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzDefaultCalendarColorTableViewController: UITableViewController {

    var calendar : EKCalendar!
    fileprivate var originalColor : UIColor?
    
    @IBOutlet weak var colorSampleView: UIView!
    @IBOutlet weak var defaultColorLabel: UILabel!
    @IBOutlet weak var defaultColorCodeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.originalColor = self.calendar.originalColor()
        
        self.colorSampleView.backgroundColor = self.originalColor
        self.defaultColorLabel.text = "Default Color"
        let colorCode = ColorUtil.shared.colorCode(color:self.originalColor!)
        let noshadow = self.traitCollection.userInterfaceStyle == .dark
        self.defaultColorCodeLabel.attributedText = ColorUtil.shared.atributedColorCode(code: colorCode, noShadow: noshadow)
    
//        self.defaultColorCodeLabel.attributedText = ColorUtil.shared.atributedColorCode(code: colorCode)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let parent = self.parent as? BzSelectColorCodeViewControllerDelegate else {
            return
        }
        guard let color = self.originalColor else {
            return
        }
        let colorCode = ColorUtil.shared.colorCode(color: color)
        parent.updateCurrentColorCode(colorCode: colorCode)
        
    }
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
