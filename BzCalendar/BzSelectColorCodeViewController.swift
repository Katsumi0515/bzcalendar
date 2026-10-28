//
//  BzSelectColorCodeViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/04/09.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit


@objc protocol BzSelectColorCodeViewControllerDelegate {
    func currentColorCode() -> String
    func updateCurrentColorCode(colorCode:String)
}

class BzSelectColorCodeViewController: UIViewController {

    var originalColorCode: String = "" {
        didSet {
            self.tempColorCode = originalColorCode
        }
    }
    var colorCodeDelegate : BzChangedColorCodeHandleProtocol?

    func setColorCodeDelegate(delegate:BzChangedColorCodeHandleProtocol) {
        colorCodeDelegate = delegate
    }

    fileprivate var tempColorCode = ""
    
    
    
    @IBOutlet weak var currentColorSampleView: UIView!  // 現在の色をサンプル表示
    @IBOutlet weak var currentColorLabel: UILabel!      // "現在の色"
    @IBOutlet weak var currentColorCodeLabel: UILabel!  // カラーコード　#aabbcc
    
    @IBOutlet weak var selectSegCtrl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    fileprivate var currentViewController : UIViewController? = nil
    
    // MARK: - 保存
    @IBAction func saveClicked(_ sender: UIBarButtonItem) {
        if let delegate = self.colorCodeDelegate {
            delegate.selectedColorCode(colorCode: self.tempColorCode, object: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - セグメント切り替え
    @IBAction func showComponent(_ sender: UISegmentedControl) {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        
        if sender.selectedSegmentIndex == 0 {
            guard let newViewController = storyboard.instantiateViewController(withIdentifier: "BzSelectColorFromListTblViewController") as? BzSelectColorFromListTblViewController else {
                
                return
            }
            
            newViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
            self.currentViewController = newViewController
        } else {
            let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "BzSelectColorFromRGBViewController")
            newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController!)
            self.currentViewController = newViewController
        }
    }
    
    // MARK: - UIViewControllerの通常メソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        let string_Pallet = NSLocalizedString("Common_ExactWord_Pallet", comment:"Pallet")
        self.selectSegCtrl.setTitle(string_Pallet, forSegmentAt: 0)
        self.currentColorLabel.text = NSLocalizedString("Common_ExactWord_CurrentColor", comment:"現在の色")
        
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "BzSelectColorFromListTblViewController")
        
        self.currentViewController = controller
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        
        self.addSubview(controller.view, toView: self.containerView)

        
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateCurrentColorCode(colorCode: self.originalColorCode)
        
        
        super.viewWillAppear(animated)
    }

}

// MARK: -
extension BzSelectColorCodeViewController {
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
extension BzSelectColorCodeViewController: BzSelectColorCodeViewControllerDelegate {
    func currentColorCode() -> String {
        return self.tempColorCode
    }

    func updateCurrentColorCode(colorCode:String) {
        self.tempColorCode = colorCode;
        if let color = ColorUtil.shared.UIColorFromColorCode(self.tempColorCode) {
            self.currentColorSampleView.backgroundColor = color
            let noshadow = self.traitCollection.userInterfaceStyle == .dark

            self.currentColorCodeLabel.attributedText = ColorUtil.shared.atributedColorCode(code: colorCode, noShadow: noshadow)
        }
    }
}
