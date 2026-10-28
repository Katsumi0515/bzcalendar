//
//  BzTimePickerViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/04.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzTimePickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate var selectedPath : IndexPath? = nil
    fileprivate var formatter : DateFormatter!

    @IBOutlet weak var tableView: UITableView!
    
    
    
    @IBAction func doneClicked(_ sender: Any) {
        
        print("doneClicked")
     
        self.performSegue(withIdentifier: "unwindToTemplateEditSegue", sender: self)
        

    }
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBAction func timePicked(_ sender: Any) {
        
        self.editTime = timePicker.date
        self.selectedPath = IndexPath(row: 1, section: 0)
        self.tableView.reloadData()
        self.tableView.selectRow(at: self.selectedPath!, animated: false, scrollPosition: .top)

    }

    
    fileprivate var editTime : Date? = nil
    func editTime(time:Date) {
        editTime = time
    }
    func selectedTime() -> Date? {
        if self.selectedPath?.row == 0 {
            return nil
        }
        return self.editTime
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.formatter = DateFormatter()
        self.formatter.dateStyle = .none
        self.formatter.timeStyle = .short
        self.formatter.locale = CalendarManager.shared().appLocale()
        
        if let date = self.editTime {
            self.timePicker.date = date
            self.selectedPath = IndexPath(row: 1, section: 0)
        } else {
            let date = Date()
            self.timePicker.date = date
            self.editTime = date
            self.selectedPath = IndexPath(row: 0, section: 0)
        }
        self.tableView.selectRow(at: self.selectedPath!, animated: false, scrollPosition: .top)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "notSpecifyCell", for: indexPath)
            cell.textLabel?.text = NSLocalizedString("Common_ExactWord_NoSetting", comment: "設定なし")
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath)
            CalendarManager.shared().appLocale()
            
            let time = self.timePicker.date
            cell.textLabel?.text = self.formatter.string(from: time)
        }
        cell.accessoryType = .none
        if let selectedPath = self.selectedPath, indexPath == selectedPath {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPath = indexPath
        self.tableView.reloadData()
        self.tableView.selectRow(at: self.selectedPath!, animated: false, scrollPosition: .top)
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
