//
//  HeartRateGraphData.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 11/5/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation

struct HeartRateGraphDatum {
    let x: Double
    let y: Double
    let groupIndex: Int
}

struct HeartRateGraphData {
    var data: [HeartRateGraphDatum]

    var minX: Double {
        return data.map { $0.x }.min()!
    }

    var minY: Double {
        return data.map { $0.y }.min()!
    }

    var maxX: Double {
        return data.map { $0.x }.max()!
    }

    var maxY: Double {
        return data.map { $0.y }.max()!
    }

    init(workoutTraker: WorkoutTracker) {
        data = HeartRateGraphData.workoutTrackerDataToGraphData(workoutTraker)
//        self.data = HeartRateGraphData.mockHeartRateData()
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

    func convertedXData(toMin: Double, toMax: Double) -> [Double] {
        return data.map { convert(x: $0.x, toMin: toMin, toMax: toMax) }
    }

    func convertedYData(toMin: Double, toMax: Double) -> [Double] {
        return data.map { convert(y: $0.y, toMin: toMin, toMax: toMax) }
    }

    func convert(x: Double, toMin: Double, toMax: Double) -> Double {
        return x.rangeMap(inMin: minX, inMax: maxX, outMin: toMin, outMax: toMax)
    }

    func convert(y: Double, toMin: Double, toMax: Double) -> Double {
        return y.rangeMap(inMin: minY, inMax: maxY, outMin: toMin, outMax: toMax)
    }
}

extension HeartRateGraphData {
    static func mockHeartRateData() -> [HeartRateGraphDatum] {
        var d = [HeartRateGraphDatum]()
        var x = 0.0
        for i in 0 ..< 5 {
            let n = (5 ... 25).randomElement()!
            var y = 50.0
            for _ in 0 ..< n {
                x += 1
                y += Double.random(in: -5.0 ... 5.0)
                d.append(HeartRateGraphDatum(x: x, y: y, groupIndex: i))
            }
        }
        return d
    }
}
