//
//  WorkoutTracker.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 10/28/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation


class WorkoutTracker: NSObject, ObservableObject {
    var data = [WorkoutTrackerDatum]()
    var numberOfExercises: Int {
        data.count
    }
}


struct WorkoutTrackerDatum {
    let exerciseInfo: ExerciseInfo
    let duration: Double
    let activeCalories: Double
    let heartRate: [Double]
}
