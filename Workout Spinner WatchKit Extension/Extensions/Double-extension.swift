//
//  Double-extension.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 11/5/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation

extension Double {
    func rangeMap(inMin: Double, inMax: Double, outMin: Double, outMax: Double) -> Double {
        return (self - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
    }
}
