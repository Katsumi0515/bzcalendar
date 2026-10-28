//
//  BzEditRecurrenceDateByDatesTblViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/09.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzEditRecurrenceDateByDatesTblViewController: UITableViewController {

    @IBOutlet weak var doneButtonItem: UIBarButtonItem!
    
    @IBAction func doneClicked(_ sender: Any) {
        if let delegate = self.recurrenceDateChangeProtocol {
            self.daysOfTheMonth.sort {
                return $0 < $1
            }
            delegate.daysOfTheMonthChanged(array: self.daysOfTheMonth)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    var recurrenceDateChangeProtocol : BzRecurrenceDaysOfTheMonthChangedDelegate? = nil
    
    var canSelectEndOfMonth : Bool = false
    
    fileprivate var daysOfTheMonth : Array<Int> = Array() {
        didSet {
            
        }
    }
    func daysOfTheMonth(array:Array<Int>) {
        self.daysOfTheMonth = Array(array)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("ViewTitle_Event_RecurrenceDateByDate",
                                       comment:"日付指定");
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
        if self.canSelectEndOfMonth == true {
            return 32
        }
        return 31
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath)
        
        let num = indexPath.row + 1
        var day = num
        if num == 32 {
            day = -1
            // 月末
            cell.textLabel?.text = NSLocalizedString("Common_ExactWord_EndOfMonth",
                                                     comment:"月末")
        } else {
            cell.textLabel?.text = String(num)
        }
        cell.accessoryType = .none
        if self.daysOfTheMonth.contains(day) {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let intNum = indexPath.row + 1
        var day = intNum
        if intNum == 32  {
            day = -1
        }
        if let idx = self.daysOfTheMonth.index(of: day) {
            // found
            self.daysOfTheMonth.remove(at: idx)
        } else {
            // not found
            self.daysOfTheMonth.append(day)
        }
        self.tableView.reloadData()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
