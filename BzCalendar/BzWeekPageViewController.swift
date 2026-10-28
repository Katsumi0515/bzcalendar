//
//  BzWeekPageViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/16.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

fileprivate extension Date {
    func prevWeekDate() -> Date {
        guard let appCalendar = CalendarManager.shared().appCalendar() else {
            fatalError("appCalendar is nil")
        }
        var diffComps = DateComponents()
        diffComps.day = -7
        let dt = appCalendar.date(byAdding: diffComps, to: self)!
        
        return dt
    }
    func nextWeekDate() -> Date {
        guard let appCalendar = CalendarManager.shared().appCalendar() else {
            fatalError("appCalendar is nil")
        }
        var diffComps = DateComponents()
        diffComps.day = 7
        let dt = appCalendar.date(byAdding: diffComps, to: self)!
        
        return dt
    }
}

@objc @objcMembers class BzWeekPageViewController: UIPageViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    fileprivate var currIndex = 1
    fileprivate var nextIndex = 2
    fileprivate var prevIndex = 0
    
    fileprivate var weekViewControllers : [BzWeekViewController] = Array()
    
//    fileprivate var prevSelectedDate : Date? = nil
//    fileprivate var selectedDate : Date = Date() {
//        didSet {
//            print("")
//        }
//    }
//    var selectedDate : Date = Date() {
//        didSet {
//            var needToUpdate = false
//            if let prevDate = self.prevSelectedDate {
//                if prevDate.compare(selectedDate) != .orderedSame {
//                    needToUpdate = true
//                }
//            } else {
//                needToUpdate = true
//            }
//            self.prevSelectedDate = selectedDate
//            
//            guard let date = CalendarManager.shared().selectedDate else {
//                fatalError()
//            }
//            if self.weekViewControllers.count < 3 {
//                return
//            }
//            if needToUpdate == false {
//                if self.weekViewControllers[self.currIndex].date().compare(date) != .orderedSame {
//                    needToUpdate = true
//                }
//            }
//            if needToUpdate == true {
//                self.weekViewControllers[self.currIndex].setDate(date)
//                self.weekViewControllers[self.prevIndex].setDate(date.prevWeekDate())
//                self.weekViewControllers[self.nextIndex].setDate(date.nextWeekDate())
//            }
//            
//        }
//    }

