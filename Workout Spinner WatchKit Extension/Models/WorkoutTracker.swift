//
//  WorkoutTracker.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 10/28/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation

class WorkoutTracker: NSObject, ObservableObject {
    /// Collected data of exercises.
    var data = [WorkoutTrackerDatum]()

    /// Number of exercises tracked.
    var numberOfExercises: Int {
        data.count
    }

    /// Total active calories.
    var totalActiveCalories: Double {
        return data.map { $0.activeCalories }.reduce(0, +)
    }

    /// Total duration.
    var totalDuration: Double {
        return data.map { $0.duration }.reduce(0, +)
    }

    /// Average heart rate reading.
    var averageHeartRate: Double? {
        if data.count < 1 { return nil }
        let HRtotal = data
            .map { $0.heartRate.map { $0.heartRate }.reduce(0, +) }
            .reduce(0, +)
        let HRcount = data
            .map { $0.heartRate.count }
            .reduce(0, +)
        if HRcount == 0 { return nil }
        return HRtotal / Double(HRcount)
    }

    /// Maximum heart rate reading.
    var maxHeartRate: Double? {
        if data.count < 1 { return nil }
        let x = data
            .map { ($0.heartRate.map { $0.heartRate }.max()) ?? 0 }
            .max() ?? 0
        return x == 0.0 ? nil : x
    }

    /// Minimum heart rate reading.
    var minHeartRate: Double? {
        if data.count < 1 { return nil }
        let x = data
            .filter { $0.heartRate.count > 0 }
            .map { ($0.heartRate.map { $0.heartRate }.min()) ?? 0 }
            .min() ?? 0
        return x == 0.0 ? nil : x
    }

    /// Add a new data point.
    /// - Parameters:
    ///   - info: Exercise information object
    ///   - duration: duration of exercise
    ///   - activeCalories: active calories consumed during exercise
    ///   - heartRate: heart rate data throughout the evercise
    func addData(info: ExerciseInfo, duration: Double, activeCalories: Double, heartRate: [WorkoutManager.HeartRateReading]) {
        let newData = WorkoutTrackerDatum(exerciseInfo: info, duration: duration, activeCalories: activeCalories, heartRate: heartRate)
        data.append(newData)
    }

    /// Clear the tracked data.
    func clear() {
        data = []
    }
}

struct WorkoutTrackerDatum: Identifiable {
    let id = UUID()
    let exerciseInfo: ExerciseInfo
    let duration: Double
    let activeCalories: Double
    let heartRate: [WorkoutManager.HeartRateReading]
}
