//
//  PaceCalculator.swift
//  Jonah's Pace Calculator
//
//  Created by Jonah Starling on 3/8/20.
//  Copyright © 2020 Jonah Starling. All rights reserved.
//

import Foundation

class PaceCalculator {
    
    var timeHour: Double?
    var timeMinute: Double?
    var timeSecond: Double?
    
    var distance: Double?
    
    var paceMinute: Double?
    var paceSecond: Double?
    
    func timePresent() -> Bool {
        return timeHour != nil && timeMinute != nil && timeSecond != nil
    }
    
    func distancePresent() -> Bool {
        return distance != nil
    }
    
    func pacePresent() -> Bool {
        return paceMinute != nil && paceSecond != nil
    }
    
    func calculateTime() -> Bool {
        return false
    }
    
    func calculateDistance() -> Bool {
        return false
    }
    
    func calculatePace() -> Bool {
        return false
    }
    
    func calculateMissing() -> Bool {
        if distancePresent() && pacePresent() {
            return calculateTime()
        } else if timePresent() && pacePresent()  {
            return calculateDistance()
        } else if timePresent() && distancePresent() {
            return calculatePace()
        } else {
            return false
        }
    }
}
