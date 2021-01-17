//
//  Settings.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/7/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import os
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

    @State private var crownVelocityMultiplier = UserDefaults.readCrownVelocityMultiplier()

    private var crownVelocityMultiplierValues: [Double] = {
        var a: [Double] = []
        for x in 1 ... 10 {
            a.append(Double(x) * 0.5)
        }
        return a
    }()

    @Environment(\.presentationMode) var presentationMode
    let logger = Logger.settingsLogger

    init(exerciseOptions: ExerciseOptions) {
        self.exerciseOptions = exerciseOptions
    }

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
                    logger.info("User tapped 'Reset Exercises' button.")
                    confirmResetExerciseOptions.toggle()
                }) {
                    HStack {
                        Spacer(minLength: 0)
                        Text("Reset Exercises").foregroundColor(.red)
                        Spacer(minLength: 0)
                    }
                }
            }

            Section(header: SpinningImageSectionHeader(imageName: "hexagon", text: "Spinning Wheel")) {
                Picker(selection: $crownVelocityMultiplier, label: Text("Spin speed"), content: {
                    ForEach(crownVelocityMultiplierValues, id: \.self) { x in
                        Text("\(x, specifier: "%.1f")")
                    }
                })
                    .pickerStyle(WheelPickerStyle())
            }

            Section(header: SectionHeader(imageName: "info.circle", text: "About")) {
                HStack {
                    Text("Dev")
                    Spacer()
                    Text("Josh Cook")
                }
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.2.2")
                }
            }
        }
        .alert(isPresented: $confirmResetExerciseOptions) {
            Alert(
                title: Text("Reset exercises?"),
                message: Text("Are you sure you want to reset the list of exercises?"),
                primaryButton: .destructive(Text("Reset"), action: {
                    self.logger.info("User confirmed to reset exercises.")
                    self.exerciseOptions.resetExerciseOptions()
                }),
                secondaryButton: .cancel()
            )
        }
        .onAppear {
            logger.debug("Settings will appear.")
            selectedExerciseIntensity = Settings.getSavedExerciseIntensity()
        }
        .onDisappear {
            logger.debug("Setting will disappear.")
            self.saveUserDefualts()
        }
        .onReceive(NotificationCenter.default.publisher(for: .NSExtensionHostWillResignActive)) { _ in
            logger.debug("System notification that Settings will resign active.")
            self.saveUserDefualts()
        }
    }
}

extension Settings {
    func saveUserDefualts() {
        let intensity = ExerciseIntensity.allCases[selectedExerciseIntensity]
        logger.log("Saving preferences to UserDefaults (intensity: \(intensity.rawValue, privacy: .public); crown velocity: \(crownVelocityMultiplier, format: .fixed(precision: 1)))")
        UserDefaults.standard.set(intensity.rawValue,
                                  forKey: UserDefaultsKeys.exerciseIntensity.rawValue)

        UserDefaults.standard.set(crownVelocityMultiplier,
                                  forKey: UserDefaultsKeys.crownVelocityMultiplier.rawValue)
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

#if DEBUG
    struct Settings_Previews: PreviewProvider {
        static var previews: some View {
            Settings(exerciseOptions: ExerciseOptions())
        }
    }
#endif
