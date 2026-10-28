//
//  BzMonthScheduleComponent.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/06/22.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import Foundation

protocol BZVMMonthlyViewContents {
    
    // 月表示の方法で最初の週に先月の最終週が、最後の週に次月の最初の週がくる場合がある
    // fromDate <= monthStartDate < monthEndDate <= toDate の関係
    // 例　2018年9月のカレンダー
    // 26 27 28 29 30 31  1   // 26-31は8月
    //  2  3  4  5  6  7  8
    //  ...
    // 23 24 25 26 27 28 29
    // 30  1  2  3  4  5  6　　// 1-6は10月
    // この場合、
    // fromDate         8/26
    // monthStartDate   9/1
    // monthEndDate     9/30
    // toDate           10/6
    
    var fromDate       : Date { get }
    var monthStartDate : Date { get }
    var monthEndDate   : Date { get }
    var toDate         : Date { get }
    
    func selectedDate(date:Date)
    func weekDataArray() -> Array<BZVMWeekRowComponent>
    
}
