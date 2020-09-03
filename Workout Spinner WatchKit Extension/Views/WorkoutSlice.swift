//
//  WorkoutSlice.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/3/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct WorkoutSlice: View {
    
    let workout: Workout
    let idx: Int
    let numberOfWorkouts: Int
    let size: CGFloat
    
    let offset: CGFloat = 8.0
    var halfOffset: CGFloat {
        (offset / 2.0) - 2.0
    }
    
    var rotationAngle: Angle {
        .degrees(Double(idx - 1) * 360.0 / Double(numberOfWorkouts))
    }
    
    var body: some View {
        Text(workout.displayName)
            .font(.system(.footnote))
            .foregroundColor(.black)
            .lineLimit(1)
            .frame(width: size / 2 - offset, height: nil, alignment: .trailing)
            .padding(2)
            .offset(x: size / 4 + halfOffset, y: 0)
            .rotationEffect(rotationAngle)
    }
}


struct WorkoutSlice_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white
            
            VStack {
                ForEach(3..<8) { i in
                    WorkoutSlice(workout: Workouts().workouts[0], idx: 1, numberOfWorkouts: i, size: 200)
                        .padding()
                }
            }
        }
        .previewLayout(.sizeThatFits)
    }
}
