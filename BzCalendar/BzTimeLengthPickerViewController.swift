//
//  BzTimeLengthPickerViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/04.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzTimeLengthPickerViewController: UIViewController {

    @IBAction func doneClicked(_ sender: Any) {
        
        
        print("doneClicked")
            
        self.performSegue(withIdentifier: "unwindToTemplateEditSegue", sender: self)
            
    }
    
    var timeLengthComps : DateComponents? = nil
    
    @IBOutlet weak var timeLengthPicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        let calendar = Calendar(identifier: .gregorian)

        if self.timeLengthComps == nil {
            var comps = DateComponents()
            comps.hour = 1
            comps.minute = 0
            if let date = calendar.date(from: comps) {
                self.timeLengthPicker.date = date
            }
        } else {
            if let date = calendar.date(from: self.timeLengthComps!) {
                self.timeLengthPicker.date = date
            }
        }
        
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

}
