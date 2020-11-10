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
        let pointingAtAngle = (0.5 * sliceAngle) + (pointerAngle + crownRotation).truncatingRemainder(dividingBy: 360.0)
        var pointingSlice = (pointingAtAngle / sliceAngle).rounded(.down)
        
        if pointingSlice < 0 {
            pointingSlice = Double(numExercises) + pointingSlice
        }
        
        workoutManager.exerciseInfo = exerciseOptions.exercises[selectedExerciseIndex]
        self.selectedExerciseIndex = min(Int(pointingSlice), numExercises - 1)
    }
    
    
    static func loadWorkouts() -> ExerciseOptions {
        var workouts = ExerciseOptions()
        
        // An array of the body parts to keep inactive.
        var inactiveBodyparts: [ExerciseBodyPart] {
            BodyPartSelections()
                .bodyparts
                .filter { !$0.enabled }
                .map { $0.bodypart }
        }
        
        // Remove workouts that contain blacklisted exercises.
        workouts.exercises = workouts.exercises.filter { workout in
            if let _ = workout.bodyParts.first(where: { inactiveBodyparts.contains($0) }) {
                return false
            }
            return true
        }
        return workouts
    }
}
