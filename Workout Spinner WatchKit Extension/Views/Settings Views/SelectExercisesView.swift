//
//  SelectExercisesView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 11/12/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct SelectExercisesView: View {
    @ObservedObject var exerciseOptions: ExerciseOptions

    var body: some View {
        List {
            ForEach(exerciseOptions.allExercises) { exercise in
                NavigationLink(destination: EditExerciseView(exerciseOptions: exerciseOptions, exercise: exercise)) {
                    LabelWithIndicator(text: exercise.displayName)
                }
            }
        }
    }
}

struct SelectExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        SelectExercisesView(exerciseOptions: ExerciseOptions())
    }
}
