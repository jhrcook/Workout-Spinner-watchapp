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
    @State internal var crownRotation = 0.0
        
    var numWorkouts: Int {
        return workouts.workouts.count
    }
    
    var crownVelocity = CrownVelocityCalculator(velocityThreshold: 50, memory: 20)
    
    @State internal var workoutSelected = false
    @State internal var selectedWorkoutIndex: Int = 0
    
    @State private var showSettings = false
    
    var spinDirection: Double {
        return WKInterfaceDevice().crownOrientation == .left ? 1.0 : -1.0
    }
    
    var body: some View {
        VStack {
            Spacer(minLength: 0)
            GeometryReader { geo in
                ZStack {
                    NavigationLink(destination: WorkoutStartView(workout: self.workouts.workouts[self.selectedWorkoutIndex]),
                                   isActive: self.$workoutSelected,
                        label: { EmptyView() }).hidden()
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
        .sheet(isPresented: self.$showSettings) {
            Settings()
        }
        .contextMenu(menuItems: {
            Button(action: {
                self.showSettings.toggle()
            }, label: {
                VStack {
                    Image(systemName: "gear").font(.title)
                    Text("Settings")
                }
            })
        })
    }
}



struct WorkoutPicker_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutPicker()
    }
}
