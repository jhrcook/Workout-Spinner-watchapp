//
//  HapticsSettings.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 1/29/21.
//  Copyright © 2021 Joshua Cook. All rights reserved.
//

import SwiftUI
import WatchKit

class HapticsSettings: ObservableObject {
    private(set) var successfulWheelSpin: Bool
    private(set) var startExercise: Bool
    private(set) var endExercise: Bool

    init() {
        HapticsSettings.checkInitialRegistration()
        successfulWheelSpin = HapticsSettings.setting(for: .successfulWheelSpin)
        startExercise = HapticsSettings.setting(for: .startExercise)
        endExercise = HapticsSettings.setting(for: .endExercise)
    }

    enum HapticSetting: String, CaseIterable {
        case successfulWheelSpin
        case startExercise
        case endExercise
    }

    public func save(_ setting: HapticSetting, as value: Bool) {
        UserDefaults.standard.setValue(value, forKey: setting.rawValue)
    }

    internal static func setting(for setting: HapticSetting) -> Bool {
        UserDefaults.standard.bool(forKey: setting.rawValue)
    }

    private static func checkInitialRegistration() {
        let initialCheckKey = "HapticSettingsInitialCheck"
        if UserDefaults.standard.bool(forKey: initialCheckKey) { return }
        for key in HapticSetting.allCases {
            UserDefaults.standard.setValue(true, forKey: key.rawValue)
        }
        UserDefaults.standard.setValue(true, forKey: initialCheckKey)
    }

    public func play(soundFor action: HapticSetting, ifSet playHaptic: Bool) {
        if !playHaptic { return }

        switch action {
        case .successfulWheelSpin:
            WKInterfaceDevice.current().play(.success)
        case .startExercise:
            WKInterfaceDevice.current().play(.start)
        case .endExercise:
            WKInterfaceDevice.current().play(.stop)
        }
    }
}
