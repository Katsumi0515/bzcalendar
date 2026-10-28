//
//  File.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/08.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import Foundation
import QuartzCore

extension UIView {
    func imageRepresentation() -> UIImage? {
        guard let window = self.window else {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, (window.screen.scale));
        
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let ret = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext();
        
        return ret!

    }
}
