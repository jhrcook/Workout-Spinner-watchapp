//
//  WorkoutListView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 8/31/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI


struct WorkoutRow: View {
    
    let workout: Workout
    
    var body: some View {
        Text(workout.displayName)
    }
}

struct WorkoutListView: View {
    
    let workouts = Workouts()
    
    var body: some View {
        List(workouts.workouts) { workout in
            WorkoutRow(workout: workout)
        }
    }
}

struct WorkoutListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutListView()
    }
}
