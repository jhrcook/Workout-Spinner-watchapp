//
//  WelcomeView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 10/24/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct StartWorkoutButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color.darkGray)
            )
    }
}

struct WelcomeView: View {
    @ObservedObject var workoutManager: WorkoutManager
    @ObservedObject var workoutTracker: WorkoutTracker
    @ObservedObject var exerciseOptions: ExerciseOptions

    @State private var startWorkout = false
    @State private var presentSettingsView = false

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

            Text("Press and hold the spinner to finish the workout.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)

            Spacer(minLength: 0)

            Button(action: {
                presentSettingsView = true
            }) {
                HStack {
                    Image(systemName: "gearshape").font(.system(size: 14))
                    Text("Settings").font(.system(size: 14))
                }
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.top, 3)
        }
        .ignoresSafeArea(SafeAreaRegions.all, edges: .bottom)
        .sheet(isPresented: self.$presentSettingsView) {
            Settings(exerciseOptions: exerciseOptions)
                .toolbar(content: {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Done") {
                            self.presentSettingsView = false
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
