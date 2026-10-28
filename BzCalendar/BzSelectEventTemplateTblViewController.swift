//
//  BzSelectEventTemplateTblViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/14.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

protocol BzSelectEventTemplateDelegate {
    func selectedEventTemplate(template:AppEventTemplate)
}

class BzSelectEventTemplateTblViewController: UITableViewController {

    @IBOutlet weak var doneButtonItem: UIBarButtonItem!
    
    @IBAction func doneClicked(_ sender: Any) {
        if self.templateNotExist() {
            self.navigationController?.popViewController(animated: true)
            return
        }
        if let selectedPath = self.selectedPath {
            let template = self.templateArray[selectedPath.row]
            if let delegate = self.eventTemplateDelegate {
                delegate.selectedEventTemplate(template:template)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate var templateArray: Array<AppEventTemplate> = Array()
    fileprivate func templateNotExist() -> Bool {
        return templateArray.count < 1
    }
    fileprivate var selectedPath : IndexPath? = nil
    
    var eventTemplateDelegate : BzSelectEventTemplateDelegate? = nil

    @objc func doubleTap(tap:UISwipeGestureRecognizer) {
        if tap.state == .ended {
            if self.templateNotExist() {
                self.navigationController?.popViewController(animated: true)
            } else {
                let p = tap.location(in: tap.view)
                guard let indexPath = self.tableView.indexPathForRow(at: p) else {
                    return
                }
                
                let template = self.templateArray[indexPath.row]
                if let delegate = self.eventTemplateDelegate {
                    delegate.selectedEventTemplate(template:template)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Common_ExactWord_Template", comment:"テンプレート")

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTap))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        self.tableView.addGestureRecognizer(doubleTap)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.templateArray = BzEventExtensionService.shared().eventTemplate()
        self.tableView.reloadData()
        self.doneButtonItem.isEnabled = (self.selectedPath != nil)
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
        var rtnVal : Int = 1
        if self.templateNotExist() {
            return rtnVal
        }
        rtnVal = self.templateArray.count
        
        return rtnVal;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if self.templateNotExist() {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellForNoTemplates", for: indexPath)
            cell.textLabel?.text = NSLocalizedString("EventTemplate_Cell_NoTemplate", comment:"Templateは登録されていません")
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellForTemplate", for: indexPath) as? BzSelectEventTemplateCell else {
            fatalError()
        }
        
        let eventTemplate = self.templateArray[indexPath.row]
        cell.templateTitleLabel.text = eventTemplate.title
        if let calendar = eventTemplate.calendar {
            cell.calendarColorSampleView.backgroundColor = calendar.bgColor()
        }
        
        cell.accessoryType = .none
        if let selectedPath = self.selectedPath, indexPath == selectedPath {
            cell.accessoryType = .checkmark
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.templateNotExist()  {
            return
        }
        
        self.selectedPath = indexPath
        self.doneButtonItem.isEnabled = true
        self.tableView.reloadData()
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
