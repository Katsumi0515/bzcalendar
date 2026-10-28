//
//  BZVMWeekRowDayComponent.swift
//  BzCalendar
//
//  Created by Katsumi Kobayashi on 2018/06/22.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import Foundation

protocol BZVMWeekRowDayComponent: BzDate {
    
    var isThisMonth: Bool { get set }
    var isSelectedDate : Bool { get set }
    // 既に表示するrow indexを計算済のBZVMWeekRowDayItemの配列
    // ロングイベントと通常のイベントのどちらも同じように扱っている
    func dayItems() -> Array<BZVMWeekRowItem>
    
}

