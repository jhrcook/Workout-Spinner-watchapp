//
//  WorkoutPicker.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/1/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI


struct WorkoutSlice: View {
    
    let workout: Workout
    let idx: Int
    let numberOfWorkouts: Int
    let size: CGFloat
    
    let offset: CGFloat = 8.0
    var halfOffset: CGFloat {
        (offset / 2.0) - 2.0
    }
    
    var body: some View {
        Text(workout.displayName)
            .font(.system(.footnote))
            .lineLimit(1)
            .frame(width: size / 2 - offset, height: nil, alignment: .trailing)
            .padding(2)
            .offset(x: size / 4 + halfOffset, y: 0)
            .rotationEffect(.degrees(Double(idx) * 360.0 / Double(numberOfWorkouts)))
    }
}

struct ColorSlice: View {
    let idx: Int
    let numberOfSlices: Int
    let size: CGFloat
    
    var body: some View {
        IsoscelesTriangle(angle: .degrees(360.0 / Double(numberOfSlices)))
            .foregroundColor(Color.randomPastelColor())
            .rotationEffect(.degrees(Double(idx) * 360.0 / Double(numberOfSlices)))
    }
}


struct WorkoutPicker: View {
    
    let workouts = Workouts()
    @State private var rotationAmount = 0.0
    
    var numWorkouts: Int {
        return workouts.workouts.count
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<self.numWorkouts) { i in
                    ColorSlice(idx: i, numberOfSlices: self.numWorkouts, size: geo.minSize)
                }
                ForEach(0..<self.numWorkouts) { i in
                    WorkoutSlice(workout: self.workouts.workouts[i], idx: i, numberOfWorkouts: self.numWorkouts, size: geo.minSize)
                }
            }
            .focusable()
            .digitalCrownRotation(self.$rotationAmount)
            .rotationEffect(.degrees(self.rotationAmount))
        }
    }
}

struct WorkoutPicker_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutPicker()
    }
}
