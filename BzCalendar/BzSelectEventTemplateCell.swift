//
//  BzSelectEventTemplateCell.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/14.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzSelectEventTemplateCell: UITableViewCell {

    @IBOutlet weak var calendarColorSampleView: UIView!
    
    @IBOutlet weak var templateTitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
