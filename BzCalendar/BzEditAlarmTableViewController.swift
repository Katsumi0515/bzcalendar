//
//  BzEditAlarmTableViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/07.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

protocol EditEKAlarmProtocol {
    func add(alarm: EKAlarm)
    func replace(alarm:EKAlarm, with newAlarm:EKAlarm)
}

fileprivate class PaddingTextField : UITextField {
    /// テキストの内側の余白
    @IBInspectable var padding: CGPoint = CGPoint(x: 8.0, y: 0.0)
    
    // MARK: Internal Methods
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        // テキストの内側に余白を設ける
        return bounds.insetBy(dx: self.padding.x, dy: self.padding.y)
    }

}
class BzEditAlarmTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBAction func doneClicked(_ sender: Any) {
        
        if let delegate = self.addAlarmDelegate , let alarm = self.editAlarm {
            if let originalAlarm = self.originalAlarm {
                delegate.replace(alarm:originalAlarm, with: alarm)
            } else {
                delegate.add(alarm:alarm)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupAlarm(alarm:EKAlarm) {
        originalAlarm = alarm
        editAlarm = alarm
    }
    func setAlarm(alarm:EKAlarm) {
        originalAlarm = alarm
        editAlarm = alarm
    }

    fileprivate var unitStringList : [String] = Array()


    var addAlarmDelegate : EditEKAlarmProtocol? = nil
    
    fileprivate var originalAlarm : EKAlarm? = nil
    fileprivate var editAlarm : EKAlarm? = nil
    
    @IBOutlet weak var cellForCurrentAlarm: UITableViewCell!
    
    
    @IBOutlet weak var alarmPicker: UIPickerView!
    
    @IBOutlet weak var sameTimeLabel: UILabel!
    @IBOutlet weak var sameTimeSwitch: UISwitch!
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        if self.sameTimeSwitch.isOn == true {
            self.alarmPicker.selectRow(0, inComponent: 0, animated: true)
            self.alarmPicker.selectRow(0, inComponent: 1, animated: true)
        }
        self._setNewAlarmFromPicker()
        //self.cellForCurrentAlarm.textLabel?.text = ""
    }
    fileprivate func _setPickerFromAlarm() {
        guard let editAlarm = self.editAlarm else {
            return
        }
        if editAlarm.absoluteDate != nil {
            // ToDo: AbsoluteDateの変更には対応していない旨、表示する
        } else {
            let offsetInterval = TimeInterval(fabs(editAlarm.relativeOffset))
            
            let dayInt = Int(offsetInterval / (60*60*24))
            var remain = (Int(offsetInterval)) % (60*60*24)
            let hourInt = remain / (60*60)
            remain = remain % (60*60);
            let minInt = remain / 60;
    
            if dayInt > 0  {
                self.alarmPicker.selectRow(dayInt, inComponent: 0, animated: true)
                self.alarmPicker.selectRow(2, inComponent: 1, animated: true)
            } else if hourInt > 0  {
                self.alarmPicker.selectRow(hourInt, inComponent: 0, animated: true)
                self.alarmPicker.selectRow(1, inComponent: 1, animated: true)
            } else if minInt > 0 {
                self.alarmPicker.selectRow(minInt, inComponent: 0, animated: true)
                self.alarmPicker.selectRow(0, inComponent: 1, animated: true)
            }
            self.tableView.reloadData()
        }
    
    }

    fileprivate func _setNewAlarmFromPicker() {
        let num = self.alarmPicker.selectedRow(inComponent: 0)
        let unitIdx = self.alarmPicker.selectedRow(inComponent: 1)
        var multipleBy : Int = 0
        switch (unitIdx) {
        case 0:
            multipleBy = 60
        case 1:
            multipleBy = (60 * 60)
        case 2:
            multipleBy = (60 * 60 * 24)
        default:
            break;
        }
        let interval : TimeInterval = TimeInterval((-1) * num * multipleBy)
        self.editAlarm = EKAlarm(relativeOffset: interval)
        
        self.cellForCurrentAlarm.textLabel?.text = self.editAlarm?.stringValue()
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sameTimeLabel.text = NSLocalizedString("EditAlarm_SameAsEventDate",
                                                    comment:"イベントと同日時")
        self.sameTimeSwitch.isOn = false
        
        self.unitStringList = [
            NSLocalizedString("EditAlarm_MinutesBefore", comment:"分前"),
            NSLocalizedString("EditAlarm_HoursBefore", comment:"時間前"),
            NSLocalizedString("EditAlarm_DaysBefore", comment:"日前")
        ]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        if self.originalAlarm == nil {
            self.navigationItem.title = NSLocalizedString("ViewTitle_Event_Alarm_Add",
                                                          comment:"通知の追加")
        } else {
            self.navigationItem.title = NSLocalizedString("ViewTitle_Event_Alarm_Edit", comment:"通知の変更")
        }
        if let originalAlarm = self.originalAlarm {
            if let absoluteDate = originalAlarm.absoluteDate {
                self.editAlarm = EKAlarm(absoluteDate: absoluteDate)
            } else {
                self.editAlarm = EKAlarm(relativeOffset:originalAlarm.relativeOffset)
            }
        } else {
            let interval = TimeInterval(-60 * 10)
            self.editAlarm = EKAlarm(relativeOffset:interval)
        }
        self._setPickerFromAlarm()
        self._setNewAlarmFromPicker()
        
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
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

    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var rtn : Int = 0
        
        if( pickerView == alarmPicker ) {
            switch (component) {
            case 0:
                rtn = 365
                break;
            case 1:
                rtn = unitStringList.count
                break;
            default:
                break;
            }
        }
        return rtn;
        
    }

    // MARK: - UIPickerViewDelegate
    
    // returns width of column and height of row for each component.
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let pickerWidth = pickerView.frame.size.width
        let totalWidthToUse = pickerWidth - 16
        
        var rtnVal : CGFloat = totalWidthToUse
        switch (component) {
        case 0:
            rtnVal = totalWidthToUse * 0.5
            break;
        case 1:
            rtnVal = totalWidthToUse * 0.5
            break;
        default:
            break;
        }
        return rtnVal;

    }
        
    //optional public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat

        
    // these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
    // for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
    // If you return back a different object, the old one will be released. the view will be centered in the row rect
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//
//        switch (component) {
//        case 0:
//            return String(row)
//        case 1:
//            return self.unitStringList[row]
//        default:
//            break;
//        }
//        return ""
//
//    }
//    @available(iOS 6.0, *)
//    optional public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? // attributed title is favored if both methods are implemented
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var textField : PaddingTextField? = nil
        
        if let temp = view as? PaddingTextField {
            textField = temp
        } else {
        
//            CGRect rect;
//            rect = self.view.bounds;
//            rect.size.height = 20;
            textField = PaddingTextField()
            textField?.isUserInteractionEnabled = false
            textField?.font = UIFont.boldSystemFont(ofSize: 16)
        }
        switch (component) {
        case 0:
            textField?.textAlignment = .right
            textField?.text = String(row)
            break;
        case 1:
            textField?.textAlignment = .left
            textField?.text = self.unitStringList[row]
            break;
        default:
            break;
        }
        return textField!

    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self._setNewAlarmFromPicker()
    }

}
