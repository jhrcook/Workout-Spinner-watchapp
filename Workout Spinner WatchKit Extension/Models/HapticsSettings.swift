//
//  HapticsSettings.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 1/29/21.
//  Copyright © 2021 Joshua Cook. All rights reserved.
//

import SwiftUI
import WatchKit

struct HapticsSettings {
    var successfulWheelSpin: Bool = setting(for: .successfulWheelSpin)
    var startExercise: Bool = setting(for: .startExercise)
    var endExercise: Bool = setting(for: .endExercise)

    init() {
        checkInitialRegistration()
    }

    enum HapticSetting: String, CaseIterable {
        case successfulWheelSpin
        case startExercise
        case endExercise
    }

    public func saveAll() {
        save(.successfulWheelSpin, as: successfulWheelSpin)
        save(.startExercise, as: startExercise)
        save(.endExercise, as: endExercise)
    }

    public func save(_ setting: HapticSetting, as value: Bool) {
        UserDefaults.standard.setValue(value, forKey: setting.rawValue)
    }

    internal static func setting(for setting: HapticSetting) -> Bool {
        UserDefaults.standard.bool(forKey: setting.rawValue)
    }

    private func checkInitialRegistration() {
        let initialCheckKey = "HapticSettingsInitialCheck"
        if UserDefaults.standard.bool(forKey: initialCheckKey) { return }
        for key in HapticSetting.allCases {
            UserDefaults.standard.setValue(true, forKey: key.rawValue)
        }
        UserDefaults.standard.setValue(true, forKey: initialCheckKey)
    }

    public func play(soundFor action: HapticSetting) {
        switch action {
        case .successfulWheelSpin:
            if successfulWheelSpin {
                WKInterfaceDevice.current().play(.success)
            }
        case .startExercise:
            if startExercise {
                WKInterfaceDevice.current().play(.start)
            }
        case .endExercise:
            if endExercise {
                WKInterfaceDevice.current().play(.stop)
            }
        }
    }
}
