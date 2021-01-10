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

    // MARK: - Model loggers

    static let workoutManagerLogger = Logger(subsystem: Logger.mySubsystem, category: "workout-manager")
    static let exerciseOptionsLogger = Logger(subsystem: Logger.mySubsystem, category: "exercise-options")
    static let heartRateGraphLogger = Logger(subsystem: Logger.mySubsystem, category: "heart-rate-graph")
    static let bodyPartSelectionsLogger = Logger(subsystem: Logger.mySubsystem, category: "body-part-selections")

    // MARK: - View loggers

    static let welcomeViewLogger = Logger(subsystem: Logger.mySubsystem, category: "welcome-view")
    static let workoutPagingViewLogger = Logger(subsystem: Logger.mySubsystem, category: "workout-paging-view")
    static let exercisePickerLogger = Logger(subsystem: Logger.mySubsystem, category: "exercise-picker")
    static let workoutFinishViewLogger = Logger(subsystem: Logger.mySubsystem, category: "workout-finish-view")
    static let heartRateGraphViewLogger = Logger(subsystem: Logger.mySubsystem, category: "heart-rate-graph-view")

    // MARK: - Settings

    static let settingsLogger = Logger(subsystem: Logger.mySubsystem, category: "settings")
    static let editExercisesViewLogger = Logger(subsystem: Logger.mySubsystem, category: "settings-edit-exercise-view")
}
