//
//   Configure the view for the selected state     } BzCalendarChooserCell.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/08/03.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzCalendarChooserCell: UITableViewCell {

    @IBOutlet weak var colorSampleView: UIView!
    
    @IBOutlet weak var calendarTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
