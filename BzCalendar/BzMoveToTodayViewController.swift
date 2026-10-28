//
//  BzMoveToTodayViewController.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/08.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzMoveToTodayViewController: UIViewController {
    
    fileprivate var indicator : UIActivityIndicatorView? = nil
    fileprivate var snapshotImageView : UIImageView? = nil

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = BzAppThemeService.shared.mainBackgroundColor()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let imageView = self.snapshotImageView {
            imageView.removeFromSuperview()
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? BzAppDelegate else {
            return
        }
        guard let topController = appDelegate.topTabBarController else {
            return
        }
        
        guard let img = topController.view.imageRepresentation() else {
            return
        }
        let imgView = UIImageView(image: img)
        
        self.snapshotImageView = imgView
        self.view.addSubview(self.snapshotImageView!)
        
        if let indicator = self.indicator {
            indicator.removeFromSuperview()
        }

        let indicator = UIActivityIndicatorView(style: .gray)
        self.indicator = indicator
        
        indicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100) // CGRectMake(0, 0, 50, 50);
        indicator.center = self.view.center;
        
        self.view.addSubview(indicator)
        
        indicator.startAnimating()

    }
    override func viewWillDisappear(_ animated: Bool) {
        if let indicator = self.indicator {
            indicator.stopAnimating()
        }
        super.viewWillDisappear(animated)
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
