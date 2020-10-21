//
//  WorkoutView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/10/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct WorkoutView: View {
    
    let workoutInfo: WorkoutInfo
    
    var body: some View {
        Text(workoutInfo.displayName)
    }
}







struct WorkoutView_Previews: PreviewProvider {
    static var workoutOptions: WorkoutOptions {
        var ws = WorkoutOptions()
        let i = ws.workouts.first { $0.type == .count }!
        let j = ws.workouts.first { $0.type == .time }!
        ws.workouts = [i, j]
        return ws
    }
    
    static var previews: some View {
        Group {
            ForEach(workoutOptions.workouts) { workout in
                WorkoutView(workoutInfo: workout)
                    .previewDisplayName(workout.displayName)
            }
        }
    }
}
