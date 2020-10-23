//
//  WorkoutStartView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/7/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct WorkoutStartView: View {
    
    @ObservedObject var workoutManager: WorkoutManager
    let intensity: ExerciseIntensity = WorkoutStartView.loadExerciseIntensity()
    
    var workoutInfo: WorkoutInfo?
    
    init(workoutManager: WorkoutManager) {
        self.workoutManager = workoutManager
        workoutInfo = workoutManager.workoutInfo
    }
    
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
    
    @State private var timeRemaining = 3
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var startWorkout = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            VStack {
                
                Text(workoutInfo?.displayName ?? "(no workout selected)")
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
            .background(
                NavigationLink(destination: WorkoutView(workoutManager: workoutManager),
                               isActive: $startWorkout) {
                    EmptyView()
                }.hidden()
            )
            .onReceive(timer) { time in
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else if self.timeRemaining <= 0 {
                    self.startWorkout = true
                }
                
            }
            .navigationBarBackButtonHidden(true)
            .edgesIgnoringSafeArea(.bottom)
            .onTapGesture(count: 2) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        .onAppear {
            self.timeRemaining = 3
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
    
    static var workouts: WorkoutOptions {
        var ws = WorkoutOptions()
        let i = ws.workouts.first { $0.type == .count }!
        let j = ws.workouts.first { $0.type == .time }!
        ws.workouts = [i, j]
        return ws
    }
    
    static var previews: some View {
        Group {
            ForEach(workouts.workouts) { info in
                WorkoutStartView(workoutManager: WorkoutManager(workoutInfo: info))
                    .previewDisplayName(info.displayName)
            }
        }
    }
}
