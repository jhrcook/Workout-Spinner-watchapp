//
//  WelcomeView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 10/24/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    
    var workoutManager: WorkoutManager
    
    @State private var startWorkout = false
    @State private var presentSettingsView = false
    
    var body: some View {
        VStack {
            
            NavigationLink(destination: WorkoutPagingView(workoutManager: workoutManager)) {
                Text("Start Workout")
                    .font(.title)
                    .foregroundColor(.orange)
                    .bold()
                    .multilineTextAlignment(.center)
            }
            Text("Press and hold the spinner to finish the workout.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
            
            Spacer(minLength: 0)
            
            Button(action: {
                presentSettingsView = true
            }) {
                HStack {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .sheet(isPresented: self.$presentSettingsView) {
            Settings()
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(workoutManager: WorkoutManager())
    }
}
