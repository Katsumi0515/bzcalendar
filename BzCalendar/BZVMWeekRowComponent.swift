//
//  BZVMWeekRowComponent.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/06/22.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//
import Foundation


protocol BZVMWeekRowComponent {
    
    var weekNumber : Int { get }  // 1 月データの最初の週、２　月データの次の週、、、
    
    var fromDate : Date { get }   // ここのデータの最初の日（0:00分基準）
    var toDate : Date { get }     // ここのデータの最後の日（0:00分基準）
    
    func selectedDate(_ date: Date?)
    
    //func bzDate(index:Int) -> BzDate   // index 0..6
    
    func dayData(index:Int) -> BZVMWeekRowDayComponent
    
        
    //func setSelectedDate(date:Date)

    
}
