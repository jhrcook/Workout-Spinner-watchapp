//
//  CrownVelocityCalculator.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/5/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation
import WatchKit

class WheelVelocityTracker: ObservableObject {
    let velocityThreshold: Double
    let memory: Int
    private var history = [Double]()
    private(set) var didPassThreshold: Bool = false
    private(set) var currentVelocity = 0.0

    init(velocityThreshold: Double = 5, memory: Int = 3) {
        self.velocityThreshold = velocityThreshold
        self.memory = memory
    }

    func update(newValue x: Double) {
        history.append(x)
        if history.count < memory { return }

        if history.count > memory {
            history = history.suffix(memory)
        }

        currentVelocity = average(history)
        checkThreshold()
    }

    private func average(_ x: [Double]) -> Double {
        x.reduce(0, +) / Double(x.count)
    }

    func checkThreshold() {
        if !didPassThreshold {
            didPassThreshold = abs(currentVelocity) > velocityThreshold
        }
    }

    func resetThreshold() {
        didPassThreshold = false
    }
}
