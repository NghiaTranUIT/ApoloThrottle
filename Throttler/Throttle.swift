//
//  Throttle.swift
//  OldThrottle
//
//  Created by NghiaTran on 11/15/17.
//  Copyright © 2017 Zalora. All rights reserved.
//

import Foundation
import QuartzCore

@objc
final class Throttle: NSObject {
    
    private let interval: NSTimeInterval
    private var isInitial = true
    private var lastExecuted = CACurrentMediaTime()
    
    init(interval: NSTimeInterval) {
        self.interval = interval
    }
    
    func throttle(block: () -> Void) {
        let now = CACurrentMediaTime()
        let delta = now - lastExecuted
        if delta > interval || isInitial {
            lastExecuted = now
            isInitial = false
            
            // Execute
            block()
        }
    }
}

