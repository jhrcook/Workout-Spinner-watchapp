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
    let geo: GeometryProxy
    
    let offset: CGFloat = 8.0
    var halfOffset: CGFloat {
        (offset / 2.0) - 2.0
    }
    
    var body: some View {
        Text(workout.displayName)
            .font(.system(.footnote))
            .lineLimit(1)
            .frame(width: geo.size.width / 2 - offset, height: nil, alignment: .trailing)
            .padding(2)
            .offset(x: geo.size.width / 4 + halfOffset, y: 0)
            .rotationEffect(.degrees(Double(idx) * 360.0 / Double(numberOfWorkouts)))
    }
}


struct WorkoutPicker: View {
    
    let workouts = Workouts()
    @State private var rotationAmount = 0.0
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                RadialGradient(gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple]), center: .center, startRadius: 0, endRadius: 100)
                    .frame(width: geo.size.width, height: geo.size.width)
                    .clipShape(Circle())
                    .opacity(0.5)
                ForEach(0..<self.workouts.workouts.count) { i in
                    WorkoutSlice(workout: self.workouts.workouts[i], idx: i, numberOfWorkouts: self.workouts.workouts.count, geo: geo)
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
