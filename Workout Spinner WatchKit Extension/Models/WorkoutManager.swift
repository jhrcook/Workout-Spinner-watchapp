//
//  WorkoutManager.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 10/21/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Combine
import Foundation
import HealthKit
import os

enum WorkoutState {
    case running, paused, ended
}

class WorkoutManager: NSObject, ObservableObject {
    /// - Tag: Declare workout data information
    var exerciseInfo: ExerciseInfo?

    /// - Tag: Declare HealthStore, WorkoutSession, and WorkoutBuilder
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession!
    var builder: HKLiveWorkoutBuilder!

    // The app's workout state.
    /// - Tag: Object state
    var active: Bool = false

    /// - Tag: Publishers
    @Published var heartrate: Double = 0.0
    @Published var activeCalories: Double = 0.0
    @Published var elapsedSeconds: Int = 0

    struct HeartRateReading {
        let date = Date()
        let heartRate: Double
    }

    var allHeartRateReadings = [HeartRateReading]()

    /// - Tag: TimerSetup
    // The cancellable holds the timer publisher.
    var start = Date()
    var cancellable: Cancellable?
    var accumulatedTime: Int = 0

    let logger = Logger.workoutManagerLogger

    override init() {
        exerciseInfo = nil
        logger.info("WorkoutManager initialized with no arguments.")
    }

    init(exerciseInfo: ExerciseInfo) {
        self.exerciseInfo = exerciseInfo
        logger.info("WorkoutManager initialized with exercise information: \(exerciseInfo.displayName, privacy: .public).")
    }

    // Set up and start the timer.
    internal func setUpTimer() {
        start = Date()
        cancellable = Timer.publish(every: 0.1, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.elapsedSeconds = self.incrementElapsedTime()
            }
    }

    // Calculate the elapsed time.
    func incrementElapsedTime() -> Int {
        let runningTime = Int(-1 * start.timeIntervalSinceNow)
        return accumulatedTime + runningTime
    }

    /// Request authorization to access HealthKit.
    func requestAuthorization() {
        // The quantity type to write to the health store.
        let typesToShare: Set = [
            HKQuantityType.workoutType(),
        ]

        // The quantity types to read from the health store.
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
        ]

