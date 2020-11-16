//
//  Workouts.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 8/31/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation

class ExerciseOptions: NSObject, ObservableObject {
    
    @Published var allExercises = [ExerciseInfo]()
    
    var exercises: [ExerciseInfo] {
        get {
            return allExercises.filter { $0.active }
        }
    }
    
    var exercisesBlacklistFiltered: [ExerciseInfo] {
        get {
            return filterBlacklistedBodyParts()
        }
    }
        
    override init() {
        super.init()
        allExercises = loadExercises()
        if allExercises.count == 0 {
            resetExerciseOptions()
        }
    }
    
    /// Write exercise array to disk.
    func saveExercises() {
        let encoder = JSONEncoder()
        do {
            let encodedExercises = try encoder.encode(allExercises)
            UserDefaults.standard.set(encodedExercises, forKey: UserDefaultsKeys.exerciseOptions.rawValue)
        } catch {
            print("Error when encoding exercises to JSON: \(error.localizedDescription)")
        }
    }
    
    
    /// Read in exercise array from disk.
    /// - Returns: Array of exercises.
    func loadExercises() -> [ExerciseInfo] {
        if let codedExercises = UserDefaults.standard.object(forKey: UserDefaultsKeys.exerciseOptions.rawValue) as? Data {
            do {
                let decodedExercises = try JSONDecoder().decode([ExerciseInfo].self, from: codedExercises)
                return decodedExercises
            } catch {
                print("Unable to decode exercises: \(error.localizedDescription)")
            }
        }
        return []
    }
    
    
    func filterBlacklistedBodyParts() -> [ExerciseInfo] {
        let inactiveBodyparts: [ExerciseBodyPart] = BodyPartSelections(with: .userDefaults)
            .bodyparts
            .filter { !$0.enabled }
            .map { $0.bodypart }
        
        return exercises.filter { exercise in
            if let _ = exercise.bodyParts.first(where: { inactiveBodyparts.contains($0) }) {
                return false
            }
            return true
        }
    }
}



// MARK: - Editing options array
extension ExerciseOptions {
    /// Add a new exercise.
    func append(_ exercise: ExerciseInfo) {
        allExercises.append(exercise)
        saveExercises()
    }
    
    /// Replace one exercise with another.
    func replace(_ exercise: ExerciseInfo, with newExercise: ExerciseInfo) {
        if let idx = allExercises.firstIndex(where: { $0 == exercise }) {
            allExercises[idx] = newExercise
            saveExercises()
        }
    }
    
    /// Remove an exercise.
    func remove(_ exercise: ExerciseInfo) {
        let startCount = allExercises.count
        allExercises = exercises.filter { $0 == exercise }
        if startCount != allExercises.count {
            saveExercises()
        }
    }
    
    /// Remove multiple exercises.
    func remove(_ exercisesToRemove: [ExerciseInfo]) {
        if exercisesToRemove.count == 0 { return }
        let startCount = allExercises.count
        for exercise in exercisesToRemove {
            allExercises = allExercises.filter { $0 != exercise }
        }
        if startCount != allExercises.count {
            saveExercises()
        }
    }
    
    /// Update an existing exercise or append it to the end of the options.
    func updateOrAppend(_ exercise: ExerciseInfo) {
        if let idx = allExercises.firstIndex(where: { $0 == exercise }) {
            allExercises[idx] = exercise
        } else {
            allExercises.append(exercise)
        }
        saveExercises()
    }
    
    /// Resest the list of exercises to default options.
    func resetExerciseOptions() {
        do {
            allExercises = try parse(jsonData: readLocalJsonFile(named: "WorkoutSpinnerExercises"))
            saveExercises()
        } catch {
            print("error in loading workouts: \(error.localizedDescription)")
        }
    }
}



// MARK: - Reading in default exercise JSON.
extension ExerciseOptions {
    /// Parse the JSON data to an array of workouts.
    /// - Parameter jsonData: JSON data as a `Data` object.
    /// - Returns: The JSON data decoded into an arraw of `Workout`.
    private func parse(jsonData: Data) throws -> [ExerciseInfo] {
        do {
            let workouts: [ExerciseInfo] = try JSONDecoder().decode([ExerciseInfo].self, from: jsonData)
            return workouts
        } catch {
            throw error
        }
    }
    
    /// Read in data from a JSON file.
    /// - Parameter name: Local file name.
    /// - Throws: Will throw an error if the file in unreachable or cannot be converted to a `Data` object.
    /// - Returns: The data in the JSON file.
    fileprivate func readLocalJsonFile(named name: String) throws -> Data {
        if let bundlePath = Bundle.main.path(forResource: name, ofType: "json") {
            do {
                if let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                    return jsonData
                } else {
                    throw DataReadingError.cannotConvertToData
                }
            } catch {
                throw error
            }
        } else {
            throw DataReadingError.fileDoesNotExist(name)
        }
    }
    
    enum DataReadingError: Error, LocalizedError {
        case fileDoesNotExist(String)
        case cannotConvertToData
        
        var errorDescription: String? {
            switch self {
            case .fileDoesNotExist(let fileName):
                return NSLocalizedString("No such file in bundle: '\(fileName)'", comment: "")
            case .cannotConvertToData:
                return NSLocalizedString("Cannot convert text in file to data.", comment: "")
            }
        }
    }
}





