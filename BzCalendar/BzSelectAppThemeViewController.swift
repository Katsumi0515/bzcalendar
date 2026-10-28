//
//  BzSelectAppThemeViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/15.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzSelectAppThemeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BzChangedColorCodeHandleProtocol, BzSelectColorCodeViewControllerDelegate {
    
    
    func currentColorCode() -> String {
        if let code = self.themeColorCode {
            return code
        }
        return ""
    }
    
    func updateCurrentColorCode(colorCode: String) {
        self.themeColorCode = colorCode
        self.themeColor = ColorUtil.shared.UIColorFromColorCode(colorCode)
        if let targetViewController = self.children[0] as? BzAppThemeSampleViewController {
            
            targetViewController.sampleThemeColor = self.themeColor
        }

    }
    
    @IBOutlet weak var standardButtonItem: UIBarButtonItem!
    @IBAction func standardItemClicked(_ sender: Any) {
        self.rgbView.isHidden = true
        self.collectionView.isHidden = false
    }
    @IBAction func customColorItemClicked(_ sender: Any) {
        self.rgbView.isHidden = false
        self.collectionView.isHidden = true

    }
    
    @IBOutlet weak var customColorItemClicked: UIBarButtonItem!
    @IBOutlet weak var customColorButtonItem: UIBarButtonItem!
    
    func selectedColorCode(colorCode: String, object: Any?) {
        self.themeColorCode = colorCode
        self.themeColor = ColorUtil.shared.UIColorFromColorCode(colorCode)
        if let targetViewController = self.children[0] as? BzAppThemeSampleViewController {
            
            targetViewController.sampleThemeColor = self.themeColor
        }

    }
    
    
    
    @IBOutlet weak var sampleThemeView: UIView!
    
    private var originalThemeColor : UIColor? = nil
    
    private var themeColorCode: String? = nil {
        didSet {
            
            self.collectionView.reloadData()
        }
    }
    private var themeColor: UIColor!
    
    fileprivate var colorCodeList: Array<BzAppThemeColor> = Array()
    
    
    @IBOutlet weak var doneButtonItem: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rgbView: UIView!

    
    @IBAction func doneClicked(_ sender: Any) {
        let result = BzAppThemeService.shared.save(themeColorCode: self.themeColorCode)
        if result {
            let windows = UIApplication.shared.windows as [UIWindow]
            for window in windows {
                let subviews = window.subviews as [UIView]
                for v in subviews {
                    v.removeFromSuperview()
                    window.addSubview(v)
                }
            }

            self.navigationController?.popToRootViewController(animated: true)
        } else {
            
        }
    }
    internal func collectionView(_: UICollectionView, shouldSelectItemAt: IndexPath) -> Bool {
        
        return true
    }
    internal func collectionView(_: UICollectionView, didSelectItemAt: IndexPath) {
        
        if let targetViewController = self.children[0] as? BzAppThemeSampleViewController {
            
            let item = self.colorCodeList[didSelectItemAt.row]
            self.themeColor = item.color
            self.themeColorCode = item.colorCode
            targetViewController.sampleThemeColor = item.color
        }
        self.collectionView.selectItem(at: didSelectItemAt, animated: true, scrollPosition: .centeredHorizontally)
        print("indexPath:", didSelectItemAt.row)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colorCodeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell : UICollectionViewCell!
        
        if indexPath.row < self.colorCodeList.count {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)
            let item = self.colorCodeList[indexPath.row]
            
            if let cell = cell as? BzColorCollectionViewCell {
                cell.textLabel.text = item.colorName
                cell.textLabel.textColor = .black
                
                cell.colorView.backgroundColor = ColorUtil.shared.UIColorFromColorCode(item.colorCode)
                
                if cell.isSelected {
                    cell.outerColorView.layer.borderWidth = 1.0
                    cell.outerColorView.layer.borderColor = item.color.cgColor
                    cell.outerColorView.backgroundColor = .white
                } else {
                    cell.outerColorView.layer.borderWidth = 0
                    cell.outerColorView.layer.borderColor = UIColor.clear.cgColor
                    cell.outerColorView.backgroundColor = .clear
                }
                
            }

        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customColorCell", for: indexPath)
        }
        return cell
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.themeColor = BzAppThemeService.shared.themeColor()
        self.themeColorCode = BzAppThemeService.shared.themeColorCode()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rgbView.isHidden = true
        self.collectionView.isHidden = false

        self.title = NSLocalizedString("AppTheme_ThemeColor", tableName: nil, bundle: Bundle.main, value: "App. Theme", comment: "テーマカラー")
        self.collectionView.allowsMultipleSelection = false

        self.standardButtonItem.title = NSLocalizedString("AppTheme_StandardPallet", tableName: nil, bundle: Bundle.main, value: "Standard", comment: "標準パレット")
        self.customColorButtonItem.title = NSLocalizedString("AppTheme_CustomColor", tableName: nil, bundle: Bundle.main, value: "Custom", comment: "カスタムカラー")
        self.themeColor = BzAppThemeService.shared.themeColor()
        self.themeColorCode = BzAppThemeService.shared.themeColorCode()
        self.colorCodeList = BzAppThemeService.shared.themeColorList()
        
//        let indexPath = IndexPath(row: 0, section: 0)
//        self.collectionView.selectItem(at: indexPath, animated: true
//            , scrollPosition: .centeredHorizontally)
        
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sampleThemeColorSegue" {
            let carouselPageViewController = segue.destination as! BzAppThemeSampleViewController
            carouselPageViewController.sampleThemeColor = self.themeColor
            
        } else if segue.identifier == "customColorCodeSegue" {
           let nextController = segue.destination as! BzSelectColorCodeViewController
            nextController.colorCodeDelegate = self
            if let code = self.themeColorCode {
                nextController.originalColorCode = code
            } else {
                nextController.originalColorCode = ColorUtil.shared.colorCode(color:self.themeColor)
            }

        }
    }

}
