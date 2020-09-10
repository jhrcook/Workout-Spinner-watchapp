//
//  Workout.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 8/31/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation

struct Workout: Identifiable, Codable, Equatable {
    let id: String
    let displayName: String
    let type: ExerciseType
    let bodyParts: [ExerciseBodyPart]
    let workoutValue: [String: Float]
    
    
    static func == (lhs: Workout, rhs: Workout) -> Bool {
        return lhs.id == rhs.id
    }
}
