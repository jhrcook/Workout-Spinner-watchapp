//
//  AddExerciseView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 11/9/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct EditExerciseView: View {
    
    var exercise: ExerciseInfo?
    
    @State private var name: String = "Exercise name"
    @State private var exerciseTypeIndex = 0
    @State private var bodyParts = [ExerciseBodyPart]()
    @State private var lightVal: Float = 5
    @State private var mediumVal: Float = 10
    @State private var hardVal: Float = 15
    @State private var gruelingVal: Float = 20
    @State private var killingVal: Float = 25
    
    @Environment(\.presentationMode) var presentationMode
    
    init() {
        self.exercise = nil
    }
    
    init(exercise: ExerciseInfo) {
        self.exercise = exercise
        
        self.name = exercise.displayName
        self.exerciseTypeIndex = ExerciseType.allCases.firstIndex(where: { $0 == exercise.type }) ?? self.exerciseTypeIndex
        self.bodyParts = exercise.bodyParts
        self.lightVal = exercise.workoutValue[ExerciseIntensity.light.rawValue] ?? self.lightVal
        self.mediumVal = exercise.workoutValue[ExerciseIntensity.medium.rawValue] ?? self.mediumVal
        self.hardVal = exercise.workoutValue[ExerciseIntensity.hard.rawValue] ?? self.hardVal
        self.gruelingVal = exercise.workoutValue[ExerciseIntensity.grueling.rawValue] ?? self.gruelingVal
        self.killingVal = exercise.workoutValue[ExerciseIntensity.killing.rawValue] ?? self.killingVal
    }
    
    
    var body: some View {
        Form {
            Section {
                TextField("Exercise name", text: $name)
            }
            Button(action: saveAndFinish) {
                Text("Save")
            }
        }
    }
}


extension EditExerciseView {
    
    func saveAndFinish() {
        
        let newExercise = ExerciseInfo(id: exercise?.id ?? UUID().uuidString, displayName: name, type: ExerciseType.allCases[exerciseTypeIndex], bodyParts: bodyParts, workoutValue: [ExerciseIntensity.light.rawValue : lightVal])
        var exerciseOptions = ExerciseOptions()
        exerciseOptions.updateOrAppend(newExercise)
        
        presentationMode.wrappedValue.dismiss()
    }
}


struct EditExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        EditExerciseView()
    }
}
