//
//  ContentView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 8/31/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    let workoutManager = WorkoutManager()
    let workoutTracker = WorkoutTracker()
    let exerciseOptions = ExerciseOptions()
    
    var body: some View {
        WelcomeView(workoutManager: workoutManager, workoutTracker: workoutTracker, exerciseOptions: exerciseOptions)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
