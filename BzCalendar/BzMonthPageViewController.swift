                                                                                                                                                                                                                                                                                                             //
//  BzMonthPageViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/16.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

fileprivate extension Date {
    func prevMonthDate(step:Int = 1) -> Date {
        guard let appCalendar = CalendarManager.shared().appCalendar() else {
            fatalError("appCalendar is nil")
        }
        
        let unitFlag : Set<Calendar.Component> = [.year, .month, .day, .weekday]
        
        // 日時分なしの日付とするため再計算
        var comps = appCalendar.dateComponents(unitFlag, from: self)
        // 月初を設定
        comps.day = 1
        let firstDateOfMonth = appCalendar.date(from: comps)!
        var diffComps = DateComponents()
        diffComps.month = -step
        
        let rtnDate = appCalendar.date(byAdding: diffComps, to: firstDateOfMonth)!
        
        return rtnDate
    }
    func nextMonthDate(step:Int = 1) -> Date {
        guard let appCalendar = CalendarManager.shared().appCalendar() else {
            fatalError("appCalendar is nil")
        }
        
        let unitFlag : Set<Calendar.Component> = [.year, .month, .day, .weekday]
        
        // 日時分なしの日付とするため再計算
        var comps = appCalendar.dateComponents(unitFlag, from: self)
        // 月初を設定
        comps.day = 1
        let firstDateOfMonth = appCalendar.date(from: comps)!
        
        var diffComps = DateComponents()
        diffComps.month = step
        
        let rtnDate = appCalendar.date(byAdding: diffComps, to: firstDateOfMonth)!
        
        return rtnDate
    }
} // extension Date

@objc @objcMembers class BzMonthPageViewController: UIPageViewController, UIPageViewControllerDelegate {
    
    fileprivate var prevSelectedDate : Date? = nil
    func selectedDate(_ selectedDate: Date) {
        var needToUpdate = false
        if let prevDate = self.prevSelectedDate {
            if prevDate.compare(selectedDate) != .orderedSame {
                needToUpdate = true
            }
        } else {
            needToUpdate = true
        }
        self.prevSelectedDate = selectedDate
        
        guard let date = CalendarManager.shared().selectedDate else {
            fatalError()
        }
        if self.monthViewControllers.count < 3 {
            return
        }
        if needToUpdate == false {
            if self.monthViewControllers[self.currIndex].date().compare(date) != .orderedSame {
                needToUpdate = true
            }
        }
        if needToUpdate == true {
            self.monthViewControllers[self.currIndex].setDate(date)
            self.monthViewControllers[self.prevIndex].setDate(date.prevMonthDate())
            self.monthViewControllers[self.nextIndex].setDate(date.nextMonthDate())
        }

    }
    
    fileprivate var moveToNextMonth : Bool? = false

    fileprivate var currIndex = 1
    fileprivate var nextIndex = 2
    fileprivate var prevIndex = 0
    
