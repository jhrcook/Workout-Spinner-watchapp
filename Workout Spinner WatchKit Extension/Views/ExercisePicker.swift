//
//  WorkoutPicker.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/1/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI
import Combine

struct ExercisePicker: View {
    
    @ObservedObject var workoutManager: WorkoutManager
    @State var exerciseOptions: ExerciseOptions = ExercisePicker.loadWorkouts()
    @State internal var crownRotation = 0.0
    
    var numExercises: Int {
        return exerciseOptions.workouts.count
    }
    
    var crownVelocity = CrownVelocityCalculator(velocityThreshold: 50, memory: 20)
    
    @Binding internal var exerciseSelected: Bool
    @State internal var selectedExerciseIndex: Int = 0
    
    var spinDirection: Double {
        return WKInterfaceDevice().crownOrientation == .left ? 1.0 : -1.0
    }
    
    init(workoutManager: WorkoutManager, exerciseSelected: Binding<Bool>) {
        self.workoutManager = workoutManager
        self._exerciseSelected = exerciseSelected
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            GeometryReader { geo in
                ZStack {
                    ZStack {
                        ForEach(0..<self.numExercises) { i in
                            SpinnerSlice(idx: i,
                                         numberOfSlices: self.numExercises,
                                         width: geo.minSize * 2.0)
                        }
                        ForEach(0..<self.numExercises) { i in
                            WorkoutSlice(workoutInfo: self.exerciseOptions.workouts[i],
                                         idx: i,
                                         numberOfWorkouts: self.numExercises,
                                         size: geo.minSize * 2.0)
                        }
                    }
                    .modifier(SpinnerRotationModifier(rotation: .degrees(self.spinDirection * self.crownRotation),
                                                      onFinishedRotationAnimation: self.rotationEffectDidFinish))
                    .animation(.default)
                    
                    
                    HStack {
                        SpinnerPointer().frame(width: 20, height: 15)
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
    }
}



struct WorkoutPicker_Previews: PreviewProvider {
    static var previews: some View {
        ExercisePicker(workoutManager: WorkoutManager(), exerciseSelected: .constant(false))
    }
}
