//
//  WorkoutPicker.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/1/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Combine
import os
import SwiftUI

struct ExercisePicker: View {
    @ObservedObject var workoutManager: WorkoutManager
    @ObservedObject var exerciseOptions: ExerciseOptions
    @State internal var crownRotation = 0.0
    var wheelRotation: Double {
        crownRotation * crownVelocityMultiplier
    }

    var numExercises: Int {
        return exerciseOptions.exercisesBlacklistFiltered.count
    }

    var crownVelocity = CrownVelocityCalculator(velocityThreshold: 50, memory: 20)
    var crownVelocityMultiplier: Double = {
        let m = UserDefaults.standard.double(forKey: UserDefaultsKeys.crownVelocityMultiplier.rawValue)
        return m > 0.0 ? m : 1.0
    }()

    @Binding internal var exerciseSelected: Bool
    @State internal var selectedExerciseIndex: Int = 0

    var spinDirection: Double {
        return WKInterfaceDevice().crownOrientation == .left ? 1.0 : -1.0
    }

    let logger = Logger.exercisePickerLogger

    init(workoutManager: WorkoutManager, exerciseOptions: ExerciseOptions, exerciseSelected: Binding<Bool>) {
        logger.info("Initializing ExercisePicker.")
        self.workoutManager = workoutManager
        self.exerciseOptions = exerciseOptions
        _exerciseSelected = exerciseSelected
        logger.debug("Finished initializing ExercisePicker.")
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                GeometryReader { geo in
                    ZStack {
                        ZStack {
                            ForEach(0 ..< self.numExercises) { i in
                                SpinnerSlice(idx: i,
                                             numberOfSlices: self.numExercises,
                                             width: geo.minSize * 2.0)
                            }
                            ForEach(0 ..< self.numExercises) { i in
                                WorkoutSlice(workoutInfo: self.exerciseOptions.exercisesBlacklistFiltered[i],
                                             idx: i,
                                             numberOfWorkouts: self.numExercises,
                                             size: geo.minSize * 2.0)
                            }
                        }
                        .modifier(SpinnerRotationModifier(
                            rotation: .degrees(self.spinDirection * self.wheelRotation),
                            onFinishedRotationAnimation: self.rotationEffectDidFinish
                        ))
                        .animation(.default)

                        HStack {
                            SpinnerPointer()
                                .frame(width: 35, height: 25)
                                .opacity(0.8)
                            Spacer()
                        }
                    }
                    .frame(width: geo.minSize * 2, height: geo.minSize * 2, alignment: .center)
                    .offset(x: 0, y: geo.minSize / -2.0)
                }
                .edgesIgnoringSafeArea(.bottom)
                .padding(0)
                .focusable()
                .digitalCrownRotation(self.$crownRotation)
                .onReceive(Just(crownRotation), perform: crownRotationDidChange)
            }

            VStack {
                BlurredBar(height: 10, blurRadius: 4, isTop: true)
                    .padding(EdgeInsets(top: 0, leading: -50, bottom: 0, trailing: -50))
                Spacer()
                BlurredBar(height: 10, blurRadius: 4, isTop: false)
                    .padding(EdgeInsets(top: 0, leading: -50, bottom: 0, trailing: -50))
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct BlurredBar: View {
    let height: CGFloat
    let blurRadius: CGFloat
    let isTop: Bool

    var body: some View {
        Color.black
            .padding(0)
            .frame(height: height)
            .offset(x: 0, y: height / 2 * (isTop ? -1 : 1))
            .blur(radius: blurRadius, opaque: false)
    }
}

#if DEBUG
    struct WorkoutPicker_Previews: PreviewProvider {
        static var previews: some View {
            ExercisePicker(workoutManager: WorkoutManager(), exerciseOptions: ExerciseOptions(), exerciseSelected: .constant(false))
        }
    }
#endif