    fileprivate var monthViewControllers : [BzMonthViewController] = Array()
    
    
    func dateWithoutRetainBeforeScrollUnit(num:Int) -> Date {
        guard let appCalendar = CalendarManager.shared().appCalendar() else {
            fatalError("appCalendar is nil")
        }
        var diffComps = DateComponents()
        diffComps.day = num * (-1)
        let dt = appCalendar.date(byAdding: diffComps, to: CalendarManager.shared().selectedDate)!
        
        return dt
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // ToDo: 
    // viewDidLoadの時にサブビューを作成して置きたいので、mustUpdateをtrueにする必要がある
    // 初期化過程の処理と、本来の呼ばれ方の処理はメソッドを分けた方がいいかもしれない
//    fileprivate func setupDate(mustUpdate:Bool = false) {
//        guard let date = CalendarManager.shared().selectedDate else {
//            fatalError()
//        }
//        if self.monthViewControllers.count < 3 {
//            return
//        }
//        var update = mustUpdate
//        if update == false {
//            if self.monthViewControllers[self.currIndex].date().compare(date) != .orderedSame {
//                update = true
//            }
//        }
//        if update == true {
//            self.monthViewControllers[self.currIndex].setDate(date)
//            self.monthViewControllers[self.prevIndex].setDate(date.prevMonthDate())
//            self.monthViewControllers[self.nextIndex].setDate(date.nextMonthDate())
//        }
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()

        // ToDo:
        // ユニットテストへ移動
        // 昔からあるプロジェクトにユニットテストを追加しようとするとコンパイルエラーが出すぎるので、
        // ここでテストしている
//        let calendar = Calendar.current
//        let testYear = 2018
//        let testMonth = 12
//        let testDay = 6
//        let testExpFromYear = 2018
//        let testExpFromMonth = 11
//        let testExpFromDay = 25
//        
//        var testDateComp = DateComponents()
//        testDateComp.year = testYear
//        testDateComp.month = testMonth
//        testDateComp.day = testDay
//        
//        var expFromDateComp = DateComponents()
//        expFromDateComp.year = testExpFromYear
//        expFromDateComp.month = testExpFromMonth
//        expFromDateComp.day = testExpFromDay
//        let expFromDate = calendar.date(from: expFromDateComp)!
//        
//        var expMonthStartDateComp = DateComponents()
//        expMonthStartDateComp.year = testYear
//        expMonthStartDateComp.month = testMonth
//        expMonthStartDateComp.day = 1
//        let expMonthStartDate = calendar.date(from: expMonthStartDateComp)!
//        
//        var expMonthEndDateComp = DateComponents()
//        expMonthEndDateComp.year = testYear
//        expMonthEndDateComp.month = testMonth
//        expMonthEndDateComp.day = 31
//        let expMonthEndDate = calendar.date(from: expMonthEndDateComp)!
//        
//        var expToDateComp = DateComponents()
//        expToDateComp.year = 2019
//        expToDateComp.month = 1
//        expToDateComp.day = 5
//        let expToDate = calendar.date(from: expToDateComp)!
//        
//        let testDate = calendar.date(from: testDateComp)!
//        let sched = MonthScheduleComponent(containsDate:testDate)
//        let fromDate = sched.fromDate
//        let toDate = sched.toDate
//        let monthStartDate = sched.monthStartDate
//        let monthEndDate = sched.monthEndDate
//
        
        // ここまでテスト
                
        let storyboard = UIStoryboard(name: "MonthlyView", bundle: nil)
        
        let ctrl1 = storyboard.instantiateViewController(withIdentifier: "BzMonthViewController") as! BzMonthViewController
        let ctrl2 = storyboard.instantiateViewController(withIdentifier: "BzMonthViewController") as! BzMonthViewController
        let ctrl3 = storyboard.instantiateViewController(withIdentifier: "BzMonthViewController") as! BzMonthViewController

        self.monthViewControllers = [
            ctrl1,
            ctrl2,
            ctrl3
        ]
//        self.monthViewControllers[self.currIndex].loadViewIfNeeded()
//        self.monthViewControllers[self.prevIndex].loadViewIfNeeded()
//        self.monthViewControllers[self.nextIndex].loadViewIfNeeded()

        self.delegate = self
        self.dataSource = self
        self.setViewControllers([self.monthViewControllers[self.currIndex]], direction: .forward, animated: false, completion: nil)
        
        self.selectedDate( CalendarManager.shared().selectedDate )
        
//        self.refreshView()
        self.displaySchedules(forceRefresh: true)
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // ToDo: DisplayModeをこのクラス以外で設定するようにする
        CalendarManager.shared().displayMode = AppCalendarDisplayModeMonthly
        
        self.selectedDate( CalendarManager.shared().selectedDate )

        self.displaySchedules(forceRefresh: false)
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//}
//
//
//extension BzMonthPageViewController : BzMainViewProtocol {
    
    func displaySchedules(forceRefresh:Bool = false) {
        if self.monthViewControllers.count < 3 {
            return
        }
        var needToUpdate = forceRefresh
        
        
        guard let selectedDate = CalendarManager.shared().selectedDate else {
            fatalError()
        }
        
        if needToUpdate == false {
            if let currentDate = self.monthViewControllers[self.currIndex].monthStartDate() {
                if currentDate.compare(selectedDate) != .orderedSame {
                    needToUpdate = true
                }
            } else {
                needToUpdate = true
            }
        }
        
        if needToUpdate == true {
            self.monthViewControllers[self.currIndex].setDate( selectedDate )
            guard let startDate = self.monthViewControllers[self.currIndex].monthStartDate() else {
                return
            }
            self.monthViewControllers[self.nextIndex].setDate( startDate.nextMonthDate() )
            self.monthViewControllers[self.prevIndex].setDate( startDate.prevMonthDate() )
        }
        
    }

//    fileprivate func displayCurrentPage() {
//        // ToDo
//        // いちいち日付の設定をしないとSelectedDateが変わらない仕様を変更したい
//        self.monthViewControllers[self.currIndex].loadDataAndDisplay(forSelectedDate: CalendarManager.shared().selectedDate)
//    }

    
//     func refreshView() {
//
//        let viewHeight = self.view.frame.size.height
//
//        self.monthViewControllers[self.currIndex].setContentHeight(viewHeight)
//        self.monthViewControllers[self.nextIndex].setContentHeight(viewHeight)
//        self.monthViewControllers[self.prevIndex].setContentHeight(viewHeight)
//
//
//        /*
//         //ToDo: 並列処理だとビューが表示される時にぎくしゃくとなる課題を解決しないと実用化できない
//         */
//        DispatchQueue.main.async {
//            //self.isDisplayReady = YES;
//            if self.monthViewControllers[self.currIndex].isViewLoaded == true {
//                self.monthViewControllers[self.currIndex].loadDataAndDisplay()
//                self.monthViewControllers[self.nextIndex].loadDataAndDisplay()
//                self.monthViewControllers[self.prevIndex].loadDataAndDisplay()
//                self.view.setNeedsLayout()
//            }
//
//       }
//
//    }
    
}

extension BzMonthPageViewController: UIPageViewControllerDataSource {
    fileprivate func nextViewController(viewController: BzMonthViewController, isAfter: Bool) -> UIViewController? {
        guard var index = self.monthViewControllers.index(of: viewController) else {
            return nil
        }
        
        if isAfter {
            index += 1
        } else {
            index -= 1
        }
        
        if index < 0 {
            index = self.monthViewControllers.count - 1
        } else if index == self.monthViewControllers.count {
            index = 0
        }
        
        if index >= 0 && index < self.monthViewControllers.count {
            return self.monthViewControllers[index]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let ctrl = viewController as! BzMonthViewController
        return nextViewController(viewController: ctrl, isAfter: false)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let ctrl = viewController as! BzMonthViewController
        return nextViewController(viewController: ctrl, isAfter: true)
        
    }
    // A page indicator will be visible if both methods are implemented, transition style is 'UIPageViewControllerTransitionStyleScroll', and navigation orientation is 'UIPageViewControllerNavigationOrientationHorizontal'.
    // Both methods are called in response to a 'setViewControllers:...' call, but the presentation index is updated automatically in the case of gesture-driven navigation.
    //    @available(iOS 6.0, *)
    //    optional public func presentationCount(for pageViewController: UIPageViewController) -> Int // The number of items reflected in the page indicator.
    //
    //    @available(iOS 6.0, *)
    //    optional public func presentationIndex(for pageViewController: UIPageViewController) -> Int // The selected item reflected in the page indicator.
    
    
//}
//extension BzMonthPageViewController {
    
    
    fileprivate func _validateAndFixBasedOnNextViewDate() {
        let appCalendar = CalendarManager.shared().appCalendar()!
        let calendarManager = CalendarManager.shared()!

        let selectedDate = calendarManager.selectedDate!
        
        var dateOfPrev = self.monthViewControllers[self.prevIndex].monthStartDate()!
        var dateOfCur = self.monthViewControllers[self.currIndex].monthStartDate()!
        let dateOfNext = self.monthViewControllers[self.nextIndex].monthStartDate()!
        
        let diffOne = appCalendar.dateComponents([.day, .weekOfYear, .month], from: dateOfPrev, to: dateOfCur)
        let diffTwo = appCalendar.dateComponents([.day, .weekOfYear, .month], from: dateOfCur, to: dateOfNext)
        if diffOne.month != 1 ||
            diffTwo.month != 1 ||
            calendarManager.selectedDate.compare(dateOfCur) != .orderedSame {

            print("diffOne: ", diffOne)
            print("diffTwo: ", diffTwo)

            var oneMonthMinus = DateComponents()
            oneMonthMinus.month = -1

            dateOfCur = appCalendar.date(byAdding: oneMonthMinus, to: dateOfNext)!
            dateOfPrev = appCalendar.date(byAdding: oneMonthMinus, to: dateOfCur)!

            calendarManager.selectedDate = dateOfCur
            self.monthViewControllers[self.currIndex].setDate(dateOfCur)
            self.monthViewControllers[self.prevIndex].setDate(dateOfPrev)
        }
        
    }

    fileprivate func _validateAndFixBasedOnPrevViewDate() {

        let calendarManager = CalendarManager.shared()!
        
        let dateOfPrev = self.monthViewControllers[self.prevIndex].monthStartDate()!
        var dateOfCur = self.monthViewControllers[self.currIndex].monthStartDate()!
        var dateOfNext = self.monthViewControllers[self.nextIndex].monthStartDate()!

        let appCalendar = CalendarManager.shared().appCalendar()!

        let diffOne = appCalendar.dateComponents([.day, .weekOfYear, .month], from: dateOfPrev, to: dateOfCur)
        let diffTwo = appCalendar.dateComponents([.day, .weekOfYear, .month], from: dateOfCur, to: dateOfNext)


        if( diffOne.month != 1 ||
            diffTwo.month != 1 ||
            calendarManager.selectedDate.compare(dateOfCur) != .orderedSame) {
            
            print("diffOne: ", diffOne)
            print("diffTwo: ", diffTwo)

            
            var oneMonthPlus = DateComponents()
            oneMonthPlus.month = 1
            
            dateOfCur =  appCalendar.date(byAdding: oneMonthPlus, to: dateOfPrev)!
            dateOfNext = appCalendar.date(byAdding: oneMonthPlus, to: dateOfCur)!
            
            calendarManager.selectedDate = dateOfCur
            self.monthViewControllers[self.currIndex].setDate(dateOfCur)
            self.monthViewControllers[self.nextIndex].setDate(dateOfNext)

        }

    }
    // Sent when a gesture-initiated transition begins.
    //    @available(iOS 6.0, *)
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        self.moveToNextMonth = nil
        
        guard let ctrl = pendingViewControllers.first as? BzMonthViewController else {
            return
        }
        let index = self.monthViewControllers.index(of: ctrl)!
        switch index {
        case self.prevIndex:
            self.moveToNextMonth = false
            break
        case self.currIndex:
            break
        case self.nextIndex:
            self.moveToNextMonth = true
            break
        default:
            break
        }
    }
    
    
    // Sent when a gesture-initiated transition ends. The 'finished' parameter indicates whether the animation finished, while the 'completed' parameter indicates whether the transition completed or bailed out (if the user let go early).
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let ctrl = previousViewControllers.first as? BzMonthViewController else {
            return
        }
        //let index = self.monthViewControllers.index(of: ctrl)!
        
