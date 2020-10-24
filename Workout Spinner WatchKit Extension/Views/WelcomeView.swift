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
    
    @State private var presentSettingsView = false
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Button(action: {
                
            }) {
                Text("Start Workout")
                    .font(.title)
                    .foregroundColor(.orange)
                    .bold()
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            Button(action: {
                presentSettingsView = true
            }) {
                HStack {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
            }
            .buttonStyle(PlainButtonStyle())
            .padding()
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
