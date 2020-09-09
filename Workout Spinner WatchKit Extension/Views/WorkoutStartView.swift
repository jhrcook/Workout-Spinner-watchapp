//
//  WorkoutStartView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/7/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct WorkoutStartView: View {
    
    let workout: Workout
    
    let intensity: ExerciseIntensity = WorkoutStartView.loadExerciseIntensity()
    
    var displayDuration: String {
        if let workoutValue = workout.workoutValue[intensity.rawValue] {
            if workout.type == .count {
                return "\(Int(workoutValue))"
            } else {
                return "\(Int(workoutValue)) s"
            }
        }
        print(workout.workoutValue)
        print(workout.type)
        return intensity.rawValue
    }
    
    var body: some View {
        VStack {
            Text(workout.displayName)
                .lineLimit(1)
                .font(.system(size: 25, weight: .regular, design: .rounded))
            
            Spacer()
            
            Text(displayDuration)
                .font(.system(size: 40, weight: .semibold , design: .rounded))
                .foregroundColor(.yellow)
            
            Spacer()
            
            HStack {
                Button(action: {
                    print("tap: 'X'")
                }) {
                    Image(systemName: "plus")
                        .rotationEffect(.degrees(45))
                        .font(.system(size: 30, weight: .semibold, design: .default))
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    print("tap: 'Go'")
                }) {
                    Image(systemName: "play")
                        .font(.system(size: 25, weight: .bold, design: .default))
                        .foregroundColor(.green)
                }
            }
        }
    }
}



extension WorkoutStartView {
    static func loadExerciseIntensity() -> ExerciseIntensity {
        if let intensityString = UserDefaults.standard.string(forKey: UserDefaultsKeys.exerciseIntensity.rawValue) {
            if let intensity = ExerciseIntensity(rawValue: intensityString) {
                return intensity
            }
        }
        print("Unable to load preferred exercise intensity.")
        return ExerciseIntensity.medium
    }
}



struct WorkoutStartView_Previews: PreviewProvider {
    
    static var workouts: Workouts {
        var ws = Workouts()
        let i = ws.workouts.first { $0.type == .count }!
        let j = ws.workouts.first { $0.type == .time }!
        ws.workouts = [i, j]
        return ws
    }
    
    static var previews: some View {
        Group {
            ForEach(workouts.workouts) { workout in
                WorkoutStartView(workout: workout)
                    .previewDisplayName(workout.displayName)
            }
        }
    }
}
