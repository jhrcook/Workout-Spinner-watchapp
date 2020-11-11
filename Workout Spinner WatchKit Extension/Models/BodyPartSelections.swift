//
//  BodyPartSelections.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/9/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

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
    
    /// Extract the body parts from exeristing exercise information.
    /// - Parameter exerciseInfo: The exercise information.
    init(fromExerciseInfo exerciseInfo: ExerciseInfo) {
        self.bodyparts = ExerciseBodyPart.allCases
            .sorted { $0.rawValue < $1.rawValue }
            .map { BodyPartSelection(bodypart: $0, enabled: exerciseInfo.bodyParts.contains($0)) }
    }
    
    
    /// Initialize with specificed body parts.
    init(bodyparts: [BodyPartSelection]) {
        self.bodyparts = bodyparts
    }
    
    
    enum DefaultBodyPartsSelection {
        case none, all, userDefaults
    }
    
    /// Initialize with some default selection of body parts.
    /// - Parameter selection: The section of body parts to use.
    init(with selection: DefaultBodyPartsSelection) {
        if selection == .userDefaults {
            let userDefaultsData = BodyPartSelections.readUserDefaults()
            self.bodyparts = ExerciseBodyPart.allCases
                .sorted { $0.rawValue < $1.rawValue }
                .map{ BodyPartSelection(bodypart: $0, enabled: userDefaultsData[$0.rawValue] ?? true) }
        } else {
            self.bodyparts = ExerciseBodyPart.allCases
                .sorted { $0.rawValue < $1.rawValue }
                .map { BodyPartSelection(bodypart: $0, enabled: selection == .all) }
        }
    }
        
    
    static func readUserDefaults() -> [String: Bool] {
        if let data = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.activeBodyParts.rawValue) as? [String: Bool] {
            return data
        } else {
            return [String: Bool]()
        }
    }
    
    
    func saveDataToUserDefaults() {
        var data = [String: Bool]()
        for bp in bodyparts {
            data[bp.bodypart.rawValue] = bp.enabled
        }
        UserDefaults.standard.set(data, forKey: UserDefaultsKeys.activeBodyParts.rawValue)
    }
}
