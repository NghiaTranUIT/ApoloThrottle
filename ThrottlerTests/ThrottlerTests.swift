//
//  ThrottlerTests.swift
//  ThrottlerTests
//
//  Created by NghiaTran on 11/15/17.
//  Copyright © 2017 Zalora. All rights reserved.
//

import XCTest
@testable import Throttler

extension OldThrottle {
    
    func run(type: ThrottleType, inout log: [String], tag: Int) {
        self.throttle(with: type) {
            log.append("Sync \(tag)")
        }
    }
}

class ThrottlerTests: XCTestCase {
    
    var throttler: OldThrottle!
    
    override func setUp() {
        super.setUp()
        throttler = OldThrottle(interval: 0.5)
    }
    
    override func tearDown() {
        super.tearDown()
        throttler.reset()
    }
    
    func testThrottle() {
        var log: [String] = []
        let expected = ["Sync 0"]
        
        throttler.run(ThrottleType.WishlistSync, log: &log, tag: 0)
        throttler.run(ThrottleType.WishlistSync, log: &log, tag: 1)
        throttler.run(ThrottleType.WishlistSync, log: &log, tag: 2)
        throttler.run(ThrottleType.WishlistSync, log: &log, tag: 3)
        throttler.run(ThrottleType.WishlistSync, log: &log, tag: 4)
        throttler.run(ThrottleType.WishlistSync, log: &log, tag: 5)
        throttler.run(ThrottleType.WishlistSync, log: &log, tag: 6)
        throttler.run(ThrottleType.WishlistSync, log: &log, tag: 7)
        throttler.run(ThrottleType.WishlistSync, log: &log, tag: 8)
        
        XCTAssertEqual(log.count, 1, "Throttle log should equal 1")
        XCTAssertEqual(log, expected, "Throttle log should contain 0th, 5th, 9th actions")
    }
    
    func testThrottleWhenTooManyCall() {
        var log: [String] = []
        let expected = ["Sync 0", "Sync 5", "Sync 9"]
        
        throttler.run(ThrottleType.WishlistSync, log: &log, tag: 0)
        throttler.run(ThrottleType.WishlistSync, log: &log, tag: 1)
        throttler.run(ThrottleType.WishlistSync, log: &log, tag: 2)
        throttler.run(ThrottleType.WishlistSync, log: &log, tag: 3)
        throttler.run(ThrottleType.WishlistSync, log: &log, tag: 4)
    
        sleep(1)
        
        throttler.run(ThrottleType.WishlistSync, log: &log, tag: 5)
        throttler.run(ThrottleType.WishlistSync, log: &log, tag: 6)
        throttler.run(ThrottleType.WishlistSync, log: &log, tag: 7)
        throttler.run(ThrottleType.WishlistSync, log: &log, tag: 8)
        
        sleep(1)
        
        throttler.run(ThrottleType.WishlistSync, log: &log, tag: 9)
        throttler.run(ThrottleType.WishlistSync, log: &log, tag: 10)
        throttler.run(ThrottleType.WishlistSync, log: &log, tag: 11)
        
        XCTAssertEqual(log.count, 3, "Throttle log should equal 3")
        XCTAssertEqual(log, expected, "Throttle log should contain 0th, 5th, 9th actions")
    }
}
