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
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Button(action: {
                
            }) {
                Text("Start Workout")
                    .font(.title)
                    .foregroundColor(.blue)
                    .bold()
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            Button(action: {
                
            }) {
                HStack {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
            }
            .buttonStyle(PlainButtonStyle())
            .padding()
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(workoutManager: WorkoutManager())
    }
}
