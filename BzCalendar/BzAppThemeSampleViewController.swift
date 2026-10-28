//
//  BzAppThemeSampleViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/17.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

fileprivate extension Date {
    
    func isToday() -> Bool {
        let unit : Set<Calendar.Component> = [.year, .month, .day ]
        let appCalendar = CalendarManager.shared().appCalendar()!
        let compToday = appCalendar.dateComponents(unit, from: Date())
        let comp = appCalendar.dateComponents(unit, from: self)
        
        return compToday.day! == comp.day! && compToday.month! == comp.month! && compToday.year! == comp.year!
    }
    func tomorrow() -> Date {
        guard let appCalendar = CalendarManager.shared().appCalendar() else {
            fatalError("appCalendar is nil")
        }
        var diffComps = DateComponents()
        diffComps.day = 1
        let dt = appCalendar.date(byAdding: diffComps, to: self)!
        
        return dt
    }

}


class BzAppThemeSampleViewController: UIViewController,BzMonthViewSelectedDateChangeDelegate {
    func selected(date: Date) {
        self.monthDataContainer.selectedDate(date: date)
        if date.compare(self.monthDataContainer.monthStartDate) == .orderedAscending {
            // 先月
        } else if date.compare(self.monthDataContainer.monthEndDate) == .orderedDescending {
            // 翌月
        } else {
           // self.needToUpdateContents = true
            self.view.setNeedsLayout()
        }

    }
    

    @IBOutlet weak var weekView1: BzSampleMonthViewWeeklyView!
    @IBOutlet weak var weekView2: BzSampleMonthViewWeeklyView!
    @IBOutlet weak var weekView3: BzSampleMonthViewWeeklyView!
    @IBOutlet weak var weekView4: BzSampleMonthViewWeeklyView!
    @IBOutlet weak var weekView5: BzSampleMonthViewWeeklyView!
    @IBOutlet weak var weekView6: BzSampleMonthViewWeeklyView!

    fileprivate var weekViewArray : Array<BzSampleMonthViewWeeklyView> = Array()

    
    var sampleThemeColor: UIColor = .black {
        didSet {
            self.view.setNeedsLayout()
        }
    }
    var sampleThemeTextColor : UIColor = .white {
        didSet {
            self.view.setNeedsLayout()
        }
    }
    // スケジュールデータ
    fileprivate var monthDataContainer : BZVMMonthlyViewContents!

    
    @IBOutlet weak var dummyStatusBar: UIView!
    @IBOutlet weak var monthBar: BzMonthBar!
    @IBOutlet weak var tabBar: UITabBar!
    
    fileprivate func updateUIComponents() {
        if self.monthDataContainer == nil {
            return
        }
        print("BzMonthViewControlle.updateUIComponents: ", self)
        
//        self.monthDataContainer.selectedDate(date: CalendarManager.shared().selectedDate)
        self.monthBar.date = self.monthDataContainer.monthStartDate
        
        let weekDataArray = self.monthDataContainer.weekDataArray()
        switch weekDataArray.count {
        case 4:
            self.weekView5.isHidden = true
            self.weekView6.isHidden = true
            break
        case 5:
            self.weekView5.isHidden = false
            self.weekView6.isHidden = true
            break
        case 6:
            self.weekView5.isHidden = false
            self.weekView6.isHidden = false
            break
        default:
            break
        }
        
        self.view.updateConstraintsIfNeeded()
        for idx in 0..<weekDataArray.count {
            let weekData = weekDataArray[idx]
            let weekView = self.weekViewArray[idx]
            weekView.setWeekData(data: weekData)
            weekView.setNeedsLayout()
        }
        self.view.setNeedsLayout()
        
//        self.needToUpdateContents = false
    }

    fileprivate func updateSampleTheme() {
        self.dummyStatusBar.backgroundColor = self.sampleThemeColor
        self.monthBar.date = self.date()
        self.monthBar.backgroundColor = self.sampleThemeColor
        self.tabBar.barTintColor = self.sampleThemeColor
        self.tabBar.tintColor = self.sampleThemeTextColor

    }
    
    fileprivate func date() -> Date {
        return self.monthDataContainer.monthStartDate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.monthDataContainer = BzScheduleQueryService.shared.monthSchedule(containsDate: Date())
        //        self.needToUpdateContents = true

        let monthStartDate = self.monthDataContainer.monthStartDate
        if monthStartDate.isToday() == false {
            self.selected(date: monthStartDate)
        } else {
            self.selected(date: monthStartDate.tomorrow())
        }

        self.weekViewArray = [
            self.weekView1,
            self.weekView2,
            self.weekView3,
            self.weekView4,
            self.weekView5,
            self.weekView6
        ]
        for weekView in self.weekViewArray {
            weekView.selectedDateDelegate = self
        }
        
//        self.needToUpdateContents = true
//            if self.needToUpdateContents == true {
//                if self.isViewLoaded == true {
//                    self.updateUIComponents()
//                }
//            }
        self.updateUIComponents()

        self.updateSampleTheme()
        self.tabBar.selectedItem = self.tabBar.items?[1]
        // Do any additional setup after loading the view.
    }

    override func viewWillLayoutSubviews() {
        self.updateUIComponents()

        self.updateSampleTheme()
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
