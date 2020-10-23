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
    let userDefaultsData = BodyPartSelections.readUserDefaults()
    
    
    init() {
        var a = [BodyPartSelection]()
        for bp in ExerciseBodyPart.allCases.sorted(by: { $0.rawValue < $1.rawValue }) {
            a.append(BodyPartSelection(bodypart: bp, enabled: userDefaultsData[bp.rawValue] ?? true))
        }
        self.bodyparts = a
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