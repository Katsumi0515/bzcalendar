//
//  BzSelectOthersTblViewExtFunctionCell.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/07/10.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzSelectOthersTblViewExtFunctionCell: UITableViewCell {

    @IBOutlet weak var extSwitch: UISwitch!
    @IBOutlet weak var extLabel: UILabel!
    @IBOutlet weak var extDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
