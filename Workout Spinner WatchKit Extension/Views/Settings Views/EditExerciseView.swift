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
                ForEach(0 ... pickerMax, id: \.self) { i in
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
    @ObservedObject var exerciseOptions: ExerciseOptions

    @State private var name: String = ""
    @State private var exerciseTypeIndex = 0
    @ObservedObject var bodyparts: BodyPartSelections
    @State private var active: Bool = true

    @State private var lightVal: Int = 5
    @State private var mediumVal: Int = 10
    @State private var hardVal: Int = 15
    @State private var gruelingVal: Int = 20
    @State private var killingVal: Int = 25

    @Environment(\.presentationMode) var presentationMode

    init(exerciseOptions: ExerciseOptions) {
        self.exerciseOptions = exerciseOptions
        exercise = nil
        bodyparts = BodyPartSelections(with: .none)
    }

    init(exerciseOptions: ExerciseOptions, exercise: ExerciseInfo) {
        self.exerciseOptions = exerciseOptions
        self.exercise = exercise
        bodyparts = BodyPartSelections(fromExerciseInfo: exercise)

        // Fill in form data with existing exercise information.
        _name = .init(initialValue: exercise.displayName)
        _exerciseTypeIndex = .init(initialValue: ExerciseType.allCases.firstIndex(where: { $0 == exercise.type }) ?? exerciseTypeIndex)

        _lightVal = .init(initialValue: convert(value: exercise.workoutValue[ExerciseIntensity.light.rawValue], orUse: lightVal))
        _mediumVal = .init(initialValue: convert(value: exercise.workoutValue[ExerciseIntensity.medium.rawValue], orUse: mediumVal))
        _hardVal = .init(initialValue: convert(value: exercise.workoutValue[ExerciseIntensity.hard.rawValue], orUse: hardVal))
        _gruelingVal = .init(initialValue: convert(value: exercise.workoutValue[ExerciseIntensity.grueling.rawValue], orUse: gruelingVal))
        _killingVal = .init(initialValue: convert(value: exercise.workoutValue[ExerciseIntensity.killing.rawValue], orUse: killingVal))

        _active = .init(initialValue: exercise.active)
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
        }
    }

    var body: some View {
        Form {
            Section(header: Text("Exercise name")) {
                TextField("Exercise name", text: $name)
            }

            Section {
                Toggle("Include exercise", isOn: $active)
            }

            Section(header: Text("Exercise type")) {
                Picker(selection: $exerciseTypeIndex, label: Text("Exercise type")) {
                    ForEach(0 ..< ExerciseType.allCases.count) { i in
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
                ForEach(0 ..< bodyparts.bodyparts.count) { i in
                    HStack {
                        Toggle(isOn: self.$bodyparts.bodyparts[i].enabled) {
                            Text(self.bodyparts.bodyparts[i].bodypart.rawValue.capitalized)
                        }
                    }
                }
            }

            ListViewTextButton(label: "Save", action: saveAndFinish)
                .buttonStyle(DoneButtonStyle(color: .workoutRed))
                .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        }
    }
}

extension EditExerciseView {
    func saveAndFinish() {
        let bp = bodyparts.bodyparts
            .filter { $0.enabled }
            .map { $0.bodypart }

        let workoutValue: [String: Float] = [
            ExerciseIntensity.light.rawValue: Float(lightVal),
            ExerciseIntensity.medium.rawValue: Float(mediumVal),
            ExerciseIntensity.hard.rawValue: Float(hardVal),
            ExerciseIntensity.grueling.rawValue: Float(gruelingVal),
            ExerciseIntensity.killing.rawValue: Float(killingVal),
        ]

        let newExercise = ExerciseInfo(id: exercise?.id ?? UUID().uuidString,
                                       displayName: name,
                                       type: ExerciseType.allCases[exerciseTypeIndex],
                                       bodyParts: bp,
                                       workoutValue: workoutValue,
                                       active: active)

        exerciseOptions.updateOrAppend(newExercise)

        presentationMode.wrappedValue.dismiss()
    }
}

struct EditExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        EditExerciseView(exerciseOptions: ExerciseOptions())
    }
}
