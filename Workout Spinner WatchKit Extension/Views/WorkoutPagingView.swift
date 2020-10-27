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
    
    var body: some View {
        ZStack {
            if currentPageIndex == 0 {
                WorkoutPicker(workoutManager: workoutManager, workoutSelected: $workoutSelectedByPicker)
                    .sheet(isPresented: $workoutSelectedByPicker, onDismiss: {
                        if !workoutCanceled {
                            withAnimation(.none) { currentPageIndex = 1 }
                        }
                    }) {
                        WorkoutStartView(workoutManager: workoutManager, workoutCanceled: $workoutCanceled)
                    }
            } else {
                WorkoutView(workoutManager: workoutManager)
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
