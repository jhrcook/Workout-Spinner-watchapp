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
    let hapticsSettings = HapticsSettings()

    var body: some View {
        WelcomeView(workoutManager: workoutManager, workoutTracker: workoutTracker, exerciseOptions: exerciseOptions)
            .environmentObject(hapticsSettings)
    }
}

#if DEBUG
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
#endif
