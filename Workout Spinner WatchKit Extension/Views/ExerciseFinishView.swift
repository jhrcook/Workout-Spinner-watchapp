//
//  ExerciseFinishView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 10/29/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct ExerciseFinishView: View {
    
    @ObservedObject var workoutTracker: WorkoutTracker
    
    var body: some View {
        Text("Completed \(workoutTracker.numberOfExercises) exercises!")
    }
}

struct ExerciseFinishView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseFinishView(workoutTracker: WorkoutTracker())
    }
}
