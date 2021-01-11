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
        crownVelocity.update(newValue: crownValue)
        readSelectedWorkout()
    }

    func rotationEffectDidFinish() {
        if crownVelocity.didPassThreshold {
            exerciseSelected = true
            crownVelocity.resetThreshold()
        }
    }

    func readSelectedWorkout() {
        let pointerAngle = 180.0
        let sliceAngle = 360.0 / Double(numExercises)
        let pointingAtAngle = (0.5 * sliceAngle) + (pointerAngle - spinDirection * crownRotation)
            .truncatingRemainder(dividingBy: 360.0)
        var pointingSlice = (pointingAtAngle / sliceAngle).rounded(.down)

        if pointingSlice < 0 {
            pointingSlice = Double(numExercises) + pointingSlice
        }

        workoutManager.exerciseInfo = exerciseOptions.exercises[selectedExerciseIndex]
        selectedExerciseIndex = min(Int(pointingSlice), numExercises - 1)
        logger.debug("selected exercise \"\(workoutManager.exerciseInfo?.displayName ?? "(none)")\" at index \(selectedExerciseIndex)")
    }
}
