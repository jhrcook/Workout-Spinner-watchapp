//
//  WorkoutView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/10/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct WorkoutView: View {
    
    @ObservedObject var workoutManager: WorkoutManager
    var workoutInfo: WorkoutInfo
    
    let intensity: ExerciseIntensity = WorkoutStartView.loadExerciseIntensity()
    
    @State private var exerciseComplete = false
    
    var displayDuration: String {
        guard let info = workoutManager.workoutInfo else { return "" }
        if let workoutValue = info.workoutValue[intensity.rawValue] {
            if info.type == .count {
                return "\(Int(workoutValue))"
            } else {
                return "\(Int(workoutValue)) s"
            }
        }
        return intensity.rawValue
    }
    
    init(workoutManager: WorkoutManager) {
        self.workoutManager = workoutManager
        self.workoutInfo = workoutManager.workoutInfo!
    }
    
    var body: some View {
        VStack {
            Text(workoutManager.workoutInfo?.displayName ?? "(no workout)")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .padding(.bottom, 5)
            Text(displayDuration).font(.system(size: 14, weight: .regular, design: .rounded))
                .padding(.bottom, 5)
            
            HStack {
                Image(systemName: "heart").foregroundColor(.red).font(.system(size: 14))
                Text("\(Int(workoutManager.heartrate))").font(.system(size: 14))
            }
            
            HStack {
                Image(systemName: "stopwatch").foregroundColor(.blue).font(.system(size: 14))
                Text("\(convertNumberSecondsToTimeFormat(Double(workoutManager.elapsedSeconds)))").font(.system(size: 14))
            }
            
            HStack {
                Image(systemName: "flame").foregroundColor(.yellow).font(.system(size: 14))
                Text("\(Int(workoutManager.activeCalories))").font(.system(size: 14))
            }
            
            Spacer()
            
            Button(action: {
                exerciseComplete = true
            }, label: {
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







struct WorkoutView_Previews: PreviewProvider {
    
    static var workoutOptions: WorkoutOptions {
        var ws = WorkoutOptions()
        let i = ws.workouts.first { $0.type == .count }!
        let j = ws.workouts.first { $0.type == .time }!
        ws.workouts = [i, j]
        return ws
    }
    
    static var previews: some View {
        Group {
            ForEach(workoutOptions.workouts) { info in
                WorkoutView(workoutManager: WorkoutManager(workoutInfo: info))
                    .previewDisplayName(info.displayName)
            }
        }
    }
}
