//
//  UserDefaultsKeys.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/7/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation

enum UserDefaultsKeys: String {
    case exerciseIntensity
    case activeBodyParts
    case exerciseOptions
    case crownVelocityMultiplier
}

extension UserDefaults {
    static func readCrownVelocityMultiplier() -> Double {
        let m = standard.double(forKey: UserDefaultsKeys.crownVelocityMultiplier.rawValue)
        return m > 0.0 ? m : 1.0
    }
}
