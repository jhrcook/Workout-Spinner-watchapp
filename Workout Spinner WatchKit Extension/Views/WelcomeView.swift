//
//  WelcomeView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 10/24/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject var workoutManager: WorkoutManager
    @ObservedObject var workoutTracker: WorkoutTracker
    @ObservedObject var exerciseOptions: ExerciseOptions

    @State private var startWorkout = false
    @State private var presentSettingsView = false
    @State private var showInstructions = false

    var body: some View {
        VStack {
            Spacer(minLength: 0)

            NavigationLink(destination: WorkoutPagingView(workoutManager: workoutManager, workoutTracker: workoutTracker, exerciseOptions: exerciseOptions)) {
                Text("Start Workout")
                    .font(.system(size: 30))
                    .foregroundColor(.workoutRed)
                    .bold()
                    .multilineTextAlignment(.center)
            }
            .buttonStyle(StartWorkoutButtonStyle())
            .padding(.bottom, 5)

            Spacer(minLength: 0)

            HStack {
                Spacer()

                Button(action: {
                    showInstructions = true
                }) {
                    Image(systemName: "info.circle").font(.system(size: 18))
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 3)

                Spacer()

                NavigationLink(
                    destination: Settings(exerciseOptions: exerciseOptions)) {
                    Image(systemName: "gearshape").font(.system(size: 18))
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 3)

                Spacer()
            }
            .padding(.top, 3)
        }
        .ignoresSafeArea(SafeAreaRegions.all, edges: .bottom)
        .sheet(isPresented: $showInstructions) {
            Text("INSTRUCTIONS!")
                .toolbar(content: {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Done") {
                            self.showInstructions = false
                        }
                    }
                })
        }
        .onAppear {
            workoutManager.requestAuthorization()
            workoutManager.setupWorkout()
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(workoutManager: WorkoutManager(), workoutTracker: WorkoutTracker(), exerciseOptions: ExerciseOptions())
    }
}
