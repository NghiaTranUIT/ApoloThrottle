//
//  OldThrottle.swift
//  ZaloraUniversal
//
//  Created by NghiaTran on 11/15/17.
//  Copyright © 2017 com.zalora. All rights reserved.
//

import Foundation

@objc
enum ThrottleType: Int {
    case WishlistSync
    case CartSync
}

@objc
final class OldThrottle: NSObject {
    
    static let TimeIntervalDefault: NSTimeInterval = 5
    static let shared = OldThrottle()
    
    private var storage: [ThrottleType: NSTimer] = [:]
    private let interval: NSTimeInterval
    private var lock = NSLock()
    private let queue = dispatch_queue_create("com.zalora.api.throttler", DISPATCH_QUEUE_CONCURRENT)
    
    init(interval: NSTimeInterval = OldThrottle.TimeIntervalDefault) {
        self.interval = interval
    }
    
    func reset() {
        storage.forEach { _, timer in
            timer.invalidate()
        }
        storage.removeAll()
    }
    
    func throttle(with type: ThrottleType, block: () -> Void) {
        lock.lock()
        defer {
            lock.unlock()
        }
        
        // Discard
        guard storage[type] == nil else {
            return;
        }
        
        // Enqueue and execute block
        enqueueTimer(type)
        block()
    }
    
    private func enqueueTimer(type: ThrottleType) {
        let timer = NSTimer(timeInterval: interval,
                            target: self,
                            selector: #selector(self.timerFired),
                            userInfo: type.rawValue,
                            repeats: false)
        // Save
        self.storage[type] = timer
        
        // Background loop
        dispatch_async(queue) {
            let loop = NSRunLoop.currentRunLoop()
            loop.addTimer(timer, forMode: NSRunLoopCommonModes)
            loop.run()
        }
    }
    
    @objc private func timerFired(timer: NSTimer) {
        lock.lock()
        defer {
            lock.unlock()
        }
        
        guard let rawValue = timer.userInfo as? Int,
        let type = ThrottleType(rawValue: rawValue),
        let _timer = storage[type] else {
            return
        }
        
        _timer.invalidate()
        storage.removeValueForKey(type)
    }
}
