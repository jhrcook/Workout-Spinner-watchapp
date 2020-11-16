//
//  ExerciseIntensity.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 8/31/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation

enum ExerciseIntensity: String, Codable, CaseIterable {
    case light, medium, hard, grueling, killing
}

func == (lhs: ExerciseIntensity, rhs: ExerciseIntensity) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

enum ExerciseType: String, Codable, CaseIterable {
    case count, time
}

enum ExerciseBodyPart: String, Codable, CaseIterable {
    case arms, core, legs, back, cardio, neck
}
