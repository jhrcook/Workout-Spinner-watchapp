//
//  WelcomeView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 10/24/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import os
import SwiftUI

struct WelcomeView: View {
    @ObservedObject var workoutManager: WorkoutManager
    @ObservedObject var workoutTracker: WorkoutTracker
    @ObservedObject var exerciseOptions: ExerciseOptions

    @State var arrowButtonSize: CGFloat = 1.0

    @State private var startWorkout = false
    @State private var presentSettingsView = false
    @State private var showInstructions = false

    let logger = Logger.welcomeViewLogger

    var body: some View {
        VStack {
            Spacer(minLength: 0)

            Text("Start Workout")
                .font(.system(size: 25))
                .foregroundColor(.white)
                .bold()
                .multilineTextAlignment(.center)
                .padding()

            NavigationLink(
                destination: WorkoutPagingView(workoutManager: workoutManager,
                                               workoutTracker: workoutTracker,
                                               exerciseOptions: exerciseOptions)
            ) {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.workoutRed)
                    .scaleEffect(arrowButtonSize)
                    .animation(
                        Animation.easeInOut(duration: 1.0)
                            .repeatForever(autoreverses: true)
                    )
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.vertical, 5)

            Spacer(minLength: 0)

            HStack {
                Spacer()

                Button(action: {
                    logger.info("Instruction button tapped.")
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
            InstructionsView()
                .toolbar(content: {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Done") {
                            self.showInstructions = false
                        }
                    }
                })
        }
        .onAppear {
            self.logger.info("WelcomeView did appear.")
            self.arrowButtonSize = 0.9
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
