//
//  BzSelectColorFromRGBViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/04/09.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzSelectColorFromRGBViewController: UIViewController {

    
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var redValueLabel: UILabel!
    @IBOutlet weak var greenValueLabel: UILabel!
    @IBOutlet weak var blueValueLabel: UILabel!

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let red = Int(self.redSlider.value)
        let green = Int(self.greenSlider.value)
        let blue = Int(self.blueSlider.value)
        self.redValueLabel.text = String(red)
        self.greenValueLabel.text = String(green)
        self.blueValueLabel.text = String(blue)
        
        let colorCode = String(format: "#%02x%02x%02x", red, green, blue)

        guard let parent = self.parent as? BzSelectColorCodeViewControllerDelegate else {
            return
        }
        
        parent.updateCurrentColorCode(colorCode: colorCode)
    }
    
    func setupSliderValues(colorCode:String) {
        var r : UInt32 = 0
        var g : UInt32 = 0
        var b : UInt32 = 0

        if colorCode.isEmpty == true {
            self.redSlider.setValue(Float(r), animated: true)
            self.greenSlider.setValue(Float(g), animated: true)
            self.blueSlider.setValue(Float(b), animated: true)
            return
        }
        let code = colorCode as NSString
        let rRange = NSMakeRange(1, 2)
        let gRange = NSMakeRange(3, 2)
        let bRange = NSMakeRange(5, 2)
        
        let rString = code.substring(with: rRange)
        let gString = code.substring(with: gRange)
        let bString = code.substring(with: bRange)
    
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)

        self.redSlider.setValue(Float(r), animated: true)
        self.greenSlider.setValue(Float(g), animated: true)
        self.blueSlider.setValue(Float(b), animated: true)
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        if let parent = self.parent as? BzSelectColorCodeViewControllerDelegate {
            
            self.setupSliderValues(colorCode: parent.currentColorCode())
        }

        super.viewWillAppear(animated)
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
