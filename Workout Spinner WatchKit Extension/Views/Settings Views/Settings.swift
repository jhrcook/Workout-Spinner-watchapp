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
    @State private var haptics = HapticsSettings()

    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

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
                PlusMinusStepper(value: $crownVelocityMultiplier, step: 1, min: 1, max: 10, label: Text("\(Int(crownVelocityMultiplier))"))
            }

            Section(header: SectionHeader(imageName: "applewatch.radiowaves.left.and.right", text: "Haptics")) {
                Toggle(isOn: $haptics.successfulWheelSpin) {
                    Text("Wheel spin")
                }
                Toggle(isOn: $haptics.startExercise) {
                    Text("Begin exercise")
                }
                Toggle(isOn: $haptics.endExercise) {
                    Text("End exercise")
                }
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
                    Text(appVersion ?? "1.3.2")
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
            loadSettings()
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

        haptics.saveAll()
    }

    private func loadSettings() {
        selectedExerciseIntensity = Settings.getSavedExerciseIntensity()
        haptics = HapticsSettings()
        crownVelocityMultiplier = UserDefaults.readCrownVelocityMultiplier()
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
