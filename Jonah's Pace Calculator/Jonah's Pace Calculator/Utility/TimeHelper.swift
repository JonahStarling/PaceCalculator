//
//  TimeHelper.swift
//  Jonah's Pace Calculator
//
//  Created by Jonah Starling on 3/12/20.
//  Copyright © 2020 Jonah Starling. All rights reserved.
//

import Foundation

class TimeHelper {
    
    static func formatMinute(minutes: Double?) -> String {
        return formatTime(format: "%.0f", timeToFormat: minutes)
    }
    
    static func formatSecond(seconds: Double?) -> String {
        return formatTime(format: "%.2f", timeToFormat: seconds)
    }
    
    private static func formatTime(format: String, timeToFormat: Double?) -> String {
        guard let time: Double = timeToFormat else { return "" }
        if time >= 10 {
            return String(format: format, time)
        } else {
            return "0\(String(format: format, time))"
        }
    }
}
