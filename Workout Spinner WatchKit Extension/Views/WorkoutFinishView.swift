//
//  WorkoutFinishView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 10/30/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct WorkoutFinishView: View {
    
    @ObservedObject var workoutManager: WorkoutManager
    @ObservedObject var workoutTracker: WorkoutTracker
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("\(workoutTracker.numberOfExercises) exercises")
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Done")
            }
        }
    }
}

struct WorkoutFinishView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutFinishView(workoutManager: WorkoutManager(), workoutTracker: WorkoutTracker())
    }
}
