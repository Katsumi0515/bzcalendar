//
//  BzMonthViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/06/08.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

protocol BzMonthViewSelectedDateChangeDelegate  {
    func selected(date:Date)
}

class BzMonthViewController: UIViewController, BzMonthViewSelectedDateChangeDelegate {
    
    // スケジュールデータ
    fileprivate var monthDataContainer : BZVMMonthlyViewContents!

    // [View 1] ナビゲーションバー
    @IBOutlet weak var monthBar: BzMonthBar!
    

    @IBOutlet weak var weeklyViews: UIStackView!
    
    @IBOutlet weak var monthView: UIView!
    
    @IBOutlet weak var weekView1: BzMonthViewWeeklyView!
    @IBOutlet weak var weekView2: BzMonthViewWeeklyView!
    @IBOutlet weak var weekView3: BzMonthViewWeeklyView!
    @IBOutlet weak var weekView4: BzMonthViewWeeklyView!
    @IBOutlet weak var weekView5: BzMonthViewWeeklyView!
    @IBOutlet weak var weekView6: BzMonthViewWeeklyView!
    
    fileprivate var needToUpdateContents : Bool = false
    fileprivate var weekViewArray : Array<BzMonthViewWeeklyView> = Array()
    
    // MARK: - BzMonthViewSelectedDateChangeDelegate
    func selected(date: Date) {
        CalendarManager.shared().selectedDate = date
        self.monthDataContainer.selectedDate(date: date)
        if date.compare(self.monthDataContainer.monthStartDate) == .orderedAscending {
            // 先月
        } else if date.compare(self.monthDataContainer.monthEndDate) == .orderedDescending {
            // 翌月
        } else {
            self.needToUpdateContents = true
            self.view.setNeedsLayout()
        }
    }
    
    // MARK: -
    func setDate(_ date:Date) {
        self.monthDataContainer = BzScheduleQueryService.shared.monthSchedule(containsDate: date)
        self.needToUpdateContents = true
        DispatchQueue.main.async {
            // 既にアップデートされていたらアップデート不要
            // 処理がasyncなのであり得る
            if self.needToUpdateContents == true {
                if self.isViewLoaded == true {
                    self.updateUIComponents()
                }
            }
        }
    }
    
    func date() -> Date {
        if self.monthDataContainer != nil {
            return self.monthDataContainer.monthStartDate
        }
        return Date()
    }
    
    func monthStartDate() -> Date? {
        if let container = self.monthDataContainer {
            return container.monthStartDate
        }
        return nil
    }
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "AppEventKit_EventStoreChanged"), object: nil, queue: nil) {
            note in
            if self.monthDataContainer != nil {
                self.setDate(self.monthDataContainer.monthStartDate)
            }

        }
        // StatusBarの色を変えたいだけなんですけどね。。。
        self.view.backgroundColor = BzAppThemeService.shared.themeColor()
        
        // Do any additional setup after loading the view.
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
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "DayCellViewSelectedDateChanged"), object: nil, queue: nil) {
            notification in
            self.updateUIComponents()
            self.view.setNeedsLayout()
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = BzAppThemeService.shared.themeColor()

        self.updateUIComponents()
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.needToUpdateContents == true {
            self.updateUIComponents()
        }
    }
    
    override func viewWillLayoutSubviews() {
        if self.needToUpdateContents == true {
            self.updateUIComponents()
        }
    }
    
    override func viewDidLayoutSubviews() {
        if self.needToUpdateContents == true {
            self.updateUIComponents()
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

    fileprivate func updateUIComponents() {
        if self.monthDataContainer == nil {
            return
        }
        print("BzMonthViewControlle.updateUIComponents: ", self)
        
        self.monthDataContainer.selectedDate(date: CalendarManager.shared().selectedDate)
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
        
        self.needToUpdateContents = false
    }
}
