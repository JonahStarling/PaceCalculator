//
//  Distances.swift
//  Jonah's Pace Calculator
//
//  Created by Jonah Starling on 3/6/20.
//  Copyright © 2020 Jonah Starling. All rights reserved.
//

import Foundation

class Distances {
    // Distances to be used in the Distance Section
    static let oneHundredMile = Distance(name: "100 MILES", lengthInMiles: 100.0)
    static let oneHundredKilometer = Distance(name: "100K", lengthInMiles: 100.0 * Convert.kilometerToMile)
    static let fiftyMile = Distance(name: "50 MILES", lengthInMiles: 50.0)
    static let fiftyKilometer = Distance(name: "50K", lengthInMiles: 50.0 * Convert.kilometerToMile)
    static let marathon = Distance(name: "MARATHON", lengthInMiles: 26.2188)
    static let halfMarathon = Distance(name: "HALF MARATHON", lengthInMiles: 13.1094)
    static let tenKilometer = Distance(name: "10K", lengthInMiles: 10.0 * Convert.kilometerToMile)
    static let eightKilometer = Distance(name: "8K", lengthInMiles: 8.0 * Convert.kilometerToMile)
    static let fiveKilometer = Distance(name: "5K", lengthInMiles: 5.0 * Convert.kilometerToMile)
    
    // Distances to be used in the Pace Section
    static let oneMile = Distance(name: "MILE", lengthInMiles: 1.0)
    static let oneKilometer = Distance(name: "KILOMETER", lengthInMiles: 1.0 * Convert.kilometerToMile)
    static let eightHundredMeters = Distance(name: "800 METERS", lengthInMiles: 800.0 * Convert.meterToMile)
    static let fourHundredMeters = Distance(name: "400 METERS", lengthInMiles: 400.0 * Convert.meterToMile)
    static let twoHundredMeters = Distance(name: "200 METERS", lengthInMiles: 200.0 * Convert.meterToMile)
    static let oneHundredMeters = Distance(name: "100 METERS", lengthInMiles: 100.0 * Convert.meterToMile)
}

class Distance {
    let name: String
    let lengthInMiles: Double
    
    init(lengthInMiles: Double) {
        self.name = ""
        self.lengthInMiles = lengthInMiles
    }
    
    init(name: String, lengthInMiles: Double) {
        self.name = name
        self.lengthInMiles = lengthInMiles
    }
}
