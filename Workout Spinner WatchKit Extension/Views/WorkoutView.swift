//
//  WorkoutView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/10/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct WorkoutView: View {
    
    let workout: Workout
    
    var body: some View {
        Text(workout.displayName)
    }
}







struct WorkoutView_Previews: PreviewProvider {
    static var workouts: Workouts {
        var ws = Workouts()
        let i = ws.workouts.first { $0.type == .count }!
        let j = ws.workouts.first { $0.type == .time }!
        ws.workouts = [i, j]
        return ws
    }
    
    static var previews: some View {
        Group {
            ForEach(workouts.workouts) { workout in
                WorkoutView(workout: workout)
                    .previewDisplayName(workout.displayName)
            }
        }
    }
}
