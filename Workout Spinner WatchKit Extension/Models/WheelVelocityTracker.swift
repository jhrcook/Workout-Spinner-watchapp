//
//  CrownVelocityCalculator.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/5/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation

class WheelVelocityTracker: ObservableObject {
    private var history = [Double]()
    var velocityThreshold: Double = 50.0
    private(set) var didPassThreshold: Bool = false
    var memory: Int = 10
    private(set) var currentVelocity = 0.0

    init() {}

    init(memory: Int) {
        self.memory = memory
    }

    init(velocityThreshold: Double) {
        self.velocityThreshold = velocityThreshold
    }

    init(velocityThreshold: Double, memory: Int) {
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
