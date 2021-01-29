//
//  WorkoutPickerViewModel.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/7/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

extension ExercisePicker {
    func crownRotationDidChange(crownValue: Double) {
        if crownValue == previousCrownRotation { return }
        previousCrownRotation = crownValue
        spinningWheel.crownInput(angle: crownValue * crownVelocityMultiplier, at: Date())
        velocityTracker.update(newValue: spinningWheel.wheelVelocity)
        readSelectedWorkout()
    }

    func rotationEffectDidFinish() {
        if velocityTracker.didPassThreshold {
            hapticsSettings.play(soundFor: .successfulWheelSpin, ifSet: hapticsSettings.successfulWheelSpin)
            exerciseSelected = true
            velocityTracker.resetThreshold()
        }
    }

    func readSelectedWorkout() {
        let pointerAngle = 180.0
        let sliceAngle = 360.0 / Double(numExercises)
        let pointingAtAngle = (0.5 * sliceAngle) + (pointerAngle - spinDirection * spinningWheel.wheelRotation)
            .truncatingRemainder(dividingBy: 360.0)
        var pointingSlice = (pointingAtAngle / sliceAngle).rounded(.down)

        if pointingSlice < 0 {
            pointingSlice = Double(numExercises) + pointingSlice
        }

        workoutManager.exerciseInfo = exerciseOptions.exercises[selectedExerciseIndex]
        selectedExerciseIndex = min(Int(pointingSlice), numExercises - 1)
    }
}
