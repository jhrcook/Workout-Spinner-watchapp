//
//  BodyPartSelections.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/9/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import os
import SwiftUI

struct BodyPartSelection: Identifiable {
    let bodypart: ExerciseBodyPart
    var enabled: Bool
    var id: String {
        bodypart.rawValue
    }
}

class BodyPartSelections: ObservableObject {
    @Published var bodyparts = [BodyPartSelection]()
    let logger = Logger.bodyPartSelectionsLogger

    /// Extract the body parts from exeristing exercise information.
    /// - Parameter exerciseInfo: The exercise information.
    init(fromExerciseInfo exerciseInfo: ExerciseInfo) {
        logger.info("Initialized `BodyPartSelections` with exercise information.")
        bodyparts = ExerciseBodyPart.allCases
            .sorted { $0.rawValue < $1.rawValue }
            .map { BodyPartSelection(bodypart: $0, enabled: exerciseInfo.bodyParts.contains($0)) }
        logger.debug("Number of body parts: \(bodyparts.count, privacy: .public)")
    }

    /// Initialize with specificed body parts.
    init(bodyparts: [BodyPartSelection]) {
        logger.info("Initialized `BodyPartSelections` with and array of \(bodyparts.count, privacy: .public) body part(s).")
        self.bodyparts = bodyparts
        logger.debug("Number of body parts: \(self.bodyparts.count, privacy: .public)")
    }

    enum DefaultBodyPartsSelection: String {
        case none, all, userDefaults
    }

    /// Initialize with some default selection of body parts.
    /// - Parameter selection: The section of body parts to use.
    init(with selection: DefaultBodyPartsSelection) {
        logger.info("Initialized `BodyPartSelections` with '\(selection.rawValue)'.")
        switch selection {
        case .userDefaults:
            logger.debug("Reading in UserDefaults.")
            let userDefaultsData = BodyPartSelections.readUserDefaults()
            bodyparts = ExerciseBodyPart.allCases
                .sorted { $0.rawValue < $1.rawValue }
                .map { BodyPartSelection(bodypart: $0, enabled: userDefaultsData[$0.rawValue] ?? true) }
        case .all, .none:
            bodyparts = ExerciseBodyPart.allCases
                .sorted { $0.rawValue < $1.rawValue }
                .map { BodyPartSelection(bodypart: $0, enabled: selection == .all) }
        }

        logger.debug("Number of body parts: \(bodyparts.count, privacy: .public)")
    }

    static func readUserDefaults() -> [String: Bool] {
        if let data = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.activeBodyParts.rawValue) as? [String: Bool] {
            return data
        } else {
            return [String: Bool]()
        }
    }

    func saveDataToUserDefaults() {
        logger.info("Saving body part list to UserDefaults.")
        var data = [String: Bool]()
        for bp in bodyparts {
            data[bp.bodypart.rawValue] = bp.enabled
        }
        UserDefaults.standard.set(data, forKey: UserDefaultsKeys.activeBodyParts.rawValue)
    }
}
