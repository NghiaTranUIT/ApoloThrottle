//
//  ThrottleTests.swift
//  Throttler
//
//  Created by NghiaTran on 11/16/17.
//  Copyright © 2017 Zalora. All rights reserved.
//

import XCTest
@testable import Throttler

extension Throttle {
    func run(inout log: [String], tag: Int) {
        throttle {
            log.append("\(tag)")
        }
    }
}

class ThrottleTests: XCTestCase {
    
    var throttler: Throttle!
    
    override func setUp() {
        super.setUp()
        throttler = Throttle(interval: 1.0)
    }
    
    override func tearDown() {
        super.tearDown()
        throttler = nil
    }
    
    func testThrottle() {
        var log: [String] = []
        let expected = ["0"]
        
        throttler.run(&log, tag: 0)
        throttler.run(&log, tag: 1)
        throttler.run(&log, tag: 2)
        throttler.run(&log, tag: 3)
        throttler.run(&log, tag: 4)
        throttler.run(&log, tag: 5)
        throttler.run(&log, tag: 6)
        throttler.run(&log, tag: 7)
        throttler.run(&log, tag: 8)
        
        XCTAssertEqual(log.count, expected.count, "Throttle log should equal 1")
        XCTAssertEqual(log, expected, "Throttle log should contain 0th action")
    }
    
    func testThrottleShouldSkipWhenTooManyCall() {
        var log: [String] = []
        let expected = ["0", "5", "9"]
        
        throttler.run(&log, tag: 0)
        throttler.run(&log, tag: 1)
        throttler.run(&log, tag: 2)
        throttler.run(&log, tag: 3)
        throttler.run(&log, tag: 4)
        
        sleep(2)
        
        throttler.run(&log, tag: 5)
        throttler.run(&log, tag: 6)
        throttler.run(&log, tag: 7)
        throttler.run(&log, tag: 8)
        
        sleep(2)
        
        throttler.run(&log, tag: 9)
        throttler.run(&log, tag: 10)
        throttler.run(&log, tag: 11)
        
        XCTAssertEqual(log.count, expected.count, "Throttle log should equal 3")
        XCTAssertEqual(log, expected, "Throttle log should contain 0th, 5th, 9th actions")
    }

}
