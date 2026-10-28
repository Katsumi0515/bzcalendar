//
//  BzTopTabBarController2ViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/06/27.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzTopTabBarController2: UITabBarController, UITabBarControllerDelegate,
BzApplicationTopViewControllerDelegate {
    func selectDefaultDisplayMode() {
        
    }
    
    func currentDisplayMode() -> AppCalendarDisplayMode {
        return AppCalendarDisplayModeDaily
    }
    
    func select(_ mode: AppCalendarDisplayMode) {
        
    }
    
    func refreshCurrentEventView() {
        
    }
    
    func showMainView() {
        
    }
    
    func applicationResumed() {
        
    }
    
    func open(_ event: EKEvent!) {
        
    }
    
    func edit(_ event: EKEvent!) {
        
    }
    
    func addTemplate(_ event: EKEvent!) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
