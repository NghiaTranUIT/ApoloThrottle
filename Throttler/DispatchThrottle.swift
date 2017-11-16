//
//  DispatchThrottle.swift
//  Throttler
//
//  Created by NghiaTran on 11/15/17.
//  Copyright © 2017 Zalora. All rights reserved.
//

import Foundation

@objc
final class DispatchThrottle: NSObject {
    
    static let TimeIntervalDefault: NSTimeInterval = 5
    
    private var storage: [String: Throttle] = [:]
    private let interval: NSTimeInterval
    private var lock = NSLock()
    
    init(interval: NSTimeInterval = DispatchThrottle.TimeIntervalDefault) {
        self.interval = interval
    }
    
    func reset() {
        lock.lock()
        defer {
            lock.unlock()
        }
        storage.removeAll()
    }
    
    func dispatch(with id: String, block: () -> Void) {
        lock.lock()
        defer {
            lock.unlock()
        }
        
        // Discard
        let item = storage[id] ?? Throttle(interval: interval)
        item.throttle(block)
        storage[id] = item
    }
}
