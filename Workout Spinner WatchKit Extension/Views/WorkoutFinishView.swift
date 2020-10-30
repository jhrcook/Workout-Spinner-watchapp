//
//  WorkoutFinishView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 10/30/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI


struct InfoRowView: View {
    let title: String
    let titleColor: Color
    let value: String
    
    var body: some View {
        VStack {
            HStack {
                Text(title).foregroundColor(titleColor).font(.system(size: 13))
                Spacer()
            }
            HStack {
                Text(value).font(.system(size: 15))
                Spacer()
            }
        }
    }
}

struct DoneButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(5)
            .background(
                RoundedRectangle(cornerRadius: 25, style: .continuous).fill(Color(red: 194, green: 255, blue: 60))
            )
    }
}


struct WorkoutFinishView: View {
    
    @ObservedObject var workoutManager: WorkoutManager
    @ObservedObject var workoutTracker: WorkoutTracker
    
    @Environment(\.presentationMode) var presentationMode
    
    private var averageHR: String {
        return valueAsIntStringOrNA(workoutTracker.averageHeartRate)
    }
    private var minHR: String {
        return valueAsIntStringOrNA(workoutTracker.minHeartRate)
    }
    private var maxHR: String {
        return valueAsIntStringOrNA(workoutTracker.maxHeartRate)
    }
    
    var body: some View {
        VStack {
            List {
                InfoRowView(title: "Number of exercises", titleColor: .green, value: "\(workoutTracker.numberOfExercises)")
                InfoRowView(title: "Active Calories", titleColor: .yellow, value: "\(Int(workoutTracker.totalActiveCalories))")
                InfoRowView(title: "Average heart rate", titleColor: .red, value: averageHR)
                InfoRowView(title: "Min/Max heart rate", titleColor: .red, value: "\(minHR) / \(maxHR)")
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Done")
                        .foregroundColor(.black)
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
                .listStyle(PlainListStyle())
                .listRowPlatterColor(.clear)
                .buttonStyle(DoneButtonStyle())
            }
        }
    }
    
    func valueAsIntStringOrNA(_ x: Double?) -> String {
        return x == nil ? "NA" : "\(Int(x!.rounded()))"
    }
}

struct WorkoutFinishView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutFinishView(workoutManager: WorkoutManager(), workoutTracker: WorkoutTracker())
    }
}
