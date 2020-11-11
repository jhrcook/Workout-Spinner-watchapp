//
//  AddExerciseView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 11/9/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI


struct ExerciseAmountValuePicker: View {
    
    let leadingText: String
    let labelText: String
    @Binding var selection: Int
    let pickerMax: Int = 1000
    
    var body: some View {
        HStack {
            Text(leadingText)
                .frame(maxWidth: .infinity)
            Picker(selection: $selection, label: Text(labelText)) {
                ForEach(0...pickerMax, id: \.self) { i in
                    Text("\(i)")
                }
            }
            .labelsHidden()
            .pickerStyle(WheelPickerStyle())
            .frame(idealWidth: 25, maxWidth: 75)
        }
    }
}


struct EditExerciseView: View {
    
    var exercise: ExerciseInfo?
    
    @State private var name: String = "Exercise name"
    @State private var exerciseTypeIndex = 0
    @State private var bodyParts = [ExerciseBodyPart]()
    @State private var lightVal: Int = 5
    @State private var mediumVal: Int = 10
    @State private var hardVal: Int = 15
    @State private var gruelingVal: Int = 20
    @State private var killingVal: Int = 25
    
    @Environment(\.presentationMode) var presentationMode
    
    init() {
        self.exercise = nil
    }
    
    init(exercise: ExerciseInfo) {
        self.exercise = exercise
        
        self.name = exercise.displayName
        self.exerciseTypeIndex = ExerciseType.allCases.firstIndex(where: { $0 == exercise.type }) ?? self.exerciseTypeIndex
        self.bodyParts = exercise.bodyParts
        self.lightVal = convert(value: exercise.workoutValue[ExerciseIntensity.light.rawValue], orUse: self.lightVal)
        self.mediumVal = convert(value: exercise.workoutValue[ExerciseIntensity.medium.rawValue], orUse: self.mediumVal)
        self.hardVal = convert(value: exercise.workoutValue[ExerciseIntensity.hard.rawValue], orUse: self.hardVal)
        self.gruelingVal = convert(value: exercise.workoutValue[ExerciseIntensity.grueling.rawValue], orUse: self.gruelingVal)
        self.killingVal = convert(value: exercise.workoutValue[ExerciseIntensity.killing.rawValue], orUse: self.killingVal)
    }
    
    func convert(value: Float?, orUse defaultValue: Int) -> Int {
        if value == nil {
            return defaultValue
        } else {
            return Int(value!)
        }
    }
    
    
    var exerciseCountsHeader: String {
        switch ExerciseType.allCases[exerciseTypeIndex] {
        case .count:
            return "repetitions"
        case .time:
            return "duration"
        default:
            return "repetitions"
        }
    }
    
    
    var body: some View {
        Form {
            Section {
                TextField("Exercise name", text: $name)
            }
            
            Section(header: Text("Exercise type")) {
                Picker(selection: $exerciseTypeIndex, label: Text("Exercise type")) {
                    ForEach(0..<ExerciseType.allCases.count) { i in
                        Text(ExerciseType.allCases[i].rawValue)
                    }
                }
                .labelsHidden()
                .pickerStyle(WheelPickerStyle())
            }
            
            Section(header: Text("Exercise \(exerciseCountsHeader)")) {
                ExerciseAmountValuePicker(leadingText: "light", labelText: "light exercise amount", selection: $lightVal)
                ExerciseAmountValuePicker(leadingText: "medium", labelText: "medium exercise amount", selection: $mediumVal)
                ExerciseAmountValuePicker(leadingText: "hard", labelText: "hard exercise amount", selection: $hardVal)
                ExerciseAmountValuePicker(leadingText: "greuling", labelText: "greuling exercise amount", selection: $gruelingVal)
                ExerciseAmountValuePicker(leadingText: "killing", labelText: "killing exercise amount", selection: $killingVal)
            }
            
            Section(header: Text("Body parts involved")) {
                Text("hi")
            }
            
            Button(action: saveAndFinish) {
                Text("Save")
            }
        }
    }
}


extension EditExerciseView {
    
    func saveAndFinish() {
        
        //        let newExercise = ExerciseInfo(id: exercise?.id ?? UUID().uuidString, displayName: name, type: ExerciseType.allCases[exerciseTypeIndex], bodyParts: bodyParts, workoutValue: [ExerciseIntensity.light.rawValue : lightVal])
        //        var exerciseOptions = ExerciseOptions()
        //        exerciseOptions.updateOrAppend(newExercise)
        
        //        presentationMode.wrappedValue.dismiss()
    }
}


struct EditExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        EditExerciseView()
    }
}
