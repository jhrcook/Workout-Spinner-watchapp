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

struct LinkedInfoRowView: View {
    let title: String
    let titleColor: Color
    let value: String
    
    var showEllipsis = true
    
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image(systemName: "ellipsis").opacity(showEllipsis ? 0.75 : 0.0).padding(5)
                    }
                }
                InfoRowView(title: title, titleColor: titleColor, value: value)
            }
        }
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
    
    @State private var showAllExercises: Bool = false
    @State private var showHeartRateChartView: Bool = false
    
    var body: some View {
        VStack {
            List {
                
                LinkedInfoRowView(title: "Number of exercises", titleColor: .green, value: "\(workoutTracker.numberOfExercises)") {
                    showAllExercises = true
                }
                .sheet(isPresented: $showAllExercises) {
                    ExerciseFinishView(workoutTracker: workoutTracker)
                        .toolbar(content: {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Done") {
                                    self.showAllExercises = false
                                }
                            }
                        })
                }
                
                InfoRowView(title: "Active Calories", titleColor: .yellow, value: "\(Int(workoutTracker.totalActiveCalories))")
                
                LinkedInfoRowView(title: "Average heart rate", titleColor: .red, value: averageHR, showEllipsis: averageHR != "NA") {
                    if averageHR != "NA" {
                        showHeartRateChartView = true
                    }
                }
                .sheet(isPresented: $showHeartRateChartView) {
                    HeartRateGraphView(workoutTracker: workoutTracker)
                        .toolbar(content: {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Close") {
                                    self.showHeartRateChartView = false
                                }
                            }
                        })
                }
                
                InfoRowView(title: "Min/Max heart rate", titleColor: .red, value: "\(minHR) / \(maxHR)")
                                
                ListViewTextButton(label: "Done") {
                    presentationMode.wrappedValue.dismiss()
                    workoutTracker.clear()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
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
