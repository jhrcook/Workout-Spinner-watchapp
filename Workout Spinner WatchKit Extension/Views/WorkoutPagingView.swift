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
    
    var body: some View {
        VStack {
            PagerManager(pageCount: 3, currentIndex: $currentPageIndex) {
                WorkoutPicker(workoutManager: workoutManager)
                WorkoutStartView(workoutManager: workoutManager)
                WorkoutView(workoutManager: workoutManager)
            }
            .onTapGesture() {
                withAnimation(.default) {
                    currentPageIndex = currentPageIndex == 2 ? 0 : currentPageIndex + 1
                }
            }
        }
    }
}

struct WorkoutPagingView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutPagingView(workoutManager: WorkoutManager())
    }
}
