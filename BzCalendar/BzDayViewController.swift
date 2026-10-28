//
//  BzDayViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/21.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzDayViewController: UIViewController {

    //　スケジュールモデルを取得するサービス
    fileprivate var scheduleQueryService : BzScheduleQueryService = BzScheduleQueryService.shared
    // サービスよりデータを取得する
    fileprivate var dayScheduleComponent : BzDayScheduleComponent!

    
    // [View 1] トップバー
    @IBOutlet weak var dayBar: BzDayBar!

    // [View 2] ヘッダービュー
    @IBOutlet weak var headerView: DailyScheduleHeaderView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!

    // [View 3] UIScrollViewの親ビュー
    //   UIView (scrollContainerView)
    //     UIScrollView
    //       BzDailyScheduleContentView
    @IBOutlet weak var scrollContainerView: UIView!
    // scrollContainerViewにUIScrollViewを貼り付けている
    @IBOutlet weak var scrollView : UIScrollView!
    
    // スケジュールビュー
    // scrollViewにコンテンツのビューとしてscheduleContentViewを張っている
    // contentHeightConstraintによりコンテンツの高さが変わると、
    // UIScrollViewのコンテンツサイズが変わり、正しくスクロールする
    @IBOutlet weak var scheduleContentView: BzDailyScheduleContentView!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!

    
    fileprivate var needToUpdateContents : Bool = false
    
    
    // データを更新するのは日付をセットした時のみとする
    // UIの更新処理をしてもデータを何度も取得しないようにするため
    // 必要になったら、データを強制更新する処理も用意する
    var date : Date = Date() {
        didSet {
            // DispatchQueue.main.async より前にdayScheduleComponentを設定しておかないと、
            // 先にupdateUIComponents()が呼ばれた場合、dayScheduleComponentがまだ設定されていない状況が発生する
            self.dayScheduleComponent = self.scheduleQueryService.daySchedule(targetDate: self.date)
            self.needToUpdateContents = true
            DispatchQueue.main.async {
                if self.isViewLoaded {
                    self.updateUIComponents()
                }
            }
        }
    }
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = BzAppThemeService.shared.themeColor()

        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "AppEventKit_EventStoreChanged"), object: nil, queue: nil) {
            note in
                self.date = self.date
            
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = BzAppThemeService.shared.themeColor()
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.needToUpdateContents == true {
            self.updateUIComponents()
        }
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
       // if self.needToUpdateContents {
            self.updateUIComponents()
       // }
    }

    override func viewDidLayoutSubviews() {
        // viewWillAppearではまだレイアウトが更新されていないので、こちらでアップデートする
        if self.needToUpdateContents == true {
            self.updateUIComponents()
        }
    }
    
    // MARK: -
    // updateUIComponents()
    // viewWillLayoutSubviews等、メインスレッド動作するメソッドから呼ぶか、
    // そうでない場合、DispatchQueue.main.asyncの中から呼ぶ
    fileprivate func updateUIComponents() {
        
        var alldayEvents : Array<EKEvent> = Array()
        var standardEvents : Array<EKEvent> = Array()
        
        if let dayScheduleComponent = self.dayScheduleComponent  {
            alldayEvents = dayScheduleComponent.alldayEvens()
            standardEvents = dayScheduleComponent.standardEvents()
        }

        let mainViewHeight = self.mainContentHeight()
        let layoutManager = CalendarManager.shared().basicSettingManager()!

        // クリア
        self.headerView.clearEvents()
        self.scheduleContentView.clearSchedules()
        // DayBar (日付の表示バー)の表示
        self.dayBar.date = self.date
        self.dayBar.rokuyoTitle(title: dayScheduleComponent.rokuyoTitle)

        // ヘッダービュー（１日スケジュールの表示）
        self.headerView.addEvents(NSMutableArray(array: alldayEvents))
        
        let defaultStartTime = layoutManager.activeTimeFromFloat()
        var defaultEndTime   = layoutManager.activeTimeToFloat()
        if defaultEndTime <= defaultStartTime {
            defaultEndTime = defaultStartTime + 1
        }
        let totalHoursToShow = defaultEndTime - defaultStartTime
        let rowCount : CGFloat = totalHoursToShow + CGFloat(alldayEvents.count)
        
        let alldayEventHeight : CGFloat = mainViewHeight / rowCount
        self.headerView.setEventHeight(alldayEventHeight)
        
        let headerViewHeight : CGFloat = alldayEventHeight * CGFloat(alldayEvents.count)

        if self.headerViewHeightConstraint.constant != headerViewHeight {
            self.headerViewHeightConstraint.constant = headerViewHeight
            self.headerView.updateConstraintsIfNeeded()
            self.headerView.layoutIfNeeded()
        }
        let bounds = self.view.bounds
        let headerViewEndY = self.headerView.frame.origin.y + headerViewHeight
        var scrollFrame = self.scrollContainerView.frame
        scrollFrame.origin.y = headerViewEndY
        self.scrollContainerView.frame = scrollFrame
        self.scrollContainerView.updateConstraintsIfNeeded()
        
        if self.scrollContainerView.frame.origin.y != headerViewEndY {
            print( self.scrollContainerView.frame.origin.y, ", ", headerViewEndY)
        }
        var containerSize = self.scrollContainerView.bounds.size
        containerSize.height = (bounds.height - headerViewEndY)
        if containerSize.height != (bounds.height - headerViewEndY) {
            print(containerSize.height, ", ", (bounds.height - headerViewEndY))
        }
        self.scheduleContentView.displaySize = containerSize
        self.contentHeightConstraint.constant = self.scheduleContentView.requiredContentHeight()
        
        self.scheduleContentView.setDate(date: self.date)
        self.scheduleContentView.add(events: standardEvents)
        
        self.scrollView.setContentOffset(self.scheduleContentView.contentOffset(), animated: false)

        self.scheduleContentView.setNeedsLayout()
        self.view.setNeedsDisplay()
        
        if let _ = self.dayScheduleComponent  {
            self.needToUpdateContents = false
        }
    }
    
    fileprivate func mainContentHeight() -> CGFloat {
        // 以前はタブバーの位置等、上下のUIViewのframe情報から動的に計算していた
        // この値がおかしくなった場合は動的に計算した値と比較すること
        
        let viewHeight : CGFloat = self.view.bounds.height
        let suggestedMainViewHeight = viewHeight - self.dayBar.frame.origin.y - self.dayBar.frame.height
        
        //let suggestedMainViewHeight : CGFloat = self.scrollContainerView.frame.size.height
        return suggestedMainViewHeight
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

extension BzDayViewController : UIScrollViewDelegate {
    
    //    optional public func scrollViewDidScroll(_ scrollView: UIScrollView) // any offset changes
    //    optional public func scrollViewDidZoom(_ scrollView: UIScrollView) // any zoom scale changes
    //    // called on start of dragging (may require some time and or distance to move)
    //    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {}
    //    // called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
    //    optional public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    //    // called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
    //    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {}
    //    optional public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) // called on finger up as we are moving
    //    optional public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) // called when scroll view grinds to a halt
    // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
    //    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {}
    //    optional public func viewForZooming(in scrollView: UIScrollView) -> UIView? // return a view that will be scaled. if delegate returns nil, nothing happens
    //    optional public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) // called before the scroll view begins zooming its content
    //    optional public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) // scale between minimum and maximum. called after any 'bounce' animations
    //    optional public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool // return a yes if you want to scroll to the top. if not defined, assumes YES
    //    optional public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) // called when scrolling animation finished. may be called immediately if already at top
    //    @available(iOS 11.0, *)
    //    optional public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView)
    
}
