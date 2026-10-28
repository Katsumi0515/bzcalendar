//
//  BzCustomCalendarColorViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/04/26.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit


class BzCustomCalendarColorViewController: UIViewController {

    //@property (nonatomic, retain) EKCalendar* calendar;
    var calendar : EKCalendar!
    
    func currentColorCode() -> String {
        let  colorUtil = ColorUtil.shared
        if self.segmentForColor.selectedSegmentIndex == 0 {
            return colorUtil.colorCode(color: self.currentBgColor!)
        } else {
            return colorUtil.colorCode(color: self.currentTextColor!)
        }
    }
    
    fileprivate var originalBgColor : UIColor? = nil
    fileprivate var originalTextColor : UIColor? = nil

    fileprivate var currentBgColor : UIColor? = nil
    fileprivate var currentTextColor : UIColor? = nil
    
    var colorCodeDelegate : BzChangedColorCodeHandleProtocol?
    
    // 編集前の情報
    @IBOutlet weak var calendarColorSampleView: UIView!  // 編集前の色をサンプル表示
    @IBOutlet weak var calendarColorLabel: UILabel!      // "オリジナルの色"
    @IBOutlet weak var calendarColorCodeLabel: UILabel!  // カラーコード　#aabbcc

    // 編集中の情報
    @IBOutlet weak var calendarColorBackgroundView: UIView!
    @IBOutlet weak var textColorSampleView: UIView!  // 現在の色をサンプル表示
    @IBOutlet weak var textColorLabel: UILabel!      // "現在の色"
    @IBOutlet weak var textColorCodeLabel: UILabel!  // カラーコード　#aabbcc
    
    // セグメントコントロール
    @IBOutlet weak var selectSegCtrl: UISegmentedControl!
    
    @IBOutlet weak var segmentForColor: UISegmentedControl!
    
    @IBAction func segmentForColorChanged(_ sender: Any, forEvent event: UIEvent) {
        
        // RGBビューの色の設定をする
        if let rgbViewController = self.currentViewController as? BzSelectColorFromRGBViewController {
            var color : UIColor? = nil
            if( self.segmentForColor.selectedSegmentIndex == 0 ) {
                color = self.currentBgColor
            } else {
                color = self.currentTextColor
            }
            let code = ColorUtil.shared.colorCode(color: color!)
            rgbViewController.setupSliderValues(colorCode: code)
        }
    }
    // コンテナビュー
    @IBOutlet weak var containerView: UIView!
    
    fileprivate var currentViewController : UIViewController? = nil
    
    // MARK: - 保存
    fileprivate func calendarExtention(_ calendar: EKCalendar, callback:@escaping ((CalendarExtension?)->Void)) {
        if let ext = BzEventExtensionService.shared().calendarExtension(calendar:self.calendar) {
            callback( ext )
            return
        }
        BzEventExtensionService.shared().createExtention(calendar:self.calendar) {
            ext in
            callback( ext )
            return
        }
    }
    @IBAction func saveClicked(_ sender: UIBarButtonItem) {
        self.calendarExtention(self.calendar) {
            ext in
            guard let calendarExtension = ext else {
                return
            }
            
            if let bgColor = self.currentBgColor {
                calendarExtension.bgColorCode = ColorUtil.shared.colorCode(color: bgColor)
            }
            if let textColor = self.currentTextColor {
                calendarExtension.textColorCode = ColorUtil.shared.colorCode(color: textColor)
            }
            BzEventExtensionService.shared().saveAllChangesInCalendarExtentions() {
                (error) in
                
                if let error = error {
                    
                    let title = "Error in Saving Calendar Custom Color"
                    let message = error.localizedDescription
                    
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) {
                        action in
                        
                    }
                    alert.addAction(okAction)
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    } // DispatchQueue.main.async
                }
                
            }

        }
        
    }
    
    // MARK: - セグメント切り替え
    @IBAction func showComponent(_ sender: UISegmentedControl) {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        
        self.segmentForColor.isEnabled = true
        
        if sender.selectedSegmentIndex == 0 {
            guard let newViewController = storyboard.instantiateViewController(withIdentifier: "BzSelectColorFromListTblViewController") as? BzSelectColorFromListTblViewController else {
                
                return
            }
            
            newViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
            self.currentViewController = newViewController
        } else if sender.selectedSegmentIndex == 1 {
            let newViewController = storyboard.instantiateViewController(withIdentifier: "BzSelectColorFromRGBViewController")
            newViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
            self.currentViewController = newViewController
        } else {
            guard let newViewController = storyboard.instantiateViewController(withIdentifier: "BzDefaultCalendarColorTableViewController") as? BzDefaultCalendarColorTableViewController else {
                return
            }
            newViewController.calendar = self.calendar
            newViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
            self.currentViewController = newViewController
            self.segmentForColor.isEnabled = false
        }
    }
    
    // MARK: - UIViewControllerの通常メソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Common_ExactWord_Color", comment:"色")
        
        self.originalBgColor = self.calendar.bgColor()
        self.originalTextColor = self.calendar.textColor()
        
        self.currentBgColor = self.calendar.bgColor()
        self.currentTextColor = self.calendar.textColor()
        
        if let calendarExtension = BzEventExtensionService.shared().calendarExtension(calendar: self.calendar) {
            if let bgColorCode = calendarExtension.bgColorCode {
                self.currentBgColor = ColorUtil.shared.UIColorFromColorCode(bgColorCode)
            }
            if let textColorCode = calendarExtension.textColorCode  {
                self.currentTextColor = ColorUtil.shared.UIColorFromColorCode(textColorCode)
            }
        }

        let string_Pallet = NSLocalizedString("Common_ExactWord_Pallet", comment:"Pallet")
        
        
        self.selectSegCtrl.setTitle(string_Pallet, forSegmentAt: 0)
        
        self.calendarColorCodeLabel.text = NSLocalizedString("Common_ExactWord_CurrentColor", comment: "オリジナル色")
