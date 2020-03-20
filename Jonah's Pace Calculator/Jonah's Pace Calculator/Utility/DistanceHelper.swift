//
//  DistanceHelper.swift
//  Jonah's Pace Calculator
//
//  Created by Jonah Starling on 3/12/20.
//  Copyright © 2020 Jonah Starling. All rights reserved.
//

import Foundation

class DistanceHelper {
    
    static func convertAndFormat(distanceInMiles: Distance?, conversionDistance: Distance) -> String {
        guard let distance = distanceInMiles else { return "" }
        let convertedDistance = distance.lengthInMiles * conversionDistance.lengthInMiles
        return formatDistance(distance: convertedDistance)
    }
    
    private static func formatDistance(distance: Double) -> String {
        return String(format: "%.2f", distance)
    }
}