//    func dateWithoutRetainBeforeScrollUnit(num:Int) -> Date {
//        guard let appCalendar = CalendarManager.shared().appCalendar() else {
//            fatalError("appCalendar is nil")
//        }
//        var diffComps = DateComponents()
//        diffComps.day = num * (-1)
//        let dt = appCalendar.date(byAdding: diffComps, to: CalendarManager.shared().selectedDate)!
//        
//        return dt
//        
//    }
    
    
//    func setupDate() {
//        guard let date = CalendarManager.shared().selectedDate else {
//            fatalError()
//        }
//        if self.weekViewControllers.count < 3 {
//            return
//        }
//        self.weekViewControllers[self.currIndex].setDate(date)
//        self.weekViewControllers[self.prevIndex].setDate(date.prevWeekDate())
//        self.weekViewControllers[self.nextIndex].setDate(date.nextWeekDate())
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "BzWeekViewSelectedDateChanged"), object: nil, queue: nil) {
            notification in
            
            self.displaySchedules(forceRefresh: true)
        }
        
        let storyboard = UIStoryboard(name: "WeeklyView", bundle: nil)
        let ctrl1 = storyboard.instantiateViewController(withIdentifier: "BzWeekViewController") as! BzWeekViewController
        let ctrl2 = storyboard.instantiateViewController(withIdentifier: "BzWeekViewController") as! BzWeekViewController
        let ctrl3 = storyboard.instantiateViewController(withIdentifier: "BzWeekViewController") as! BzWeekViewController

        self.weekViewControllers = [
            ctrl1,
            ctrl2,
            ctrl3
        ]
        
        
        self.delegate = self
        self.dataSource = self
        self.setViewControllers([self.weekViewControllers[self.currIndex]], direction: .forward, animated: false, completion: nil)
        
        self.displaySchedules(forceRefresh: true)

    }
    
    func displaySchedules(forceRefresh:Bool = false) {
        if self.weekViewControllers.count < 3 {
            return
        }
        var needToUpdate = forceRefresh
        
        
        guard let selectedDate = CalendarManager.shared().selectedDate else {
            fatalError()
        }
        
        if needToUpdate == false {
            if let currentDate = self.weekViewControllers[self.currIndex].startDate() {
                if currentDate.compare(selectedDate) != .orderedSame {
                    needToUpdate = true
                }
            } else {
                needToUpdate = true
            }
        }
        
        if needToUpdate == true {
            self.weekViewControllers[self.currIndex].setDate( selectedDate )
            guard let startDate = self.weekViewControllers[self.currIndex].startDate() else {
                return
            }
            self.weekViewControllers[self.nextIndex].setDate( startDate.nextWeekDate() )
            self.weekViewControllers[self.prevIndex].setDate( startDate.prevWeekDate() )
            
            self._validateAndFix()
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        // ToDo: DisplayModeをこのクラス以外で設定するようにする
        CalendarManager.shared().displayMode = AppCalendarDisplayModeWeekly
        self.displaySchedules(forceRefresh: false)
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

extension BzWeekPageViewController: UIPageViewControllerDataSource {
    fileprivate func nextViewController(viewController: BzWeekViewController, isAfter: Bool) -> UIViewController? {
        guard var index = self.weekViewControllers.index(of: viewController) else {
            return nil
        }
        
        if isAfter {
            index += 1
        } else {
            index -= 1
        }
        
        if index < 0 {
            index = self.weekViewControllers.count - 1
        } else if index == self.weekViewControllers.count {
            index = 0
        }
        
        if index >= 0 && index < self.weekViewControllers.count {
            return self.weekViewControllers[index]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let ctrl = viewController as! BzWeekViewController
        return nextViewController(viewController: ctrl, isAfter: false)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let ctrl = viewController as! BzWeekViewController
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
extension BzWeekPageViewController: UIPageViewControllerDelegate  {
    fileprivate func _validateAndFix() {
        let dateOfEndDateOfPrevView = self.weekViewControllers[self.prevIndex].endDate()
        guard let dateOfStartDateOfCurrView = self.weekViewControllers[self.currIndex].startDate() else {
            return
        }
        let dateOfEndDateOfCureView = self.weekViewControllers[self.currIndex].endDate()
        guard let dateOfStartDateOfNextView = self.weekViewControllers[self.nextIndex].startDate() else {
            return
        }
        
        let appCalendar = CalendarManager.shared().appCalendar()!

        let diffOne = appCalendar.dateComponents([.day], from: dateOfEndDateOfPrevView, to: dateOfStartDateOfCurrView)
        let diffTwo = appCalendar.dateComponents([.day], from: dateOfEndDateOfCureView, to: dateOfStartDateOfNextView)
        if diffOne.day != 1 || diffTwo.day != 1  {
            print("diffOne: ", diffOne.day)
            print("diffTwo: ", diffTwo.day)
            
            self.displaySchedules(forceRefresh: true)
        }

    }
    
    // Sent when a gesture-initiated transition begins.
    //    @available(iOS 6.0, *)
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let ctrl = pendingViewControllers.first as? BzWeekViewController, let date = ctrl.startDate() else {
            return
        }
        let index = self.weekViewControllers.index(of: ctrl)!
        print("pendingViewControllers: ", index)
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
            
            //let newCurrentDate = date.prevWeekDate()
            //let newPrevDate = newCurrentDate.prevWeekDate()
            let newPrevDate = date.prevWeekDate()
            
            self.weekViewControllers[self.prevIndex].setDate(newPrevDate)
            
            // 基準日も変える
            //CalendarManager.shared().selectedDate = newCurrentDate
            //CalendarManager.shared().selectedDate = date

            self._validateAndFix()
            break
        case self.currIndex:
            break
        case self.nextIndex:
            print("moving to next day")
            //            self.prevViewCtrl = self.currViewCtrl;
            //            self.currViewCtrl = self.nextViewCtrl;
            
            let tempIndex = self.prevIndex
            //今日は昨日になり
            self.prevIndex = self.currIndex
            //明日は今日になり
            self.currIndex = self.nextIndex
            
            //昨日は明日にして、日付を変える
            self.nextIndex = tempIndex
            
//            let newCurrentDate = date.nextWeekDate()
//            let newNextDate = newCurrentDate.nextWeekDate()
            let newNextDate = date.nextWeekDate()
            self.weekViewControllers[self.nextIndex].setDate(newNextDate)
            
            // 基準日も変える
            //CalendarManager.shared().selectedDate = newCurrentDate
            //CalendarManager.shared().selectedDate = date

            self._validateAndFix()
            
            break
        default:
            break
        }
    }
    
    
    // Sent when a gesture-initiated transition ends. The 'finished' parameter indicates whether the animation finished, while the 'completed' parameter indicates whether the transition completed or bailed out (if the user let go early).
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let current = self.weekViewControllers[self.currIndex]
        
        // 選択日を変える
        CalendarManager.shared().selectedDate = current.startDate()

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