        guard let moveToNextMonth = self.moveToNextMonth else {
            return
        }
        if moveToNextMonth == true {
            //            self.prevViewCtrl = self.currViewCtrl;
            //            self.currViewCtrl = self.nextViewCtrl;
            
            let tempIndex = self.prevIndex
            //今日は昨日になり
            self.prevIndex = self.currIndex
            //明日は今日になり
            self.currIndex = self.nextIndex
            
            //昨日は明日にして、日付を変える
            self.nextIndex = tempIndex
            
            let date = ctrl.monthStartDate()!
            let newCurrentDate = date.nextMonthDate() ///date.nextMonthDate()
            let newNextDate = newCurrentDate.nextMonthDate()
            
            self.monthViewControllers[self.nextIndex].setDate(newNextDate)
            
            // 基準日も変える
            CalendarManager.shared().selectedDate = newCurrentDate
            
            self._validateAndFixBasedOnNextViewDate()
        } else {
            print("moving to prev day")
            let tempIndex = self.nextIndex
            //今日は明日になり
            self.nextIndex = self.currIndex
            //昨日は今日になり
            self.currIndex = self.prevIndex
            //明日は昨日にして、日付を変える
            self.prevIndex = tempIndex
            
            let date = ctrl.monthStartDate()!
            let newCurrentDate = date.prevMonthDate()
            let newPrevDate = newCurrentDate.prevMonthDate()
            
            self.monthViewControllers[self.prevIndex].setDate(newPrevDate)
            
            // 基準日も変える
            CalendarManager.shared().selectedDate = newCurrentDate
            self._validateAndFixBasedOnPrevViewDate()
            
        }

        
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
