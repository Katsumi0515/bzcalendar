//
//  BzColorSettingTableViewCell.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/04/10.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzColorSettingTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var colorSampleView: UIView!
    
    @IBOutlet weak var colorName: UILabel!
    
    @IBOutlet weak var colorCode: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
