//
//  BzWeekViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/23.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

fileprivate extension Date {
    
}

fileprivate class EventViewManager : NSObject {
    
    fileprivate var eventViewArray : Array<WVScheduleView> = Array()
    fileprivate var eventViewArrayDict : Dictionary<Int, Array<WVScheduleView>> = Dictionary()

    // MARK: - インスタンス化
    override init() {
        super.init()
        self.eventViewArray = Array()
        self.eventViewArrayDict = Dictionary()
        for idx in 0..<7 {
            let array : Array<WVScheduleView> = Array()
            self.eventViewArrayDict[idx] = array
        }
    }

    // MARK: -
    func add(view:WVScheduleView, index:Int) {
        self.eventViewArray.append(view)
        if var array = self.eventViewArrayDict[index] {
            array.append(view)
        }
    }
    
    func doubleBookViews(event:EKEvent, index:Int) -> Array<WVScheduleView> {
        var dbViews : Array<WVScheduleView> = Array()
        let eventArrayForIndex = self.eventViewArrayDict[index]!
        for schedView in eventArrayForIndex {
            if self._startTime(startTime: event.startDate, withinEvent: schedView.event) {
                dbViews.append(schedView)
            }
        }
        return dbViews
    }

    func clearAllViews() {
        for view in self.eventViewArray {
            if view.superview != nil {
                view.removeFromSuperview()
            }
        }
        self.eventViewArray.removeAll()
        for key in self.eventViewArrayDict.keys {
            if var array = self.eventViewArrayDict[key] {
                array.removeAll()
            }
        }
    }
    
    // MARK: - プライベート
    fileprivate func _startTime(startTime:Date, withinEvent event:EKEvent) -> Bool {
        if startTime.compare(event.startDate) != .orderedDescending &&
            startTime.compare(event.endDate) != .orderedAscending {
            return true
        }
        return false
    }

}

/**
 *  BzWeekViewController
 *
 */
class BzWeekViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var alldayViewHeightConstraint: NSLayoutConstraint!
    
    // スケジュールデータ
    fileprivate var weekDataContainer : BZVMWeeklyViewContents!

    // [View 1] ナビゲーションバー
    @IBOutlet weak var weekBar: BzWeekBar!
    
    // [View 2] ヘッダービュー
    @IBOutlet weak var headerMainView: BzWeekHeaderMainView!
    //@IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!

    
    // [View 3] UIScrollViewの親ビュー
    //  UIView (scrollContainerView)
    //    UIScrollView
    //      WeekTimeScaleView (timeScaleView)
    //
    @IBOutlet weak var scrollContainerView: UIView!
    // scrollContainerViewにUIScrollViewを貼り付けている
    @IBOutlet weak var scrollView: UIScrollView!

    // スケジュールビュー
    // scrollViewにコンテンツのビューとしてtimeScaleViewを張っている
    // contentHeightConstraintによりコンテンツの高さが変わると、
    // UIScrollViewのコンテンツサイズが変わり、正しくスクロールする
    @IBOutlet weak var timeScaleView : WeekTimeScaleView!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!

    //fileprivate var timeLabelWidth : CGFloat = 40
    
    // EKEventの描画の処理が複雑なのでその処理をクラス化している
    fileprivate var scheduleViewManager: EventViewManager!
    
    fileprivate var needToUpdateContents : Bool = false
    
    fileprivate var oneHourHeight : CGFloat = 0
    fileprivate var contentHeight : CGFloat = 0
    fileprivate let _kWeekViewCtrl_ScrollTopMargin : CGFloat = 5

    fileprivate var lastRokuyoOn : Bool? = nil

    func startDate() -> Date? {
        if let container = self.weekDataContainer {
            return container.fromDate
        }
        return nil
    }
    func endDate() -> Date {
        return self.weekDataContainer.toDate
    }
    func setDate(_ date:Date) {
        self.weekDataContainer = BzScheduleQueryService.shared.weekSchedule(containsDate: date)
        self.needToUpdateContents = true
        if self.isThisWeek() {
            self.weekDataContainer.selectedDate( CalendarManager.shared().selectedDate )
        }
        DispatchQueue.main.async {
            if self.isViewLoaded == true {
                self.updateUIComponents()
            } else {
                
            }
        }
    }
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "AppEventKit_EventStoreChanged"), object: nil, queue: nil) {
            note in
            if self.weekDataContainer != nil {
                self.setDate(self.weekDataContainer.fromDate)
            }
            
        }

        self.scheduleViewManager = EventViewManager()
        
        let scheduleBackgroundColor = BzAppThemeService.shared.scheduleBackgoundColor()
        self.timeScaleView.backgroundColor = scheduleBackgroundColor
        self.scrollView.backgroundColor = scheduleBackgroundColor
     
        let singleTapRec = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        singleTapRec.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(singleTapRec)
        
        let doubleTapRec = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapRec.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTapRec)
        if self.needToUpdateContents == true {
            self.updateUIComponents()
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = BzAppThemeService.shared.themeColor()

        super.viewWillAppear(animated)

        let basicMgr = CalendarManager.shared().basicSettingManager()!

        if let lastRokuyoOn = self.lastRokuyoOn {
            if lastRokuyoOn != basicMgr.isRokuyoOn() {
                self.needToUpdateContents = true
                self.headerMainView.setNeedsLayout()
                self.view.updateConstraintsIfNeeded()
            }
        }
        self.lastRokuyoOn = basicMgr.isRokuyoOn()
        
        if self.needToUpdateContents == true {
            self.updateUIComponents()
        }
    }
    
    // viewWillLayoutSubviews
    // self.viewのlayoutSubviewsが呼ばれる直前に呼ばれる
    override func viewWillLayoutSubviews() {
        self.updateUIComponents()
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.needToUpdateContents == true {
            self.updateUIComponents()
        }
    }

    override func viewDidLayoutSubviews() {
        self.updateUIComponents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -
    
    // updateUIComponents()
    // viewWillLayoutSubviews等、メインスレッド動作するメソッドから呼ぶか、
    // そうでない場合、DispatchQueue.main.asyncの中から呼ぶ
    fileprivate func updateUIComponents() {
        guard let weekDataContainer = self.weekDataContainer else {
            return
        }
        

        self.weekDataContainer.selectedDate(CalendarManager.shared().selectedDate)
        
        // クリア
        self.headerMainView.clearSubViews()
        self.scheduleViewManager.clearAllViews()
        
        
        self.weekBar.date = weekDataContainer.bzDateArray().first!.date
        self.headerMainView.setWeekDates(dayDataArray: weekDataContainer.bzDateArray())

        let offsetX : CGFloat = self.headerMainView.offsetX()
        
        self.headerMainView.add(alldayContents: self.weekDataContainer.alldayViewContents)
        let suggestedAlldayViewHeight = ceil( self.headerMainView.suggestedAlldayViewHeight() )
        if suggestedAlldayViewHeight != self.alldayViewHeightConstraint.constant {
            self.alldayViewHeightConstraint.constant = suggestedAlldayViewHeight
            self.view.updateConstraintsIfNeeded()
        }
        
        self.timeScaleView.offsetX = offsetX
        
        let layoutManager = CalendarManager.shared().basicSettingManager()!
        
        let defaultStartTime = layoutManager.activeTimeFromFloat()
        let defaultEndTime   = layoutManager.activeTimeToFloat()
        let totalHoursToShow =  defaultEndTime - defaultStartTime
        
        // UIScrollViewのレイアウトがまだ決定されていないのでscrollContainerViewの方が正確
        // UIScrollViewの親をself.viewにしておけば正確かどうかは未確認（正確のような気がする）
        //self.oneHourHeight = self.scrollView.bounds.height / totalHoursToShow
        self.oneHourHeight = self.scrollContainerView.bounds.height / totalHoursToShow
        
        let activeTimeStart = (defaultStartTime * oneHourHeight) + _kWeekViewCtrl_ScrollTopMargin
        let activeTimeEnd   = activeTimeStart + (totalHoursToShow * oneHourHeight)
        
        self.timeScaleView.activeTimeStart = activeTimeStart
        self.timeScaleView.activeTimeEnd   = activeTimeEnd
        
        self.contentHeight = self.oneHourHeight * 24.0 + (_kWeekViewCtrl_ScrollTopMargin * 2)
        
        if self.contentHeightConstraint.constant != self.contentHeight {
            self.contentHeightConstraint.constant = self.contentHeight
            self.scrollView.updateConstraintsIfNeeded()
        }
        
        self.timeScaleView.setTopMargin(_kWeekViewCtrl_ScrollTopMargin)
        self.timeScaleView.setHourHeight(oneHourHeight)
        
        let contentStartY = (oneHourHeight * defaultStartTime) + _kWeekViewCtrl_ScrollTopMargin
        let contentOffset = CGPoint(x: 0, y: contentStartY)
        self.scrollView.setContentOffset(contentOffset, animated: false)
        
    
        let dayDataArray = weekDataContainer.bzDateArray()
        for viewIdx in 0..<7 {
            let dayData = dayDataArray[viewIdx]

            self.addEventsForDay(dayContents: dayData, index: viewIdx)
//            let longEvents = dayData.longEvents()
//            for event in longEvents {
//                self.headerMainView.add(longEvent: event, viewIndex:viewIdx)
//            }
//            let alldayEvents = dayData.alldayEvents()
//            for event in alldayEvents {
//                self.headerMainView.add(alldayEvent: event, viewIndex: viewIdx)
//            }
//            let endAfterStartDayEvents = dayData.endAfterStartDayEvents()
//            for event in endAfterStartDayEvents {
//                // 対象日と、翌日に追加
//                self.addEvent(event, index: viewIdx)
//                let nextIdx = viewIdx + 1
//                if nextIdx < 7 {
//                    self.addEvent(event, index: nextIdx)
//                }
//
//            }
//            let otherEvents = dayData.shortEvents()
//            for event in otherEvents {
//                self.addEvent(event, index: viewIdx)
//            }
            
        }
        
        // UIレイアウト処理
        self.weekBar.setNeedsLayout()
        self.headerMainView.setNeedsLayout()
        self.view.updateConstraintsIfNeeded()
        self.timeScaleView.setNeedsLayout()
        self.scrollContainerView.setNeedsLayout()
        self.scrollView.setNeedsLayout()
        
        // 更新要否をfalseに
        self.needToUpdateContents = false
    }
    
    fileprivate func offsetX() -> CGFloat {
        return self.headerMainView.offsetX()
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

// MARK: - ジェルチャーのハンドリング
extension BzWeekViewController {
    
    fileprivate func _dateSelectedByTapGestureRecognizer(gesture:UITapGestureRecognizer) -> Date? {
        guard self.weekDataContainer != nil else {
            return nil
        }
        let offsetX : CGFloat = self.headerMainView.offsetX()
        
        let headerY = self.headerMainView.frame.origin.y
        let endY = self.scrollContainerView.frame.origin.y + self.scrollContainerView.frame.height
        
        let point = gesture.location(in: self.view)
        if point.y < headerY {
            return nil
        } else if point.y > endY {
            return nil
        }
        if point.x < offsetX {
            return nil
        }
        
        let dayWidth = (self.scrollContainerView.frame.width - offsetX) / CGFloat(7)
        let idx = Int((point.x - offsetX) / dayWidth)
        
        
        let date = self.weekDataContainer.bzDateArray()[idx].date
        
        return date
    }

    @objc fileprivate func handleSingleTap(gesture:UITapGestureRecognizer) {
        if let date = self._dateSelectedByTapGestureRecognizer(gesture: gesture) {
            CalendarManager.shared().selectedDate = date
            self.weekDataContainer.selectedDate( date )
            self.view.setNeedsLayout()

//            let note = Notification.Name(rawValue: "BzWeekViewSelectedDateChanged")
//            NotificationCenter.default.post(name: note, object: nil)
        }
    }
    
    @objc fileprivate func handleDoubleTap(gesture:UITapGestureRecognizer) {
        if let date = self._dateSelectedByTapGestureRecognizer(gesture: gesture) {
            CalendarManager.shared().selectedDate = date
            self.weekDataContainer.selectedDate( date )

            let note = Notification.Name(rawValue: "BzWeekViewSelectedDateChanged")
            NotificationCenter.default.post(name: note, object: nil)
            
            if let appDelegate = UIApplication.shared.delegate as? BzAppDelegate {
                appDelegate.topViewControllerDelegate().select(AppCalendarDisplayModeDaily)
            }
        }
    }

}

extension BzWeekViewController {
    
    fileprivate func addEventsForDay(dayContents:BZVMWeeklyViewDayContents, index:Int) {
//        let midnightDate = dayContents.date
//        let dayWidth : CGFloat = (self.scrollContainerView.frame.width - self.offsetX()) / CGFloat(7)
//        let doubleBookOffset : CGFloat = 0
//        let width : CGFloat = dayWidth - doubleBookOffset
//        let originX : CGFloat = self.offsetX() + (dayWidth * CGFloat(index)) + doubleBookOffset
//
//        let appCalendar = CalendarManager.shared().appCalendar()!

        for eventComp in dayContents.eventComponents {
             let events = eventComp.events
            for overlapIndex in 0..<events.count {
                let event = events[overlapIndex]
                self.addEvent(event, index: index, overlapIndex: overlapIndex)
            }
        }
        
    }
    
    //
    // MARK:- リファクタリング中
    //
    fileprivate func addEvent(_ event:EKEvent, index:Int, overlapIndex : Int = 0 ) {
        // overlapIndex // 重複なければ0
        let midnightDate = self.weekDataContainer.bzDateArray()[index].date
        
        let doubleBookOffset : CGFloat = CGFloat(0 + (4 * overlapIndex))
        let dayWidth : CGFloat = (self.scrollContainerView.frame.width - self.offsetX()) / CGFloat(7)
        let width : CGFloat = dayWidth - doubleBookOffset
        let originX : CGFloat = self.offsetX() + (dayWidth * CGFloat(index)) + doubleBookOffset
        
        let appCalendar = CalendarManager.shared().appCalendar()!
        
        let startDate = event.startDate!
        let endDate   = event.endDate!
        
        let unitFlag : Set<Calendar.Component> = [ .hour, .minute, .day ]
        
        let startHourMinComp = appCalendar.dateComponents(unitFlag, from: midnightDate, to:startDate)
        
        guard var startHour = startHourMinComp.hour, var startMinute = startHourMinComp.minute else {
            return
        }
        
        let endHourMinComp = appCalendar.dateComponents(unitFlag, from: midnightDate, to:endDate)
        guard var endHour = endHourMinComp.hour, var endMinute = endHourMinComp.minute, let endDay = endHourMinComp.day else {
            return
        }
        
        if startHour < 0 {
            startHour = 0
        }
        if startMinute < 0 {
            startMinute = 0
        }
        if endDay > 0 {
            endHour = 24
            endMinute = 0
        } else if endHour == 0 && endMinute == 0 {
            // 前日
            return
        }
        let startTimeInHour : CGFloat = (CGFloat(startHour) + CGFloat(startMinute)/CGFloat(60))
        let endTimeInHour : CGFloat = (CGFloat(endHour) + CGFloat(endMinute)/CGFloat(60))
        let durationTimeInour : CGFloat = endTimeInHour - startTimeInHour
        
        let startFloat = startTimeInHour * self.oneHourHeight
        let endFloat = endTimeInHour * self.oneHourHeight
        var durationFloat : CGFloat = 0
        let minimalDurationTimeInHour : CGFloat = 0.5
        
        if durationTimeInour < minimalDurationTimeInHour {
            durationFloat = minimalDurationTimeInHour
        } else {
            durationFloat = endFloat - startFloat
        }
        
//        if durationFloat < self.minHeight {
//            durationFloat = self.minHeight
//        }
        
        let eventRect = CGRect(x: originX,
                               y: startFloat + self._kWeekViewCtrl_ScrollTopMargin,
                               width: width,
                               height: durationFloat)
        
        let eventView = WVScheduleView(frame: eventRect)
        eventView.text = event.title
        eventView.font = WeekViewSettingManager.shared().fontForEventEntity()
        eventView.event = event
        eventView.textColor = event.textColor()
        eventView.backgroundColor = event.bgColor()
        eventView.date = midnightDate

        eventView.clearColor = self.timeScaleView.backgroundColor

        self.timeScaleView.addSubview(eventView)
        self.scheduleViewManager.add(view: eventView, index: index)
        
    }
}

extension BzWeekViewController {
    func isThisWeek() -> Bool {
        guard let weekDataContainer = self.weekDataContainer else {
            return false
        }
    //    let appCalendar = CalendarManager.shared().appCalendar()!
    
        let nowDate = Date()
        if nowDate.compare(weekDataContainer.fromDate) == .orderedAscending {
            return false
        }
        if nowDate.compare(weekDataContainer.toDate) == .orderedDescending {
            return false
        }
        return true
    }
}
