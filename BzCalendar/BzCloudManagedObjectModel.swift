//
//  BzCloudManagedObjectModel.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/04/18.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

@objc @objcMembers class BzCloudManagedObjectModel: NSObject {
    let modelName : String = "BzCloud"
    let modelType : String = "momd"
    
    fileprivate var managedObjectModel: NSManagedObjectModel? = nil
    
    override init() {
        
    }
    
    func bzCloudObjectModel() -> NSManagedObjectModel {
        if let model = managedObjectModel {
            return model
        }
        if let path = Bundle.main.path(forResource: self.modelName, ofType: self.modelType) {
            let momURL = URL(fileURLWithPath: path)
            self.managedObjectModel = NSManagedObjectModel(contentsOf: momURL)
        } else {
            fatalError("could not initialized")
        }
        return self.managedObjectModel!;

    }

}
