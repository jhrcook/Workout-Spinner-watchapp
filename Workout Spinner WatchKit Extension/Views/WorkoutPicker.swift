//
//  WorkoutPicker.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/1/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

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
                    SpinnerSlice(idx: i,
                                 numberOfSlices: self.numWorkouts,
                                 width: geo.minSize)
                }
                ForEach(0..<self.numWorkouts) { i in
                    WorkoutSlice(workout: self.workouts.workouts[i],
                                 idx: i,
                                 numberOfWorkouts: self.numWorkouts,
                                 size: geo.minSize)
                }
            }
            .padding(0)
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
