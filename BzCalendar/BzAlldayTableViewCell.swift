//
//  BzAlldayTableViewCell.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/05.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzAlldayTableViewCell: UITableViewCell {

    @IBOutlet weak var alldayLabel: UILabel!
    @IBOutlet weak var alldaySwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
