//
//  BzStartAndEndDateTblViewCell.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/05/11.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import UIKit

class BzStartAndEndDateTblViewCell: UITableViewCell {

    @IBOutlet weak var startDateTitle: UILabel!
    @IBOutlet weak var startDateText: UILabel!
    @IBOutlet weak var endDateTitle: UILabel!
    @IBOutlet weak var endDateText: UILabel!
    
    func updateCell(startDate:Date?, endDate:Date?, allday:Bool = false) {
        self.updateDateFormatter(allday: allday)
        self.startDateTitle.text = NSLocalizedString("Common_ExactWord_Start", comment:"開始")
        self.endDateTitle.text = NSLocalizedString("Common_ExactWord_End", comment:"終了")
        self.startDateText.text = ""
        self.endDateText.text = ""
        
        if let startDate = startDate {
            var text = self.dateFormatter.string(from: startDate)
            let timeText = self.timeFormatter.string(from: startDate)
            if timeText.isEmpty == false {
                text = text + " " + timeText
            }
            self.startDateText.text = text
        }
        if let endDate = endDate {
            var text = self.dateFormatter.string(from: endDate)
            let timeText = self.timeFormatter.string(from: endDate)
            if timeText.isEmpty == false {
                text = text + " " + timeText
            }
            self.endDateText.text = text
        }
    }
    fileprivate var dateFormatter : DateFormatter = DateFormatter()
    fileprivate var timeFormatter : DateFormatter = DateFormatter()

    fileprivate func updateDateFormatter(allday:Bool) {
        if allday == true {
            dateFormatter.dateStyle =  .full;
            dateFormatter.timeStyle = .none;
            timeFormatter.dateStyle = .none
            timeFormatter.timeStyle = .none
        } else {
            dateFormatter.dateStyle =  .full;
            dateFormatter.timeStyle = .none;
            timeFormatter.dateStyle = .none;
            timeFormatter.timeStyle = .short
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
