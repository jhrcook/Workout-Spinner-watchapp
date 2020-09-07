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
    
    let workouts = Workouts()
    @State private var crownRotation = 0.0
        
    var numWorkouts: Int {
        return workouts.workouts.count
    }
    
    var crownVelocity = CrownVelocityCalculator(velocityThreshold: 200, memory: 20)
    
    @State private var workoutSelected = false
    @State private var selectedWorkoutIndex: Int = 0
    
    var body: some View {
        VStack {
            Spacer(minLength: 0)
            GeometryReader { geo in
                ZStack {
                    Color.white
                        .opacity(self.crownVelocity.didPassThreshold ? 1.0 : min(1.0, abs(self.crownVelocity.currentVelocity / self.crownVelocity.velocityThreshold)))
                        .animation(.easeInOut)
                        .clipShape(Circle())
                        .frame(width: geo.minSize + 10, height: geo.minSize + 10)
                        .blur(radius: 10)
                    
                    ZStack {
                        ForEach(0..<self.numWorkouts) { i in
                            SpinnerSlice(idx: i,
                                         numberOfSlices: self.numWorkouts,
                                         width: geo.minSize)
                        }
                        ForEach(0..<self.numWorkouts) { i in
                            WorkoutSlice(workout: self.workouts.workouts[i],
                                         idx: i,
                                         numberOfWorkouts: self.numWorkouts,
                                         size: geo.minSize)
                        }
                    }
                    .modifier(SpinnerRotationModifier(rotation: .degrees(-1.0 * self.crownRotation),
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
        .sheet(isPresented: self.$workoutSelected) {
            WorkoutStartView(workout: self.workouts.workouts[self.selectedWorkoutIndex])
        }
    }
}


extension WorkoutPicker {
    func crownRotationDidChange(crownValue: Double) {
        crownVelocity.update(newValue: crownValue)
        readSelectedWorkout()
    }
    
    func rotationEffectDidFinish() {
        if crownVelocity.didPassThreshold {
            workoutSelected.toggle()
            crownVelocity.resetThreshold()
        }
    }
    
    func readSelectedWorkout() {
        let pointerAngle = 180.0
        let sliceAngle = 360.0 / Double(numWorkouts)
        let pointingAtAngle = (0.5 * sliceAngle) + pointerAngle + crownRotation.truncatingRemainder(dividingBy: 360.0)
        var pointingSlice = (pointingAtAngle / sliceAngle).rounded(.down)
        
        if pointingSlice < 0 {
            pointingSlice = Double(numWorkouts) + pointingSlice
        }
        
        self.selectedWorkoutIndex = Int(pointingSlice)
    }
}



struct WorkoutPicker_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutPicker()
    }
}
