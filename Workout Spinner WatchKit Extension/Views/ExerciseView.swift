//
//  WorkoutView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/10/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct ExerciseView: View {
    
    @ObservedObject var workoutManager: WorkoutManager
    @ObservedObject var workoutTracker: WorkoutTracker
    @Binding private var exerciseComplete: Bool
    var workoutInfo: ExerciseInfo?
    
    let intensity: ExerciseIntensity = ExerciseStartView.loadExerciseIntensity()
    
    init(workoutManager: WorkoutManager, workoutTracker: WorkoutTracker, exerciseComplete: Binding<Bool>) {
        self.workoutManager = workoutManager
        self.workoutTracker = workoutTracker
        self._exerciseComplete = exerciseComplete
        workoutInfo = workoutManager.exerciseInfo
    }
    
    let infoFontSize: CGFloat = 18
    
    /// The duration as "MM:SS".
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
    
    /// The heart rate information to display.
    var displayHeartRate: String {
        workoutManager.allHeartRateReadings.count == 0 ? "--" : "\(Int(workoutManager.heartrate))"
    }
    
    var body: some View {
        VStack {
            Text(workoutInfo?.displayName ?? "(no workout)")
                .font(.system(size: 25, weight: .semibold, design: .rounded))
                .padding(.bottom, 2)
            Text(displayDuration).font(.system(size: 20, weight: .regular, design: .rounded))
                .padding(.bottom, 5)
            
            HStack {
                Spacer()
                HStack {
                    Image(systemName: "heart").foregroundColor(.red).font(.system(size: infoFontSize))
                    Text(displayHeartRate).font(.system(size: infoFontSize))
                }
                
                Spacer()
                
                HStack {
                    Image(systemName: "flame").foregroundColor(.yellow).font(.system(size: infoFontSize))
                    Text("\(Int(workoutManager.activeCalories))").font(.system(size: infoFontSize))
                }
                
                Spacer()
            }
            .padding(.bottom, 5)
            
            HStack {
                Image(systemName: "stopwatch").foregroundColor(.blue).font(.system(size: infoFontSize))
                Text("\(convertNumberSecondsToTimeFormat(Double(workoutManager.elapsedSeconds)))").font(.system(size: infoFontSize))
            }
            
            
            
            Spacer()
            
            Button(action: finishExercise, label: {
                Text("Done").foregroundColor(.green).bold()
            })
        }
    }
    
    func convertNumberSecondsToTimeFormat(_ seconds: Double) -> String {
        let minutes = (seconds / 60.0).rounded(.down)
        let remainderSeconds = seconds.truncatingRemainder(dividingBy: 60.0).rounded()
        
        func doubleToPaddedString(_ x: Double, paddingLength: Int = 2) -> String {
            var s = "\(Int(x))"
            if s.count < paddingLength {
                s = "0" + s
            }
            return s
        }
        
        return "\(doubleToPaddedString(minutes)):\(doubleToPaddedString(remainderSeconds))"
    }
}


extension ExerciseView {
    /// Called when the exercise is complete and the 'Done" button is tapped.
    internal func finishExercise() {
        // Add data from exercise to the workout tracker and clear the info from the workout manager.
        workoutTracker.addData(info: workoutManager.exerciseInfo!, duration: Double(workoutManager.elapsedSeconds), activeCalories: workoutManager.activeCalories, heartRate: workoutManager.allHeartRateReadings)
        workoutManager.resetTrackedInformation()
        
        exerciseComplete = true
    }
}







struct WorkoutView_Previews: PreviewProvider {
    
    static var workoutOptions: ExerciseOptions {
        var ws = ExerciseOptions()
        let i = ws.exercises.first { $0.type == .count }!
        let j = ws.exercises.first { $0.type == .time }!
        ws.allExercises = [i, j]
        return ws
    }
    
    static var previews: some View {
        Group {
            ForEach(workoutOptions.exercises) { info in
                ExerciseView(workoutManager: WorkoutManager(exerciseInfo: info), workoutTracker: WorkoutTracker(), exerciseComplete: .constant(false))
                    .previewDisplayName(info.displayName)
            }
        }
    }
}
