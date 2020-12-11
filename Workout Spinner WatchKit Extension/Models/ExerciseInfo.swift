//
//  Workout.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 8/31/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation

struct ExerciseInfo: Identifiable, Codable, Equatable {
    let id: String
    let displayName: String
    let type: ExerciseType
    let bodyParts: [ExerciseBodyPart]
    let workoutValue: [String: Float]
    var active: Bool = true
    var shortDescription: String {
        "\(displayName) (\(id))"
    }

    var longDescription: String {
        "\(id). \(displayName) - type: \(type.rawValue), num bodyparts: \(bodyParts.count), active: \(active)"
    }

    static func == (lhs: ExerciseInfo, rhs: ExerciseInfo) -> Bool {
        return lhs.id == rhs.id
    }
}
