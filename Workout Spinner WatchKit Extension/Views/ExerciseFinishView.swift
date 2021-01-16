//
//  ExerciseFinishView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 10/29/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct SmallImageAndTextView: View {
    let imageName: String
    let text: String
    let imageColor: Color

    let font: Font = .system(size: 14)

    var body: some View {
        HStack {
            Image(systemName: imageName).font(font).foregroundColor(imageColor)
            Text(text).font(font)
        }
    }
}

struct ExerciseDataRowView: View {
    let data: WorkoutTrackerDatum

    var averageHeartRate: Int {
        return Int(average(data.heartRate.map { $0.heartRate }).rounded())
    }

    var body: some View {
        VStack {
            HStack {
                Text("\(data.exerciseInfo.displayName)").bold()
                Spacer()
            }.padding(.bottom, 2)
            HStack {
                Spacer()
                SmallImageAndTextView(imageName: "heart", text: data.heartRate.count == 0 ? "NA" : "\(averageHeartRate)", imageColor: .red)
                Spacer()
                SmallImageAndTextView(imageName: "flame", text: "\(Int(data.activeCalories.rounded()))", imageColor: .yellow)
                Spacer()
                SmallImageAndTextView(imageName: "stopwatch", text: "\(Int(data.duration.rounded()))", imageColor: .blue)
                Spacer()
            }
        }
    }

    internal func average(_ x: [Double]) -> Double {
        if x.count == 0 {
            return 0
        }
        return x.reduce(0, +) / Double(x.count)
    }
}

struct ExerciseFinishView: View {
    @ObservedObject var workoutTracker: WorkoutTracker

    var body: some View {
        List {
            ForEach(workoutTracker.data) { data in
                ExerciseDataRowView(data: data)
            }
        }
    }
}

#if DEBUG
    struct ExerciseFinishView_Previews: PreviewProvider {
        static var previews: some View {
            ExerciseFinishView(workoutTracker: WorkoutTracker())
        }
    }
#endif
