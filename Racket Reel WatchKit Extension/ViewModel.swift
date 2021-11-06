//
//  ViewModel.swift
//  Racket Reel WatchKit Extension
//
//  Created by Tom Elvidge on 23/07/2021.
//

import Foundation
import WatchConnectivity
import HealthKit

class ViewModel : NSObject, ObservableObject, WCSessionDelegate {
    
    // WatchConnectivity for send match data to iPhone
    var session: WCSession?
    
    // HealthKit
    var healthStore: HKHealthStore?
    var workoutSession: HKWorkoutSession?
    
    @Published var currentView = ViewType.welcome
    @Published var tMatch: TennisMatch?
    
    override init() {
        super.init()
        
        if WCSession.isSupported() {
            self.session = WCSession.default
            self.session!.delegate = self
            self.session!.activate()
        }
        
        if HKHealthStore.isHealthDataAvailable() {
            self.healthStore = HKHealthStore()
            
            // The quantity type to write to the health store.
            let typesToShare: Set = [
                HKQuantityType.workoutType()
            ]

            // Request authorization for those quantity types.
            self.healthStore!.requestAuthorization(toShare: typesToShare, read: nil) { (success, error) in
                guard success else {
                    print("Cannot authorize HKHealthStore.")
                    return
                }
                print("HKHealthStore authorized.")
            }
        }
    }
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
    }
    
    func startWorkoutSession() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .tennis
        configuration.locationType = .unknown
        
        do {
            self.workoutSession = try HKWorkoutSession(healthStore: self.healthStore!, configuration: configuration)
            let builder = self.workoutSession!.associatedWorkoutBuilder()
            builder.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore!, workoutConfiguration: configuration)
            // self.workoutSession!.delegate = self
            // builder.delegate = self
            // Start session
            self.workoutSession!.startActivity(with: Date())
            builder.beginCollection(withStart: Date()) { (success, error) in
                
                guard success else {
                    print("Something went wrong starting the workout.")
                    return
                }
                
                print("Workout session has started.")
            }
        } catch {
            print("Cannot start workout.")
            return
        }
    }
    
    func endWorkoutSession() {
        self.workoutSession!.end()
        let builder = self.workoutSession!.associatedWorkoutBuilder()
        builder.endCollection(withEnd: Date()) { (success, error) in
            
            guard success else {
                print("Something went wrong ending the workout.")
                return
            }
            
            builder.finishWorkout { (workout, error) in
                
                guard workout != nil else {
                    print("Workout is not nil.")
                    return
                }
                
                print("Workout completed.")
            }
        }
    }
    
    func quit() {
        self.endWorkoutSession()
        self.changeView(view: ViewType.welcome)
        // Discard match
        self.tMatch = nil
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
    
    func changeView(view: ViewType) {
        self.currentView = view
    }
    
    func newtMatch(preferences: TennisPreferences) {
        self.tMatch = TennisMatch(createdByUserId: UUID().uuidString, preferences: preferences)
        do {
            try self.tMatch?.startMatch()
        } catch {
            // Todo: Display alert if something goes wrong
            print(error.localizedDescription)
        }
        self.startWorkoutSession()
    }
    
    func savetMatch() {
        // Encode match into JSON
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        do {
            let data = try encoder.encode(tMatch)
            encoder.outputFormatting = .prettyPrinted
            NSLog(String(data: data, encoding: .utf8)!)
            // Send match JSON to iPhone
            do {
                try self.session?.updateApplicationContext(["match": data])
            } catch {
                print("Unable to send data to iPhone")
            }
        } catch {
            print("Unable to encode match JSON")
        }
    }
    
    func newtEvent(event: TennisEventType) {
        // If match over then save match
        do {
            objectWillChange.send()
            try tMatch?.logEvent(event)
        } catch {
            // Todo: Display an alert if something went wrong.
            print(error.localizedDescription)
        }
        
        if !tMatch!.inProgress {
            currentView = ViewType.matchOver
        }
    }
    
    func undotEvent() {
        do {
            objectWillChange.send()
            try tMatch?.undoLastEvent()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
