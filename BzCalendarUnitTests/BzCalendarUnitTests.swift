//
//  BzCalendarUnitTests.swift
//  BzCalendarUnitTests
//
//  Created by Katsumi Kobayashi on 2018/06/07.
//  Copyright © 2018年 Katsumi KOBAYASHI. All rights reserved.
//

import XCTest
import EventKit

@testable import BzCalendar

class BzCalendarUnitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let calendar = Calendar.current

        var testDateComp = DateComponents()
        testDateComp.year = 2018
        testDateComp.month = 6
        testDateComp.day = 7

        var expFromDateComp = DateComponents()
        expFromDateComp.year = 2018
        expFromDateComp.month = 6
        expFromDateComp.day = 1
        let expFromDate = calendar.date(from: expFromDateComp)!

        let testDate = calendar.date(from: testDateComp)
        let sched = MonthScheduleComponent(containsDate:Date())
        let fromDate = sched.fromDate
        let toDate = sched.toDate
        let monthStartDate = sched.monthStartDate
        let monthEndDate = sched.monthStartDate

        XCTAssert( fromDate.compare(expFromDate) == .orderedSame )
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
