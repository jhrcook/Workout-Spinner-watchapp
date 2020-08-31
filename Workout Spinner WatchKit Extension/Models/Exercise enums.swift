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


enum ExerciseType: String, Codable, CaseIterable {
    case time, count
}


enum ExerciseBodyPart: String, Codable, CaseIterable {
    case arms, core, legs, back, cardio, neck
}