//        if let color = ColorUtil.sharedManager().uiColor(fromColorCode: self.originalColorCode) {
//            self.originalColorSampleView.backgroundColor = color
//            self.originalColorCodeLabel.attributedText = ColorUtil.sharedManager().atributedColorCode(code: self.originalColorCode)
//        }
        self.calendarColorLabel.text = NSLocalizedString("Common_ExactWord_CalendarColor", comment: "カレンダーの色")
        self.textColorLabel.text = NSLocalizedString("Common_ExactWord_TextColor", comment:"テキストの色")
        
        
        //self.selectSegCtrl.selectedSegmentIndex = 0
        
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "BzSelectColorFromListTblViewController")
        
        self.currentViewController = controller
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        self.addSubview(controller.view, toView: self.containerView)
        
        self.updateContents()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self._calendarExtension = [[BzEventExtensionService shared] calendarExtensionWithCalendar:self.calendar];

        
        //[self _setSliderValuesByCurrentColor];
        self.selectSegCtrl.selectedSegmentIndex = 0
        // self.segmentForColor.selectedSegmentIndex = 0
        //[self _toolbarSegmentSelected:self._selectSegCtrl];

        //self.updateCurrentColorCode(colorCode: self.tempColorCode)
        
        
        super.viewWillAppear(animated)
    }
}

// MARK: -
extension BzCustomCalendarColorViewController {
    fileprivate func addSubview(_ subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[subView]|",
                options: [],
                metrics: nil,
                views: viewBindingsDict))
        parentView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[subView]|",
                options: [],
                metrics: nil,
                views: viewBindingsDict))
    }
    
    fileprivate func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMove(toParent: nil)
        self.addChild(newViewController)
        self.addSubview(newViewController.view, toView:self.containerView!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
        },
                       completion: { finished in
                        oldViewController.view.removeFromSuperview()
                        oldViewController.removeFromParent()
                        newViewController.didMove(toParent: self)
        })
    }
    
}

// MARK: - BzSelectColorCodeViewControllerDelegate
extension BzCustomCalendarColorViewController: BzSelectColorCodeViewControllerDelegate {
    
    func updateContents() {
        let colorUtil = ColorUtil.shared

        self.calendarColorBackgroundView.backgroundColor = self.currentBgColor
        self.calendarColorSampleView.backgroundColor = self.currentBgColor
        let bgColorCode = colorUtil.colorCode(color: self.currentBgColor!)
        let noshadow = self.traitCollection.userInterfaceStyle == .dark

        self.calendarColorCodeLabel.attributedText = colorUtil.atributedColorCode(code: bgColorCode, noShadow: noshadow)
        
        self.textColorSampleView.backgroundColor = self.currentTextColor
        self.textColorLabel.backgroundColor = self.currentBgColor
        self.textColorLabel.textColor = self.currentTextColor
        let textColorCode = colorUtil.colorCode(color: self.currentTextColor!)
        self.textColorCodeLabel.attributedText = colorUtil.atributedColorCode(code: textColorCode, useColorCodeAsTextColor: true)

    }
    
    func updateCurrentColorCode(colorCode:String) {
        guard let color = ColorUtil.shared.UIColorFromColorCode(colorCode) else {
            return
        }
        if self.segmentForColor.selectedSegmentIndex == 0 {
            self.currentBgColor = color
        } else {
            self.currentTextColor = color
        }

        self.updateContents()
        
//        self.tempColorCode = colorCode;
//        if let color = ColorUtil.sharedManager().uiColor(fromColorCode: self.tempColorCode) {
//            self.currentColorSampleView.backgroundColor = color
//            self.currentColorCodeLabel.attributedText = ColorUtil.sharedManager().atributedColorCode(code: colorCode)
//        }
    }
}
