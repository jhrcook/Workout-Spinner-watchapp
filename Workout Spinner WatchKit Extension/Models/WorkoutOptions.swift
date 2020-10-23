//
//  Workouts.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 8/31/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation

struct WorkoutOptions: Codable {
    var workouts = [WorkoutInfo]()
    
    init() {
        do {
            workouts = try parse(jsonData: readLocalJsonFile(named: "Workout Spinner workouts"))
            print("Read in \(workouts.count) workout(s).")
        } catch {
            print("error in loading workouts: \(error.localizedDescription)")
        }
    }
}


extension WorkoutOptions {
    /// Parse the JSON data to an array of workouts.
    /// - Parameter jsonData: JSON data as a `Data` object.
    /// - Returns: The JSON data decoded into an arraw of `Workout`.
    private func parse(jsonData: Data) throws -> [WorkoutInfo] {
        do {
            let workouts: [WorkoutInfo] = try JSONDecoder().decode([WorkoutInfo].self, from: jsonData)
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





