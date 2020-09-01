//
//  Workout.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 8/31/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation

struct Workout: Identifiable, Codable {
    let id: String
    let displayName: String
    let type: ExerciseType
    let bodyParts: [ExerciseBodyPart]
    let workoutValue: [ExerciseIntensity: Float] = [:]
    
//    var shortName: String {
//        if displayName.count > 7 {
//            return displayName.substring(to: 7)
//        }
//    }
}
