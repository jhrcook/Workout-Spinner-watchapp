//
//  HeartRateGraphData-extension.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 1/15/21.
//  Copyright © 2021 Joshua Cook. All rights reserved.
//

import Foundation
import HeartRateGraph

extension HeartRateGraphData {
    init(workoutTraker: WorkoutTracker) {
        let data = HeartRateGraphData.workoutTrackerDataToGraphData(workoutTraker)
        self.init(data: data)
    }

    static func workoutTrackerDataToGraphData(_ workoutTracker: WorkoutTracker) -> [HeartRateGraphDatum] {
        var HRData = [HeartRateGraphDatum]()
        var previousEndingX = 0.0
        for (dataIdx, data) in workoutTracker.data.filter({ $0.heartRate.count > 0 }).enumerated() {
            if data.heartRate.count > 0 {
                let startingX = data.heartRate.first!.date.timeIntervalSince1970
                for hr in data.heartRate {
                    let hrTime = hr.date.timeIntervalSince1970 - startingX + previousEndingX + 2.0
                    HRData.append(HeartRateGraphDatum(x: hrTime, y: hr.heartRate, groupIndex: dataIdx))
                }
                previousEndingX = HRData.last!.x
            }
        }
        return HRData
    }
}

extension HeartRateGraphView {
    init(workoutTracker: WorkoutTracker) {
        let graphData = HeartRateGraphData(workoutTraker: workoutTracker)
        self.init(graphData: graphData)
    }
}
