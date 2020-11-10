//
//  Workouts.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 8/31/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation

struct ExerciseOptions: Codable {
    
    var exercises = [ExerciseInfo]()
    
    init() {
        exercises = loadExercises()
        if exercises.count == 0 {
            do {
                exercises = try parse(jsonData: readLocalJsonFile(named: "WorkoutSpinnerExercises"))
                saveExercises()
            } catch {
                print("error in loading workouts: \(error.localizedDescription)")
            }
        }
    }
    
    /// Write exercise array to disk.
    func saveExercises() {
        let encoder = JSONEncoder()
        do {
            let encodedExercises = try encoder.encode(exercises)
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
}



// MARK: - Editing options array
extension ExerciseOptions {
    /// Add a new exercise.
    mutating func append(_ exercise: ExerciseInfo) {
        exercises.append(exercise)
        saveExercises()
    }
    
    /// Replace one exercise with another.
    mutating func replace(_ exercise: ExerciseInfo, with newExercise: ExerciseInfo) {
        if let idx = exercises.firstIndex(where: { $0 == exercise }) {
            exercises[idx] = newExercise
            saveExercises()
        }
    }
    
    /// Remove an exercise.
    mutating func remove(_ exercise: ExerciseInfo) {
        let startCount = exercises.count
        exercises = exercises.filter { $0 == exercise }
        if startCount != exercises.count {
            saveExercises()
        }
    }
    
    /// Remove multiple exercises.
    mutating func remove(_ exercisesToRemove: [ExerciseInfo]) {
        if exercisesToRemove.count == 0 { return }
        let startCount = exercises.count
        for exercise in exercisesToRemove {
            exercises = exercises.filter { $0 != exercise }
        }
        if startCount != exercises.count {
            saveExercises()
        }
    }
    
    /// Update an existing exercise or append it to the end of the options.
    mutating func updateOrAppend(_ exercise: ExerciseInfo) {
        if let idx = exercises.firstIndex(where: { $0 == exercise }) {
            exercises[idx] = exercise
        } else {
            exercises.append(exercise)
        }
        saveExercises()
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





