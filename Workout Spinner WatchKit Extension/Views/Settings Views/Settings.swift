//
//  Settings.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/7/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct Settings: View {
    @ObservedObject var exerciseOptions: ExerciseOptions
    @State private var selectedExerciseIntensity = Settings.getSavedExerciseIntensity()

    private var exerciseIntensities: [String] {
        var a = [String]()
        for ei in ExerciseIntensity.allCases {
            a.append(ei.rawValue)
        }
        return a
    }

    @State private var confirmResetExerciseOptions = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: SectionHeader(imageName: "figure.wave", text: "Preferences")) {
                Picker(selection: $selectedExerciseIntensity, label: Text("Intensity")) {
                    ForEach(0 ..< exerciseIntensities.count) { idx in
                        Text(self.exerciseIntensities[idx])
                    }
                }
                .pickerStyle(WheelPickerStyle())

                NavigationLink(destination: BodyPartSelectionListView()) {
                    LabelWithIndicator(text: "Muscle groups")
                }
            }

            Section(header: SectionHeader(imageName: "flame", text: "Exercises")) {
                NavigationLink(destination: SelectExercisesView(exerciseOptions: exerciseOptions)) {
                    LabelWithIndicator(text: "Edit exercises")
                }
                NavigationLink(destination: EditExerciseView(exerciseOptions: exerciseOptions)) {
                    LabelWithIndicator(text: "New exercise")
                }
                Button(action: {
                    confirmResetExerciseOptions.toggle()
                }) {
                    HStack {
                        Spacer(minLength: 0)
                        Text("Reset Exercises").foregroundColor(.red)
                        Spacer(minLength: 0)
                    }
                }
            }

            Section(header: SectionHeader(imageName: "info.circle", text: "About")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("0.0.0.9000")
                }
            }
        }
        .alert(isPresented: $confirmResetExerciseOptions) {
            Alert(
                title: Text("Reset exercises?"),
                message: Text("Are you sure you want to reset the list of exercises?"),
                primaryButton: .destructive(Text("Reset"), action: {
                    self.exerciseOptions.resetExerciseOptions()
                }),
                secondaryButton: .cancel()
            )
        }
        .onDisappear {
            self.saveUserDefualts()
        }
        .onReceive(NotificationCenter.default.publisher(for: .NSExtensionHostWillResignActive)) { _ in
            self.saveUserDefualts()
        }
    }
}

extension Settings {
    func saveUserDefualts() {
        let intensity = ExerciseIntensity.allCases[selectedExerciseIntensity]
        UserDefaults.standard.set(intensity.rawValue,
                                  forKey: UserDefaultsKeys.exerciseIntensity.rawValue)
    }

    static func getSavedExerciseIntensity() -> Int {
        let exerciseIntensity = UserDefaults.standard.string(forKey: UserDefaultsKeys.exerciseIntensity.rawValue)
        for (idx, intensity) in ExerciseIntensity.allCases.enumerated() {
            if intensity.rawValue == exerciseIntensity {
                return idx
            }
        }
        return 0
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings(exerciseOptions: ExerciseOptions())
    }
}
