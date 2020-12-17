//
//  WelcomeView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 10/24/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import os
import SwiftUI

struct StartWorkoutText: View {
    let fontSize: CGFloat = 25
    let screenWidth: CGFloat

    init(screenWidth: CGFloat) {
        self.screenWidth = screenWidth
    }

    static let width4mmSeries6: CGFloat = 183.0

    var body: some View {
        Text("Start Workout")
            .font(.system(size: fontSize * screenWidth / StartWorkoutText.width4mmSeries6))
            .foregroundColor(.white)
            .bold()
            .multilineTextAlignment(.center)
            .padding()
    }
}

struct PulsingStartWorkoutButtonImage: View {
    @State var arrowButtonSize: CGFloat = 1.0
    var body: some View {
        Image(systemName: "arrow.right.circle.fill")
            .font(.system(size: 80))
            .foregroundColor(.workoutRed)
            .scaleEffect(arrowButtonSize)
            .animation(
                Animation.easeInOut(duration: 1.0)
                    .repeatForever(autoreverses: true)
            ).onAppear {
                self.arrowButtonSize = 0.9
            }
    }
}

struct WelcomeView: View {
    @ObservedObject var workoutManager: WorkoutManager
    @ObservedObject var workoutTracker: WorkoutTracker
    @ObservedObject var exerciseOptions: ExerciseOptions

    @State private var startWorkout = false
    @State private var presentSettingsView = false
    @State private var showInstructions = false

    let logger = Logger.welcomeViewLogger

    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer(minLength: 0)

                StartWorkoutText(screenWidth: geo.size.width)

                NavigationLink(
                    destination: WorkoutPagingView(workoutManager: workoutManager,
                                                   workoutTracker: workoutTracker,
                                                   exerciseOptions: exerciseOptions)
                ) {
                    PulsingStartWorkoutButtonImage()
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.vertical, 5)

                Spacer(minLength: 0)

                HStack {
                    Spacer()

                    Button(action: {
                        logger.info("Instruction button tapped.")
                        logger.debug("Geometry Reader size -- width: \(geo.size.width) x height: \(geo.size.height)")
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
