//
//  SwiftUIView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 10/26/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import os
import SwiftUI

struct WorkoutPagingView: View {
    @ObservedObject var workoutManager: WorkoutManager
    @ObservedObject var workoutTracker: WorkoutTracker
    @ObservedObject var exerciseOptions: ExerciseOptions

    @State private var currentPageIndex: Int = 0
    @State private var exerciseSelectedByPicker = false
    @State private var exerciseCanceled = false
    @State private var exerciseComplete = false
    @State private var confirmFinishWorkout = false

    @Environment(\.presentationMode) var presentationMode

    let logger = Logger.workoutPagingViewLogger

    var body: some View {
        ZStack {
            if exerciseOptions.numberOfExercisesFiltered < 5 {
                CannotSpinView(workoutManager: workoutManager, exerciseOptions: exerciseOptions, presentationMode: presentationMode)
            } else if currentPageIndex == 0 {
                ExercisePicker(workoutManager: workoutManager,
                               exerciseOptions: exerciseOptions,
                               exerciseSelected: $exerciseSelectedByPicker)
                    .sheet(isPresented: $exerciseSelectedByPicker, onDismiss: {
                        if !exerciseCanceled {
                            startExercise()
                            withAnimation(.none) { currentPageIndex = 1 }
                        }
                    }) {
                        ExerciseStartView(workoutManager: workoutManager, exerciseCanceled: $exerciseCanceled)
                            .navigationTitle(Text(""))
                    }
                    .onLongPressGesture {
                        logger.info("Long press gesture recognized - finished workout.")
                        confirmFinishWorkout = true
                    }
            } else if currentPageIndex == 1 {
                ExerciseView(workoutManager: workoutManager, workoutTracker: workoutTracker, exerciseComplete: $exerciseComplete)
                    .sheet(isPresented: $exerciseComplete, onDismiss: {
                        currentPageIndex = 0
                    }) {
                        ExerciseFinishView(workoutTracker: workoutTracker)
                            .onAppear {
                                finishExercise()
                            }
                            .toolbar(content: {
                                ToolbarItem(placement: .cancellationAction) {
                                    Button("Done") {
                                        logger.info("ExerciseFinishView dismissed.")
                                        self.exerciseComplete = false
                                    }
                                }
                            })
                    }
            } else {
                WorkoutFinishView(workoutManager: workoutManager, workoutTracker: workoutTracker)
                    .navigationBarBackButtonHidden(true)
                    // This is a bit of a hack to remove the "<" back arrow button.
                    .toolbar(content: {
                        ToolbarItem(placement: .cancellationAction) {
                            EmptyView()
                        }
                    })
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $confirmFinishWorkout) {
            Alert(
                title: Text("Finish workout?"),
                message: Text("Are you sure you want to finish your workout?"),
                primaryButton: .destructive(Text("Finish"), action: finishWorkout),
                secondaryButton: .cancel()
            )
        }
    }
}

extension WorkoutPagingView {
    /// Complete a single exercise.
    func finishExercise() {
        switch workoutManager.session.state {
        case .running:
            logger.log("Finished exercise --> pausing workout session.")
            workoutManager.pauseWorkout()
        default:
            break
        }
    }

    /// Start an exercise.
    func startExercise() {
        switch workoutManager.session.state {
        case .notStarted, .prepared:
            logger.log("Starting exercise: \(workoutManager.exerciseInfo!.displayName, privacy: .public).")
            workoutManager.startWorkout()
        case .paused:
            logger.log("Resuming exercise: \(workoutManager.exerciseInfo!.displayName, privacy: .public).")
            workoutManager.resumeWorkout()
        default:
            break
        }
    }

    /// Complete the entire workout session.
    func finishWorkout() {
        logger.log("Finishing workout.")
        workoutManager.endWorkout()
        if workoutTracker.data.count > 0 {
            currentPageIndex = 2
        } else {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct WorkoutPagingView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutPagingView(workoutManager: WorkoutManager(), workoutTracker: WorkoutTracker(), exerciseOptions: ExerciseOptions())
    }
}
