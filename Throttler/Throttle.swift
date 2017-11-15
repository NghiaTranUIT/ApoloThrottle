//
//  Throttle.swift
//  OldThrottle
//
//  Created by NghiaTran on 11/15/17.
//  Copyright © 2017 Zalora. All rights reserved.
//

import Foundation

class Throttle {
    
    private let interval: NSTimeInterval
    
    var isTimeElapsed = false
    var lastExecuted = DISPATCH_TIME_NOW
    
    init(interval: NSTimeInterval) {
        self.interval = interval
    }
    
    func throttle(block: () -> ()) {
        let now = DISPATCH_TIME_NOW
        if now - lastExecuted < dispatch_time_t(interval) {
            return;
        }
        
        self.lastExecuted = DISPATCH_TIME_NOW
        self.isTimeElapsed = true
        
        // Execute
        block()
    }
}