        // Request authorization for those quantity types.
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { _, error in
            if let error = error {
                self.logger.error("Error requesting data read/share authorization: \(error.localizedDescription, privacy: .public)")
                return
            }
            self.logger.log("Successfully requesting authoriation for data reading and sharing.")
        }
    }

    /// Provide the workout configuration.
    internal func workoutConfiguration() -> HKWorkoutConfiguration {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .functionalStrengthTraining
        configuration.locationType = .indoor
        return configuration
    }

    /// Start the workout.
    internal func setupWorkout() {
        logger.log("Setting up workout.")
        // Create the session and obtain the workout builder.
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration())
            builder = session.associatedWorkoutBuilder()
        } catch {
            // Handle any exceptions.
            logger.error("Error creating workout: \(error.localizedDescription, privacy: .public)")
            return
        }

        // Setup session and builder.
        session.delegate = self
        builder.delegate = self

        // Set the workout builder's data source.
        builder.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,
                                                     workoutConfiguration: workoutConfiguration())

        logger.log("Finished setting up workout.")
    }

    /// Prepare a workout (I am not sure what this does, but it is in the `HKWorkoutSession` API.)
    func prepareWorkout() {
        logger.log("Workout prepared.")
        session.prepare()
    }

    /// Start a workout
    func startWorkout() {
        logger.log("Workout started.")
        // Start the timer.
        setUpTimer()
        accumulatedTime = 0
        // Set state to active.
        active = true
        // Start the workout session.
        session.startActivity(with: Date())
        // Start data collection.
        startWorkoutDataCollection()
    }

    /// Pause a workout.
    func pauseWorkout() {
        logger.log("Workout paused.")
        // Pause the workout.
        session.pause()
        // Stop the timer.
        cancellable?.cancel()
        // Save the elapsed time.
        accumulatedTime = elapsedSeconds
        active = false
    }

    /// Resume a previously started workout.
    func resumeWorkout() {
        logger.log("Workout resumed.")
        // Start the timer.
        setUpTimer()
        active = true
        // Resume the workout.
        session.resume()
    }

    /// Reset all of the informational variables.
    func resetTrackedInformation() {
        logger.log("Reset recorded exercise information.")
        accumulatedTime = 0
        allHeartRateReadings = []
        heartrate = 0
        activeCalories = 0
        elapsedSeconds = 0
    }

    /// End a workout.
    func endWorkout() {
        logger.log("Ending workout session.")
        session.stopActivity(with: Date())
        session.end()
        active = false
        stopWorkoutDataCollection()
        resetTrackedInformation()
    }

    internal func stopWorkoutDataCollection() {
        builder.endCollection(withEnd: Date()) { success, error in
            if let error = error {
                self.logger.error("Builder data collection ended with error: \(error.localizedDescription, privacy: .public)")
            } else if success {
                self.logger.log("Builder data collection ended successfully.")
            } else {
                self.logger.log("Builder data collection did not end successfully (but without error).")
            }
        }
    }

    internal func startWorkoutDataCollection() {
        builder.beginCollection(withStart: Date()) { [unowned self] _, error in
            if let error = error {
                self.logger.error("Error when beginning data collection: \(error.localizedDescription)")
            } else {
                self.logger.info("Data collection begun successfully.")
            }
        }
    }

    // MARK: - Update the UI

    // Update the published values.
    internal func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }
        if !active { return }

        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                let value = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit)
                let roundedValue = Double(round(1 * value!) / 1)
                self.allHeartRateReadings.append(HeartRateReading(heartRate: value!))
                self.heartrate = roundedValue
                return
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                let value = statistics.sumQuantity()?.doubleValue(for: energyUnit)
                self.activeCalories = Double(round(1 * value!) / 1)
                return
            default:
                return
            }
        }
    }
}

// MARK: - HKWorkoutSessionDelegate

extension WorkoutManager: HKWorkoutSessionDelegate {
    func workoutSession(_: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState, date _: Date)
    {
        let fromStateH = workoutStateDescription(fromState)
        let toStateH = workoutStateDescription(toState)
        logger.info("Workout session did change state: \(fromStateH, privacy: .public) -> \(toStateH, privacy: .public)")

        if toState == .ended {
            // Wait for the session to transition states before ending the builder.
            builder.finishWorkout { _, error in
                // Optionally display a workout summary to the user.
                if let error = error {
                    self.logger.error("Builder did finish with error: \(error.localizedDescription, privacy: .public)")
                }
                self.logger.info("Builder finished workout successfully.")
            }
        }
    }

    func workoutSession(_: HKWorkoutSession, didFailWithError error: Error) {
        logger.error("Workout session failed: \(error.localizedDescription, privacy: .public)")
    }

    /// Return a description for the workout session state.
    /// - Parameter state: A workout state.
    /// - Returns: A descriptive string.
    internal func workoutStateDescription(_ state: HKWorkoutSessionState) -> String {
        switch state {
        case .ended:
            return "ended"
        case .notStarted:
            return "not started"
        case .paused:
            return "paused"
        case .prepared:
            return "prepared"
        case .running:
            return "running"
        case .stopped:
            return "stopped"
        default:
            return "(unknown state)"
        }
    }
}

// MARK: - HKLiveWorkoutBuilderDelegate

extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilderDidCollectEvent(_: HKLiveWorkoutBuilder) {
        // Does nothing for now.
    }

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            logger.debug("Did collect data of \(type.description, privacy: .public)")
            guard let quantityType = type as? HKQuantityType else {
                return // Nothing to do.
            }

            /// - Tag: GetStatistics
            let statistics = workoutBuilder.statistics(for: quantityType)

            // Update the published values.
            updateForStatistics(statistics)
        }
    }
}
