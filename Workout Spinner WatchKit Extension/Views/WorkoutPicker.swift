//
//  WorkoutPicker.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/1/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI
import Combine

struct WorkoutPicker: View {
    
    @ObservedObject var workoutManager: WorkoutManager
    @State var workoutOptions: WorkoutOptions = WorkoutPicker.loadWorkouts()
    @State internal var crownRotation = 0.0
    
    var numWorkouts: Int {
        return workoutOptions.workouts.count
    }
    
    var crownVelocity = CrownVelocityCalculator(velocityThreshold: 50, memory: 20)
    
    @Binding internal var workoutSelected: Bool
    @State internal var selectedWorkoutIndex: Int = 0
    
    var spinDirection: Double {
        return WKInterfaceDevice().crownOrientation == .left ? 1.0 : -1.0
    }
    
    init(workoutManager: WorkoutManager, workoutSelected: Binding<Bool>) {
        self.workoutManager = workoutManager
        self._workoutSelected = workoutSelected
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            GeometryReader { geo in
                ZStack {
                    ZStack {
                        ForEach(0..<self.numWorkouts) { i in
                            SpinnerSlice(idx: i,
                                         numberOfSlices: self.numWorkouts,
                                         width: geo.minSize)
                        }
                        ForEach(0..<self.numWorkouts) { i in
                            WorkoutSlice(workoutInfo: self.workoutOptions.workouts[i],
                                         idx: i,
                                         numberOfWorkouts: self.numWorkouts,
                                         size: geo.minSize)
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
        WorkoutPicker(workoutManager: WorkoutManager(), workoutSelected: .constant(false))
    }
}
