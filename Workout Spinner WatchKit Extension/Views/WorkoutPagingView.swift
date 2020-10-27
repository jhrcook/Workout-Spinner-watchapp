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
    @State private var currentPageIndex: Int = 0
    
    @State private var workoutSelectedByPicker = false
    @State private var workoutCanceled = false
    @State private var exerciseComplete = false
    
    var body: some View {
        ZStack {
            if currentPageIndex == 0 {
                WorkoutPicker(workoutManager: workoutManager, workoutSelected: $workoutSelectedByPicker)
                    .sheet(isPresented: $workoutSelectedByPicker, onDismiss: {
                        if !workoutCanceled {
                            withAnimation(.none) { currentPageIndex = 1 }
                        }
                    }) {
                        WorkoutStartView(workoutManager: workoutManager, workoutCanceled: $workoutCanceled).navigationTitle(Text(""))
                    }
            } else {
                WorkoutView(workoutManager: workoutManager, exerciseComplete: $exerciseComplete)
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
        WorkoutPagingView(workoutManager: WorkoutManager())
    }
}
