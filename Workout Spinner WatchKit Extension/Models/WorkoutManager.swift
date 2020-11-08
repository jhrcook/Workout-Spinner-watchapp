//
//  WorkoutManager.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 10/21/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import Foundation
import HealthKit
import Combine

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
    var start: Date = Date()
    var cancellable: Cancellable?
    var accumulatedTime: Int = 0
    
    
    override init() {
        self.exerciseInfo = nil
    }
    
    init(exerciseInfo: ExerciseInfo) {
        self.exerciseInfo = exerciseInfo
    }
    
    
    // Set up and start the timer.
    internal func setUpTimer() {
        start = Date()
        cancellable = Timer.publish(every: 0.1, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.elapsedSeconds = self.incrementElapsedTime()
                
                // Mock exercise stats with a 5 % chance.
                if Int.random(in: 0...100) < 5 {
                    self.updateMockStatistics(quantityType: .heartRate)
                }
                if Int.random(in: 0...100) < 5 {
                    self.updateMockStatistics(quantityType: .activeEnergyBurned)
                }
            }
    }
    
    
    // Calculate the elapsed time.
    func incrementElapsedTime() -> Int {
        let runningTime: Int = Int(-1 * (self.start.timeIntervalSinceNow))
        return self.accumulatedTime + runningTime
    }
    
    
    /// Request authorization to access HealthKit.
    func requestAuthorization() {
        // The quantity type to write to the health store.
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]
        
        // The quantity types to read from the health store.
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]
        
        // Request authorization for those quantity types.
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            if let error = error {
                print("Error requesting data read/share authorization: \(error.localizedDescription)")
                return
            }
            print("Successfully requesting authoriation for data reading and sharing.")
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
        // Create the session and obtain the workout builder.
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration())
            builder = session.associatedWorkoutBuilder()
        } catch {
            // Handle any exceptions.
            print("Error creating workout: \(error.localizedDescription)")
            return
        }
        
        // Setup session and builder.
        session.delegate = self
        builder.delegate = self
        
        // Set the workout builder's data source.
        builder.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,
                                                     workoutConfiguration: workoutConfiguration())
    }
    
    /// Start a workout
    func startWorkout() {
        // Start the timer.
        setUpTimer()
        accumulatedTime = 0
        // Set state to active.
        active = true
        // Start the workout session and begin data collection.
        session.startActivity(with: Date())
    }
    
    /// Pause a workout.
    func pauseWorkout() {
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
        // Start the timer.
        setUpTimer()
        active = true
        // Resume the workout.
        session.resume()
    }
    
    /// Reset all of the informational variables.
    func resetTrackedInformation() {
        accumulatedTime = 0
        allHeartRateReadings = []
        heartrate = 0
        activeCalories = 0
        elapsedSeconds = 0
    }
    
    /// End a workout.
    func endWorkout() {
        print("Ending workout session.")
        
        builder.endCollection(withEnd: Date()) { (success, error) in
            if let error = error {
                print("Data collection ended with error: \(error.localizedDescription)")
            } else if success {
                print("Data collection ended successfully.")
            } else {
                print("Data collection did not end successfully (but without error).")
            }
        }
        
        session.end()
        active = false
        resetTrackedInformation()
    }
    
    
    // MARK: - Update the UI
    // Update the published values.
    internal func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }
        
        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                let value = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit)
                let roundedValue = Double( round( 1 * value! ) / 1 )
                self.allHeartRateReadings.append(HeartRateReading(heartRate: value!))
                self.heartrate = roundedValue
                return
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                let value = statistics.sumQuantity()?.doubleValue(for: energyUnit)
                self.activeCalories = Double( round( 1 * value! ) / 1 )
                return
            default:
                return
            }
        }
    }
    
    enum MockWorkoutStatistics {
        case heartRate, activeEnergyBurned
    }
    
    internal func updateMockStatistics(quantityType: MockWorkoutStatistics) {
        DispatchQueue.main.async {
            switch quantityType {
            case .heartRate:
                self.heartrate += Double.random(in: self.heartrate == 0 ? 100...120 : -5...5)
                self.allHeartRateReadings.append(HeartRateReading(heartRate: self.heartrate))
            case .activeEnergyBurned:
                self.activeCalories += Double.random(in: 1...3)
            }
        }
    }
    
}




// MARK: - HKWorkoutSessionDelegate
extension WorkoutManager: HKWorkoutSessionDelegate {
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState, date: Date) {
        print("Workout session did change state: \(workoutStateDescription(fromState)) -> \(workoutStateDescription(toState))")
        
        if toState == .ended {
            // Wait for the session to transition states before ending the builder.
            builder.finishWorkout { (workout, error) in
                // Optionally display a workout summary to the user.
                if let error = error {
                    print("Builder did finish with error: \(error.localizedDescription)")
                }
                print("Builder finished successfully.")
            }
        }
    }
    
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("Workout session failed: \(error.localizedDescription)")
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
        case.prepared:
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
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        // Does nothing for now.
    }
    
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
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
