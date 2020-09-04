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
    @State private var rotationAmount = 0.0
    
    var numWorkouts: Int {
        return workouts.workouts.count
    }
    
    var crownVelocity = CrownVelocityCalculator()
    
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
                    .rotationEffect(.degrees(self.rotationAmount))
                    
                    
                    HStack {
                        SpinnerPointer().frame(width: 20, height: 15)
                        Spacer()
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .padding(0)
            .focusable()
            .digitalCrownRotation(self.$rotationAmount)
            .onReceive(Just(rotationAmount), perform: calculateCrownRotationVelocity)
        }
    }
}


class CrownVelocityCalculator {
    private var history = [Double]()
    var currentVelocity: Double = 0.0
    
    var velocityThreshold: Double = 500.0
    private(set) var didPassThreshold: Bool = false
    
    var memory: Int = 10
    
    init() {}
    
    init(memory: Int) {
        self.memory = memory
    }
    
    init(velocityThreshold: Double) {
        self.velocityThreshold = velocityThreshold
    }
    
    init(velocityThreshold: Double, memory: Int) {
        self.velocityThreshold = velocityThreshold
        self.memory = memory
    }
    
    func update(newValue x: Double) {
        self.history.append(x)
        if history.count < memory { return }
        
        if history.count > memory {
            history = history.suffix(memory)
        }
        
        var diffs: Double = 0.0
        for i in 0..<(history.count - 1) {
            diffs += history[i+1] - history[i]
        }
        
        currentVelocity = diffs / Double(history.count - 1)
        checkThreshold()
    }
    
    func checkThreshold() {
        if !didPassThreshold {
            didPassThreshold = abs(currentVelocity) > velocityThreshold
        }
    }
    
    func resetThreshold() {
        didPassThreshold = false
    }
    
}


extension WorkoutPicker {
    func calculateCrownRotationVelocity(crownValue: Double) {
        crownVelocity.update(newValue: crownValue)
    }
}



struct WorkoutPicker_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutPicker()
    }
}
