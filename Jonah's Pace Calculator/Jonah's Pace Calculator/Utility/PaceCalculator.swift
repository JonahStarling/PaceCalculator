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
    var distanceUnit: Distance = Distances.oneMile
    
    var paceMinute: Double?
    var paceSecond: Double?
    var paceUnit: Distance = Distances.oneMile
    
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
        return paceMinute != nil || paceSecond != nil
    }
    
    func convertPaceTimeToMileTimeInSeconds() -> Double? {
        var convertedPaceSeconds: Double? = nil
        let totalPaceSeconds = ((paceMinute ?? 0) * 60) + (paceSecond ?? 0)
        convertedPaceSeconds = (totalPaceSeconds * paceUnit.lengthInMiles)
        return convertedPaceSeconds
    }
    
    func getPaceInSeconds() -> Double? {
        return ((paceMinute ?? 0) * 60) + (paceSecond ?? 0)
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
        var paceInSeconds = 0.0
        if distanceUnit.name == Distances.oneMile.name {
            paceInSeconds = convertPaceTimeToMileTimeInSeconds() ?? 0.0
        } else {
            paceInSeconds = getPaceInSeconds() ?? 0.0
        }
        guard paceInSeconds != 0.0 else { return false }
        // Check is distance data is valid
        guard distance != nil else { return false }
        // If we reach this point then all data needed should be valid
        var distanceValue = 0.0
        if distanceUnit.name == Distances.oneMile.name {
            distanceValue = (distance!.lengthInMiles / distanceUnit.lengthInMiles)
        } else if distanceUnit.name == paceUnit.name {
            distanceValue = distance!.lengthInMiles * Convert.mileToKilometer
        } else {
            distanceValue = distance!.lengthInMiles
        }
        let timeInSeconds = paceInSeconds * distanceValue
        
        // Divy out the seconds
        var timeLeft = timeInSeconds
        self.timeHour = (timeLeft - (timeLeft.truncatingRemainder(dividingBy: secondsInMinute * minutesInHour))) / (secondsInMinute * minutesInHour)
        timeLeft = timeLeft.truncatingRemainder(dividingBy: secondsInMinute * minutesInHour)
        self.timeMinute = (timeLeft - (timeLeft.truncatingRemainder(dividingBy: secondsInMinute))) / secondsInMinute
        self.timeSecond = timeLeft.truncatingRemainder(dividingBy: secondsInMinute)
        return true
    }
    
    func calculateDistance() -> Bool {
        // Check if pace data is valid
        var paceInSeconds = 0.0
        if paceUnit.name == distanceUnit.name || paceUnit.name == Distances.oneKilometer.name {
            paceInSeconds = convertPaceTimeToMileTimeInSeconds() ?? 0.0
        } else {
            paceInSeconds = getPaceInSeconds() ?? 0.0
        }
        guard paceInSeconds != 0.0 else { return false }
        // Check if time data is valid
        let timeInSeconds = getTimeInSeconds()
        guard timeInSeconds != nil && timeInSeconds != 0.0 else { return false }
        // If we reach this point then all data needed should be valid
        self.distance = Distance(lengthInMiles: timeInSeconds! / paceInSeconds)
        return true
    }
    
    func calculatePace() -> Bool {
        // Check if time data is valid
        let timeInSeconds = getTimeInSeconds()
        guard timeInSeconds != nil && timeInSeconds != 0.0 else { return false }
        // Check is distance data is valid
        guard distance != nil else { return false }
        let paceSeconds = timeInSeconds! / (distance!.lengthInMiles * paceUnit.lengthInMiles)
        self.paceMinute = (paceSeconds - (paceSeconds.truncatingRemainder(dividingBy: secondsInMinute))) / secondsInMinute
        self.paceSecond = paceSeconds.truncatingRemainder(dividingBy: secondsInMinute)
        return true
    }
    
    func calculateMissing() -> ValueConverted {
        if distancePresent() && pacePresent() && !timePresent() {
            if calculateTime() {
                return ValueConverted.Time
            }
        } else if timePresent() && pacePresent() && !distancePresent() {
            if calculateDistance() {
                return ValueConverted.Distance
            }
        } else if timePresent() && distancePresent() && !pacePresent() {
            if calculatePace() {
                return ValueConverted.Pace
            }
        }
        return ValueConverted.Error
    }
    
    func switchDistanceUnit() {
        if self.distanceUnit.name == Distances.oneMile.name {
            self.distanceUnit = Distances.oneKilometer
        } else {
            self.distanceUnit = Distances.oneMile
        }
    }
    
    func switchPaceUnit() {
        if self.paceUnit.name == Distances.oneMile.name {
            self.paceUnit = Distances.oneKilometer
        } else {
            self.paceUnit = Distances.oneMile
        }
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
