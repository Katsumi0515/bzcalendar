//
//  BZVMWeeklyViewContents.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/06/12.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import Foundation

protocol BZVMWeeklyViewContents {
    // 対象の期間
    // 午前０時基準。8/3だと8/3の0時。
    // toDateの場合、対象となるスケジュールは8/4未満までなので注意のこと
    var fromDate : Date { get }
    var toDate   : Date { get }

    func selectedDate(_ selectedDate: Date?)
    
    var alldayViewContents : BZVMAlldayViewContents { get }

    //func date(index:Int) -> Date
    func bzDateArray() -> Array<BZVMWeeklyViewDayContents>
    
    
    //func dayData(index:Int) -> BZVMWeeklyViewDayContents
    
}
