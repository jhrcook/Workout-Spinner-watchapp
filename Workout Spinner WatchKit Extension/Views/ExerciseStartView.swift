//
//  WorkoutStartView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/7/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct ExerciseStartView: View {
    
    @ObservedObject var workoutManager: WorkoutManager
    @Binding private var exerciseCanceled: Bool
    
    // Workout information
    let intensity: ExerciseIntensity = ExerciseStartView.loadExerciseIntensity()
    var exerciseInfo: ExerciseInfo?
    
    // Timer
    @State private var timeRemaining = 3
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var displayDuration: String {
        guard let info = workoutManager.exerciseInfo else { return "" }
        if let workoutValue = info.workoutValue[intensity.rawValue] {
            if info.type == .count {
                return "\(Int(workoutValue))"
            } else {
                return "\(Int(workoutValue)) s"
            }
        }
        return intensity.rawValue
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    init(workoutManager: WorkoutManager, exerciseCanceled: Binding<Bool>) {
        self.workoutManager = workoutManager
        self._exerciseCanceled = exerciseCanceled
        exerciseInfo = workoutManager.exerciseInfo
    }
    
    var body: some View {
        VStack {
            
            Text(exerciseInfo?.displayName ?? "(no workout selected)")
                .lineLimit(1)
                .font(.system(size: 25, weight: .regular, design: .rounded))
            
            Spacer()
            
            Text(displayDuration)
                .font(.system(size: 40, weight: .semibold , design: .rounded))
                .foregroundColor(.yellow)
            
            Spacer()
            
            
            HStack {
                Text("Starting in")
                Text("\(timeRemaining)")
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                    .foregroundColor(.green)
            }
            .frame(minWidth: 120, idealWidth: nil, maxWidth: nil,
                   minHeight: 30, idealHeight: nil, maxHeight: nil,
                   alignment: .center)
            .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
            .background(Color.gray.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            
            Spacer()
            
            Text("Double tap to cancel").foregroundColor(.gray).font(.footnote)
            
        }
        .onReceive(timer) { time in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else if self.timeRemaining <= 0 {
                exerciseCanceled = false
                self.presentationMode.wrappedValue.dismiss()
            }
            
        }
        .edgesIgnoringSafeArea(.bottom)
        .onTapGesture(count: 2) {
            exerciseCanceled = true
            self.presentationMode.wrappedValue.dismiss()
        }
        .onAppear {
            self.timeRemaining = 3
        }
        .navigationBarBackButtonHidden(true)
    }
}


extension ExerciseStartView {
    static func loadExerciseIntensity() -> ExerciseIntensity {
        if let intensityString = UserDefaults.standard.string(forKey: UserDefaultsKeys.exerciseIntensity.rawValue) {
            if let intensity = ExerciseIntensity(rawValue: intensityString) {
                return intensity
            }
        }
        return ExerciseIntensity.medium
    }
}



struct WorkoutStartView_Previews: PreviewProvider {
    
    static var workouts: ExerciseOptions {
        var ws = ExerciseOptions()
        let i = ws.exercises.first { $0.type == .count }!
        let j = ws.exercises.first { $0.type == .time }!
        ws.allExercises = [i, j]
        return ws
    }
    
    static var previews: some View {
        Group {
            ForEach(workouts.exercises) { info in
                ExerciseStartView(workoutManager: WorkoutManager(exerciseInfo: info), exerciseCanceled: .constant(false))
                    .previewDisplayName(info.displayName)
            }
        }
    }
}
