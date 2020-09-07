//
//  WorkoutPickerViewModel.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/7/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

extension WorkoutPicker {
    func crownRotationDidChange(crownValue: Double) {
        crownVelocity.update(newValue: crownValue)
        readSelectedWorkout()
    }
    
    func rotationEffectDidFinish() {
        if crownVelocity.didPassThreshold {
            workoutSelected.toggle()
            crownVelocity.resetThreshold()
        }
    }
    
    func readSelectedWorkout() {
        let pointerAngle = 180.0
        let sliceAngle = 360.0 / Double(numWorkouts)
        let pointingAtAngle = (0.5 * sliceAngle) + (pointerAngle + crownRotation).truncatingRemainder(dividingBy: 360.0)
        var pointingSlice = (pointingAtAngle / sliceAngle).rounded(.down)
        
        if pointingSlice < 0 {
            pointingSlice = Double(numWorkouts) + pointingSlice
        }
        
        self.selectedWorkoutIndex = min(Int(pointingSlice), numWorkouts - 1)
    }
}
