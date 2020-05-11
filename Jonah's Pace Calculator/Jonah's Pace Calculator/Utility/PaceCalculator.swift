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
    
    enum ValueConverted {
        case Time
        case Distance
        case Pace
        case Error
    }
    
    func timePresent() -> Bool {
        return timeHour != nil || timeMinute != nil || timeSecond != nil
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
    
    func getTimeInSeconds() -> Double? {
        // Make sure at least one of the time variables is not equal to nil
        if timeHour != nil || timeMinute != nil || timeSecond != nil {
            let hourSeconds = (timeHour ?? 0.0) * minutesInHour * secondsInMinute
            let minuteSeconds = (timeMinute ?? 0.0) * secondsInMinute
            let seconds = timeSecond ?? 0.0
            return hourSeconds + minuteSeconds + seconds
        } else {
            // This state should never be reached
            return nil
        }
    }
    
    // Returns whether or not the calculation was successful
    func calculateTime() -> Bool {
        // Check if pace data is valid
        let convertedPaceTimeInSeconds = convertPaceTimeToMileTimeInSeconds()
        guard convertedPaceTimeInSeconds != nil && convertedPaceTimeInSeconds != 0.0 else { return false }
        // Check is distance data is valid
        guard distance != nil else { return false }
        // If we reach this point then all data needed should be valid
        let timeInSeconds = convertedPaceTimeInSeconds! * distance!.lengthInMiles
        var timeLeft = timeInSeconds
        self.timeHour = (timeLeft - (timeLeft.truncatingRemainder(dividingBy: secondsInMinute * minutesInHour))) / (secondsInMinute * minutesInHour)
        timeLeft = timeLeft.truncatingRemainder(dividingBy: secondsInMinute * minutesInHour)
        self.timeMinute = (timeLeft - (timeLeft.truncatingRemainder(dividingBy: secondsInMinute))) / secondsInMinute
        self.timeSecond = timeLeft.truncatingRemainder(dividingBy: secondsInMinute)
        return true
    }
    
    // TODO: This function may not be fully functional
    // Ex. Will this work if the distance we are wanting is not miles, but kilometers?
    func calculateDistance() -> Bool {
        // Check if pace data is valid
        let convertedPaceTimeInSeconds = convertPaceTimeToMileTimeInSeconds()
        guard convertedPaceTimeInSeconds != nil && convertedPaceTimeInSeconds != 0.0 else { return false }
        // Check if time data is valid
        let timeInSeconds = getTimeInSeconds()
        guard timeInSeconds != nil && timeInSeconds != 0.0 else { return false }
        // If we reach this point then all data needed should be valid
        self.distance = Distance(lengthInMiles: timeInSeconds! / convertedPaceTimeInSeconds!)
        return true
    }
    
    func calculatePace() -> Bool {
        // Check if time data is valid
        let timeInSeconds = getTimeInSeconds()
        guard timeInSeconds != nil && timeInSeconds != 0.0 else { return false }
        // Check is distance data is valid
        guard distance != nil else { return false }
        // TODO: This is currently set up to only work for miles
        // Ex. What if we want pace per kilometer?
        let paceSeconds = timeInSeconds! / distance!.lengthInMiles
        self.paceMinute = (paceSeconds - (paceSeconds.truncatingRemainder(dividingBy: secondsInMinute))) / secondsInMinute
        self.paceSecond = paceSeconds.truncatingRemainder(dividingBy: secondsInMinute)
        return true
    }
    
    func calculateMissing() -> ValueConverted {
        if distancePresent() && pacePresent() {
            if calculateTime() {
                return ValueConverted.Time
            }
        } else if timePresent() && pacePresent()  {
            if calculateDistance() {
                return ValueConverted.Distance
            }
        } else if timePresent() && distancePresent() {
            if calculatePace() {
                return ValueConverted.Pace
            }
        }
        return ValueConverted.Error
    }
    
    func clear() {
        timeHour = nil
        timeMinute = nil
        timeSecond = nil
        
        distance = nil
        
        paceMinute = nil
        paceSecond = nil
        paceUnit = Distances.oneMile
    }
}
