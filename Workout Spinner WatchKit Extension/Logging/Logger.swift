//
//  Logger.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 12/10/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation
import os

extension Logger {
    static let mySubsystem = "com.joshuacook.Workout-Spinner"
    static let workoutManagerLogger = Logger(subsystem: Logger.mySubsystem, category: "workout-manager")
    static let exerciseOptionsLogger = Logger(subsystem: Logger.mySubsystem, category: "exercise-options")
    static let heartRateGraphLogger = Logger(subsystem: Logger.mySubsystem, category: "heart-rate-graph")
}
