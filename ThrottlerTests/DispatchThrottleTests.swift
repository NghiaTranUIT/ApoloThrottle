//
//  DispatchThrottleTests.swift
//  Throttler
//
//  Created by NghiaTran on 11/15/17.
//  Copyright © 2017 Zalora. All rights reserved.
//

import XCTest
@testable import Throttler

extension DispatchThrottle {
    
    func run(type: String, inout log: [String], tag: Int) {
        dispatch(with: type) {
            log.append("\(tag)")
        }
    }
}

class DispatchThrottleTests: XCTestCase {
    
    var dispatcher: DispatchThrottle!
    
    private let kWishListSync = "WishlistSync"
    private let kCartSync = "CartSync"
    
    override func setUp() {
        super.setUp()
        dispatcher = DispatchThrottle(interval: 1.0)
    }
    
    override func tearDown() {
        super.tearDown()
        dispatcher.reset()
    }
    
    func testOneEndpoint() {
        
        var log: [String] = []
        let expected = ["0"]
        
        dispatcher.run(kWishListSync, log: &log, tag: 0)
        dispatcher.run(kWishListSync, log: &log, tag: 1)
        dispatcher.run(kWishListSync, log: &log, tag: 2)
        dispatcher.run(kWishListSync, log: &log, tag: 3)
        dispatcher.run(kWishListSync, log: &log, tag: 4)
        dispatcher.run(kWishListSync, log: &log, tag: 5)
        dispatcher.run(kWishListSync, log: &log, tag: 6)
        dispatcher.run(kWishListSync, log: &log, tag: 7)
        dispatcher.run(kWishListSync, log: &log, tag: 8)
        
        XCTAssertEqual(log.count, expected.count, "Throttle log should equal 1")
        XCTAssertEqual(log, expected, "Throttle log should contain 0th, 5th, 9th actions")
    }
    
    func testTwoEndpoint() {
        
        var log: [String] = []
        let expected = ["0", "3"]
        
        dispatcher.run(kWishListSync, log: &log, tag: 0)
        dispatcher.run(kWishListSync, log: &log, tag: 1)
        dispatcher.run(kWishListSync, log: &log, tag: 2)
        
        dispatcher.run(kCartSync, log: &log, tag: 3)
        dispatcher.run(kCartSync, log: &log, tag: 4)
        dispatcher.run(kCartSync, log: &log, tag: 5)
        
        dispatcher.run(kWishListSync, log: &log, tag: 6)
        dispatcher.run(kWishListSync, log: &log, tag: 7)
        dispatcher.run(kWishListSync, log: &log, tag: 8)
        dispatcher.run(kWishListSync, log: &log, tag: 9)
        dispatcher.run(kWishListSync, log: &log, tag: 10)
        
        dispatcher.run(kCartSync, log: &log, tag: 11)
        dispatcher.run(kCartSync, log: &log, tag: 12)
        dispatcher.run(kCartSync, log: &log, tag: 13)
        
        XCTAssertEqual(log.count, expected.count, "Throttle log should equal 2")
        XCTAssertEqual(log, expected, "Throttle log should contain 0th, 3rf actions")
    }
    
    
    func testOneEndPointWithSleep() {
        
        var log: [String] = []
        let expected = ["0", "5", "9"]
        
        dispatcher.run(kWishListSync, log: &log, tag: 0)
        dispatcher.run(kWishListSync, log: &log, tag: 1)
        dispatcher.run(kWishListSync, log: &log, tag: 2)
        dispatcher.run(kWishListSync, log: &log, tag: 3)
        dispatcher.run(kWishListSync, log: &log, tag: 4)
        
        sleep(3)
        
        dispatcher.run(kWishListSync, log: &log, tag: 5)
        dispatcher.run(kWishListSync, log: &log, tag: 6)
        dispatcher.run(kWishListSync, log: &log, tag: 7)
        dispatcher.run(kWishListSync, log: &log, tag: 8)
        
        sleep(3)
        
        dispatcher.run(kWishListSync, log: &log, tag: 9)
        dispatcher.run(kWishListSync, log: &log, tag: 10)
        dispatcher.run(kWishListSync, log: &log, tag: 11)
        
        XCTAssertEqual(log.count, expected.count, "Throttle log should equal 3")
        XCTAssertEqual(log, expected, "Throttle log should contain 0th, 5th, 9th actions")
    }

    func testTwoEndPointWithSleepl() {
        
        var log: [String] = []
        let expected = ["0", "5", "8", "12", "15"]
        
        dispatcher.run(kWishListSync, log: &log, tag: 0)
        dispatcher.run(kWishListSync, log: &log, tag: 1)
        dispatcher.run(kWishListSync, log: &log, tag: 2)
        dispatcher.run(kWishListSync, log: &log, tag: 3)
        dispatcher.run(kWishListSync, log: &log, tag: 4)
        
        sleep(2)
        
        dispatcher.run(kCartSync, log: &log, tag: 5)
        dispatcher.run(kCartSync, log: &log, tag: 6)
        dispatcher.run(kCartSync, log: &log, tag: 7)
        
        dispatcher.run(kWishListSync, log: &log, tag: 8)
        dispatcher.run(kWishListSync, log: &log, tag: 9)
        dispatcher.run(kWishListSync, log: &log, tag: 10)
        dispatcher.run(kWishListSync, log: &log, tag: 11)
        
        sleep(2)
        
        dispatcher.run(kCartSync, log: &log, tag: 12)
        dispatcher.run(kCartSync, log: &log, tag: 13)
        dispatcher.run(kCartSync, log: &log, tag: 14)
        
        dispatcher.run(kWishListSync, log: &log, tag: 15)
        dispatcher.run(kWishListSync, log: &log, tag: 16)
        dispatcher.run(kWishListSync, log: &log, tag: 17)
        
        XCTAssertEqual(log.count, expected.count, "Throttle log should equal 5")
        XCTAssertEqual(log, expected, "Throttle log should contain 0th, 5th, 9th actions")
    }
    
}
