//
//  BzDayPageViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/16.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

fileprivate extension Date {
    func yesterday() -> Date {
        guard let appCalendar = CalendarManager.shared().appCalendar() else {
            fatalError("appCalendar is nil")
        }
        var diffComps = DateComponents()
        diffComps.day = -1
        let dt = appCalendar.date(byAdding: diffComps, to: self)!
        
        return dt
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


@objc @objcMembers class BzDayPageViewController: UIPageViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    fileprivate var currIndex = 1
    fileprivate var nextIndex = 2
    fileprivate var prevIndex = 0
    
    fileprivate var dayViewControllers : [BzDayViewController] = Array()
    
    fileprivate var prevSelectedDate : Date? = nil
    fileprivate var selectedDate : Date = Date()

    // MARK: - スケジュールの表示
    func displayScedules(forceRefresh:Bool = false) {
        if self.dayViewControllers.count < 3 {
            return
        }

        let date = CalendarManager.shared().selectedDate!
        self.selectedDate = date
        
        var needToUpdate = forceRefresh
        
        if needToUpdate == false {
            if let prevDate = self.prevSelectedDate {
                if prevDate.compare(selectedDate) != .orderedSame {
                    needToUpdate = true
                }
            } else {
                needToUpdate = true
            }
        }
        self.prevSelectedDate = selectedDate
        
        if self.dayViewControllers.count < 3 {
            return
        }
        if needToUpdate == false {
            if self.dayViewControllers[self.currIndex].date.compare(date) != .orderedSame {
                needToUpdate = true
            }
        }

        if needToUpdate == true {
            self.dayViewControllers[self.currIndex].date = date
            self.dayViewControllers[self.prevIndex].date = date.yesterday()
            self.dayViewControllers[self.nextIndex].date = date.tomorrow()
        }
    }

    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNeedsStatusBarAppearanceUpdate()
        
        let storyboard = UIStoryboard(name: "DailyView", bundle: nil)
        let ctrl1 = storyboard.instantiateViewController(withIdentifier: "BzDayViewController") as! BzDayViewController
        let ctrl2 = storyboard.instantiateViewController(withIdentifier: "BzDayViewController") as! BzDayViewController
        let ctrl3 = storyboard.instantiateViewController(withIdentifier: "BzDayViewController") as! BzDayViewController

        self.dayViewControllers = [
            ctrl1,
            ctrl2,
            ctrl3
        ]
        
        self.delegate = self
        self.dataSource = self

        self.displayScedules(forceRefresh: true)

        self.setViewControllers([self.dayViewControllers[self.currIndex]], direction: .forward, animated: false, completion: nil)
     

    }

    override func viewWillAppear(_ animated: Bool) {
        // ToDo: DisplayModeをこのクラス以外で設定するようにする
        CalendarManager.shared().displayMode = AppCalendarDisplayModeDaily

        self.displayScedules(forceRefresh: true)
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

extension BzDayPageViewController: UIPageViewControllerDataSource {
    
    fileprivate func nextViewController(viewController: BzDayViewController, isAfter: Bool) -> UIViewController? {
        guard var index = self.dayViewControllers.index(of: viewController) else {
            return nil
        }
        
        if isAfter {
            index += 1
        } else {
            index -= 1
        }
        
        if index < 0 {
            index = self.dayViewControllers.count - 1
        } else if index == self.dayViewControllers.count {
            index = 0
        }
        
        if index >= 0 && index < self.dayViewControllers.count {
            return self.dayViewControllers[index]
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let ctrl = viewController as! BzDayViewController
        return nextViewController(viewController: ctrl, isAfter: false)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let ctrl = viewController as! BzDayViewController
        return nextViewController(viewController: ctrl, isAfter: true)

    }
    // A page indicator will be visible if both methods are implemented, transition style is 'UIPageViewControllerTransitionStyleScroll', and navigation orientation is 'UIPageViewControllerNavigationOrientationHorizontal'.
    // Both methods are called in response to a 'setViewControllers:...' call, but the presentation index is updated automatically in the case of gesture-driven navigation.
//    @available(iOS 6.0, *)
//    optional public func presentationCount(for pageViewController: UIPageViewController) -> Int // The number of items reflected in the page indicator.
//
//    @available(iOS 6.0, *)
//    optional public func presentationIndex(for pageViewController: UIPageViewController) -> Int // The selected item reflected in the page indicator.

    
}
extension BzDayPageViewController: UIPageViewControllerDelegate  {
    
    fileprivate func _validateAndFix() {
        let yesterday = self.dayViewControllers[self.prevIndex].date
        let today = self.dayViewControllers[self.currIndex].date
        let tomorrow = self.dayViewControllers[self.nextIndex].date
        let appCalendar = CalendarManager.shared().appCalendar()!
        
        let diffOne = appCalendar.dateComponents([.day], from: yesterday, to: today)
        let diffTwo = appCalendar.dateComponents([.day], from: today, to: tomorrow)
        if diffOne.day != 1 || diffTwo.day != 1  {
            print("_validateAndFix date diff is not 1")
            self.displayScedules(forceRefresh: true)
        }
    }

    // Sent when a gesture-initiated transition begins.
//    @available(iOS 6.0, *)
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let ctrl = pendingViewControllers.first as? BzDayViewController else {
            return
        }
        let index = self.dayViewControllers.index(of: ctrl)!
        switch index {
        case self.prevIndex:
            print("moving to prev day")
            let tempIndex = self.nextIndex
            //今日は明日になり
            self.nextIndex = self.currIndex
            //昨日は今日になり
            self.currIndex = self.prevIndex
            //明日は昨日にして、日付を変える
            self.prevIndex = tempIndex

            let date = CalendarManager.shared().selectedDate!
            let newCurrentDate = date.yesterday()
            let newPrevDate = newCurrentDate.yesterday()
            
            self.dayViewControllers[self.prevIndex].date = newPrevDate
            
            self._validateAndFix()
            break
        case self.currIndex:
            break
        case self.nextIndex:
//            self.prevViewCtrl = self.currViewCtrl;
//            self.currViewCtrl = self.nextViewCtrl;
            
            let tempIndex = self.prevIndex
            //今日は昨日になり
            self.prevIndex = self.currIndex
            //明日は今日になり
            self.currIndex = self.nextIndex
            
            //昨日は明日にして、日付を変える
            self.nextIndex = tempIndex
            
            let date = CalendarManager.shared().selectedDate!
            let newCurrentDate = date.tomorrow()
            let newNextDate = newCurrentDate.tomorrow()

            print("moving to next day: ", newNextDate)

            self.dayViewControllers[self.nextIndex].date = newNextDate


            self._validateAndFix()

            break
        default:
            break
        }
    }
    
    
    // Sent when a gesture-initiated transition ends. The 'finished' parameter indicates whether the animation finished, while the 'completed' parameter indicates whether the transition completed or bailed out (if the user let go early).
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let current = self.dayViewControllers[self.currIndex]
        
        // 選択日を変える
        CalendarManager.shared().selectedDate = current.date

    }
    
    
    // Delegate may specify a different spine location for after the interface orientation change. Only sent for transition style 'UIPageViewControllerTransitionStylePageCurl'.
    // Delegate may set new view controllers or update double-sided state within this method's implementation as well.
//    func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
//    }
    
    
    //@available(iOS 7.0, *)
//    func pageViewControllerSupportedInterfaceOrientations(_ pageViewController: UIPageViewController) -> UIInterfaceOrientationMask {
//
//    }
    
    //@available(iOS 7.0, *)
//    func pageViewControllerPreferredInterfaceOrientationForPresentation(_ pageViewController: UIPageViewController) -> UIInterfaceOrientation {
//
//    }

}
