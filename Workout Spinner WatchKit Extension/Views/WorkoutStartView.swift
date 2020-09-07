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
    
    var body: some View {
        VStack {
            Text(workout.displayName).lineLimit(1).font(.title)
            Spacer()
        }
    }
}

struct WorkoutStartView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutStartView(workout: Workouts().workouts[0])
    }
}
