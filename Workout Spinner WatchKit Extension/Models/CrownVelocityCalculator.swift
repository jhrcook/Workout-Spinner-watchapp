//
//  CrownVelocityCalculator.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/5/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation

class CrownVelocityCalculator: ObservableObject {
    private var history = [Double]()
    var currentVelocity: Double = 0.0

    var velocityThreshold: Double = 500.0
    private(set) var didPassThreshold: Bool = false

    var memory: Int = 10

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

        var diffs: Double = 0.0
        for i in 0 ..< (history.count - 1) {
            diffs += history[i + 1] - history[i]
        }

        currentVelocity = diffs / Double(history.count - 1)
        checkThreshold()
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
