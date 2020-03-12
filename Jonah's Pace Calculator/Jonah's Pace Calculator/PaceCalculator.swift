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
    
    var distance: Distance?
    
    var paceMinute: Double?
    var paceSecond: Double?
    var paceUnit: Distance? = Distances.oneMile
    
    let secondsInMinute: Double = 60
    let minutesInHour: Double = 60
    
    func timePresent() -> Bool {
        return timeHour != nil && timeMinute != nil && timeSecond != nil
    }
    
    func distancePresent() -> Bool {
        return distance != nil
    }
    
    func pacePresent() -> Bool {
        return paceMinute != nil && paceSecond != nil
    }
    
    func convertPaceTimeToMileTimeInSeconds() -> Double? {
        var convertedPaceSeconds: Double? = nil
        let totalPaceSeconds = ((paceMinute ?? 0) * 60) + (paceSecond ?? 0)
        if let unitInMiles = paceUnit?.lengthInMiles {
            convertedPaceSeconds = (totalPaceSeconds / unitInMiles)
        }
        return convertedPaceSeconds
    }
    
    func calculateTime() -> Bool {
        let convertedPaceTimeInSeconds = convertPaceTimeToMileTimeInSeconds()
        guard convertedPaceTimeInSeconds != nil && convertedPaceTimeInSeconds != 0.0 && distance != nil else { return false }
        let timeInSeconds = convertedPaceTimeInSeconds! * distance!.lengthInMiles
        var timeLeft = timeInSeconds
        self.timeHour = (timeLeft - (timeLeft.truncatingRemainder(dividingBy: secondsInMinute * minutesInHour))) / (secondsInMinute * minutesInHour)
        timeLeft = timeLeft.truncatingRemainder(dividingBy: secondsInMinute * minutesInHour)
        self.timeMinute = (timeLeft - (timeLeft.truncatingRemainder(dividingBy: secondsInMinute))) / secondsInMinute
        timeLeft = timeLeft.truncatingRemainder(dividingBy: secondsInMinute)
        self.timeSecond = timeLeft
        return true
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
