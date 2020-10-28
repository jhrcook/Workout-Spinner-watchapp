//
//  SwiftUIView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 10/26/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct WorkoutPagingView: View {
    
    @ObservedObject var workoutManager: WorkoutManager
    @ObservedObject var workoutTracker: WorkoutTracker
    @State private var currentPageIndex: Int = 0
    
    @State private var exerciseSelectedByPicker = false
    @State private var exerciseCanceled = false
    @State private var exerciseComplete = false
    
    var body: some View {
        ZStack {
            if currentPageIndex == 0 {
                ExercisePicker(workoutManager: workoutManager, exerciseSelected: $exerciseSelectedByPicker)
                    .sheet(isPresented: $exerciseSelectedByPicker, onDismiss: {
                        if !exerciseCanceled {
                            withAnimation(.none) { currentPageIndex = 1 }
                        }
                    }) {
                        ExerciseStartView(workoutManager: workoutManager, exerciseCanceled: $exerciseCanceled).navigationTitle(Text(""))
                    }
            } else {
                ExerciseView(workoutManager: workoutManager, workoutTracker: workoutTracker, exerciseComplete: $exerciseComplete)
                    .sheet(isPresented: $exerciseComplete, onDismiss: {
                        currentPageIndex = 0
                    }) {
                        Text("Finished workout!")
                    }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct WorkoutPagingView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutPagingView(workoutManager: WorkoutManager(), workoutTracker: WorkoutTracker())
    }
}
