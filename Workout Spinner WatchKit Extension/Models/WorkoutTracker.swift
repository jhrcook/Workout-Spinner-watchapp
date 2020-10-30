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
    
    var totalActiveCalories: Double {
        return data.map { $0.activeCalories }.reduce(0, +)
    }
    
    var totalDuration: Double {
        return data.map { $0.duration }.reduce(0, +)
    }
    
    var averageHeartRate: Double? {
        if data.count < 1 { return nil }
        let HRtotal = data.map { $0.heartRate.reduce(0, +) }.reduce(0, +)
        let HRcount = data.map { $0.heartRate.count}.reduce(0, +)
        if HRcount == 0 { return nil }
        return HRtotal / Double(HRcount)
    }
    
    var maxHeartRate: Double? {
        if data.count < 1 { return nil }
        let x = data.map { ($0.heartRate.max()) ?? 0 }.max() ?? 0
        return x == 0.0 ? nil : x
    }
    
    var minHeartRate: Double? {
        if data.count < 1 { return nil }
        let x = data.map { ($0.heartRate.min()) ?? 0 }.min() ?? 0
        return x == 0.0 ? nil : x
    }
    
    
    func addData(info: ExerciseInfo, duration: Double, activeCalories: Double, heartRate: [Double]) {
        let newData = WorkoutTrackerDatum(exerciseInfo: info, duration: duration, activeCalories: activeCalories, heartRate: heartRate)
        data.append(newData)
    }
}


struct WorkoutTrackerDatum: Identifiable {
    let id = UUID()
    let exerciseInfo: ExerciseInfo
    let duration: Double
    let activeCalories: Double
    let heartRate: [Double]
}
