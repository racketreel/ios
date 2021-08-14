//
//  ViewModel.swift
//  Game Set Match WatchKit Extension
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
    @Published var match: Match?
    
    private let pointMapping = [
        0: "0",
        1: "15",
        2: "30",
        3: "40",
        4: "AD"
    ]
    
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
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
    
    func changeView(view: ViewType) {
        self.currentView = view
    }
    
    func newMatch(matchPreferences: MatchPreferences) {
        self.match = Match(matchPreferences: matchPreferences)
        self.startWorkoutSession()
    }
    
    func saveMatch() {
        // Encode match into JSON
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        do {
            let data = try encoder.encode(match)
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
    
    func applyServe() {
        let nextState = self.match!.currentState.copy() as! MatchState
        nextState.generationEventTimestamp = NSDate().timeIntervalSince1970
        nextState.generationEvent = GenerationEvent.FirstServe
        
        // Set state as second serve if previous state was a first serve
        if (self.match!.currentState.generationEvent == GenerationEvent.FirstServe) {
            nextState.generationEvent = GenerationEvent.SecondServe
        }
        
        objectWillChange.send()
        self.match!.history.append(nextState)
        self.match!.currentState = nextState
    }
    
    func applyWin() {
        let currentState = self.match!.currentState
        let newState = currentState.copy() as! MatchState
        newState.generationEventTimestamp = NSDate().timeIntervalSince1970
        newState.generationEvent = GenerationEvent.Win
        
        if (currentState.pointDescription == PointDescription.SetFor) {
            // Resolve set
            newState.setsUser += 1
            setReset(state: newState)
        } else if (currentState.pointDescription == PointDescription.GameFor) {
            // Resolve game
            newState.gamesUser += 1
            gameReset(state: newState)
        } else {
            // Score points for a win
            if currentState.tieBreak {
                newState.pointsUserInt += 1
                // Just 0, 1, 2 etc scoring in tie break
                newState.pointsUser = String(newState.pointsUserInt)
                // Switch serve after first point and then after every other point (i.e. odd points)
                newState.tieBreakPointCounter += 1
                if (newState.tieBreakPointCounter % 2 != 0) {
                    newState.toServe = !newState.toServe
                }
            } else {
                // If opponent was on advantage put it back to duece
                if (currentState.pointsOpponentInt == 4) {
                    newState.pointsOpponentInt -= 1
                } else {
                    // Otherwise just increment points
                    newState.pointsUserInt += 1
                }
                // Parse Int points to String points
                newState.pointsUser = pointMapping[newState.pointsUserInt]!
                newState.pointsOpponent = pointMapping[newState.pointsOpponentInt]!
            }
        }
        updatePointDescription(state: newState)
        
        // If state now in a tie break then keep track of who will serve after
        if isTieBreak(state: newState) {
            newState.tieBreak = true
            newState.toServePostTieBreak = newState.toServe
        }
        
        // ViewModelWatch cannot tell that match has changed so manually notify observers that there is about to be a change in self
        objectWillChange.send()
        match!.history.append(newState)
        match!.currentState = newState
        
        // If won on match point then change to MatchOverView
        if (currentState.pointDescription == PointDescription.MatchFor) {
            currentView = ViewType.matchOver
        }
    }
    
    func applyLoss() {
        let currentState = self.match!.currentState
        let newState = currentState.copy() as! MatchState
        newState.generationEventTimestamp = NSDate().timeIntervalSince1970
        newState.generationEvent = GenerationEvent.Loss
        
        if (currentState.pointDescription == PointDescription.SetAgainst) {
            // Resolve set
            newState.setsOpponent += 1
            setReset(state: newState)
        } else if (currentState.pointDescription == PointDescription.GameAgainst) {
            // Resolve game
            newState.gamesOpponent += 1
            gameReset(state: newState)
        } else {
            // Score points for a win
            if currentState.tieBreak {
                newState.pointsOpponentInt += 1
                // Just 0, 1, 2 etc scoring in tie break
                newState.pointsOpponent = String(newState.pointsOpponentInt)
                // Switch serve after first point and then after every other point (i.e. odd points)
                newState.tieBreakPointCounter += 1
                if (newState.tieBreakPointCounter % 2 != 0) {
                    newState.toServe = !newState.toServe
                }
            } else {
                // If user was on advantage put it back to duece
                if (currentState.pointsUserInt == 4) {
                    newState.pointsUserInt -= 1
                } else {
                    // Otherwise just increment points
                    newState.pointsOpponentInt += 1
                }
                // Parse Int points to String points
                newState.pointsUser = pointMapping[newState.pointsUserInt]!
                newState.pointsOpponent = pointMapping[newState.pointsOpponentInt]!
            }
        }
        updatePointDescription(state: newState)
        
        // If state now in a tie break then keep track of who will serve after
        if isTieBreak(state: newState) {
            newState.tieBreak = true
            newState.toServePostTieBreak = newState.toServe
        }
        
        // ViewModelWatch cannot tell that match has changed so manually notify observers that there is about to be a change in self
        objectWillChange.send()
        match!.history.append(newState)
        match!.currentState = newState
        
        // If opponent won on match point then change to MatchOverView
        if (currentState.pointDescription == PointDescription.MatchAgainst) {
            currentView = ViewType.matchOver
        }
    }
    
    func undo() {
        if (match!.history.count > 1) {
            objectWillChange.send()
            match!.history.removeLast()
            match!.currentState = match!.history.last!
        }
    }
    
    private func updatePointDescription(state: MatchState) {
        state.pointDescription = PointDescription.None
        state.breakPoint = false
        
        let gamePointTo = gamePointTo(state: state)
        state.breakPoint = isBreakPoint(state: state, gamePointTo: gamePointTo)
        
        let setPointTo = setPointTo(state: state, gamePointTo: gamePointTo)
        let matchPointTo = matchPointTo(state: state, setPointTo: setPointTo)
        
        if (matchPointTo == PlayerType.user) {
            state.pointDescription = PointDescription.MatchFor
        }
        if (matchPointTo == PlayerType.opponent) {
            state.pointDescription = PointDescription.MatchAgainst
        }
        if (matchPointTo == PlayerType.neither) {
            if (setPointTo == PlayerType.user) {
                state.pointDescription = PointDescription.SetFor
            }
            if (setPointTo == PlayerType.opponent) {
                state.pointDescription = PointDescription.SetAgainst
            }
            if (setPointTo == PlayerType.neither) {
                if (gamePointTo == PlayerType.user) {
                    state.pointDescription = PointDescription.GameFor
                }
                if (gamePointTo == PlayerType.opponent) {
                    state.pointDescription = PointDescription.GameAgainst
                }
            }
        }
    }
    
    private func isTieBreak(state: MatchState) -> Bool {
        let gamesForSet = match?.matchPreferences.gamesForSet
        return (state.gamesUser == gamesForSet && state.gamesOpponent == gamesForSet)
    }
    
    private func isBreakPoint(state: MatchState, gamePointTo: PlayerType) -> Bool {
        // User or opponent on game point but not serving
        if ((gamePointTo == PlayerType.user && state.toServe == false)
                || (gamePointTo == PlayerType.opponent && state.toServe == true)) {
            return true
        }
        return false
    }
    
    private func gamePointTo(state: MatchState) -> PlayerType {
        if state.tieBreak {
            // User on 6 or more points
            // and at least one point ahead
            if (state.pointsUserInt >= 6 && state.pointsUserInt >= (state.pointsOpponentInt + 1)) {
                return PlayerType.user
            }
            // Vice versa for opponent
            if (state.pointsOpponentInt >= 6 && state.pointsOpponentInt >= (state.pointsUserInt + 1)) {
                return PlayerType.opponent
            }
        } else {
            // User on 40 or advantage and opponent at least one point behind
            if (state.pointsUserInt >= 3
                    && (state.pointsUserInt - state.pointsOpponentInt) >= 1) {
                return PlayerType.user
            }
            // Vice versa for opponent
            if (state.pointsOpponentInt >= 3
                    && (state.pointsOpponentInt - state.pointsUserInt) >= 1) {
                return PlayerType.opponent
            }
        }
        return PlayerType.neither
    }
    
    private func setPointTo(state: MatchState, gamePointTo: PlayerType) -> PlayerType {
        // Different condition when in tie break
        if state.tieBreak {
            // Just comes down to the tie break (game)
            return gamePointTo
        } else {
            // User has game point condition
            // and has at least one game less than the amount to win the set
            // and opponent at least one game behind
            if (gamePointTo == PlayerType.user
                    &&  state.gamesUser >= (match!.matchPreferences.gamesForSet - 1)
                    && (state.gamesUser - state.gamesOpponent) >= 1) {
                return PlayerType.user
            }
            // Vice versa for opponent
            if (gamePointTo == PlayerType.opponent
                    && state.gamesOpponent >= (match!.matchPreferences.gamesForSet - 1)
                    && (state.gamesOpponent - state.gamesUser) >= 1) {
                return PlayerType.opponent
            }
        }
        return PlayerType.neither
    }
    
    private func matchPointTo(state: MatchState, setPointTo: PlayerType) -> PlayerType {
        let setsToWin = match!.matchPreferences.setsToWin
        // User has set point condition and is one off the sets required for the match
        if (setPointTo == PlayerType.user && state.setsUser == (setsToWin - 1)) {
            return PlayerType.user
        }
        // Vice versa for opponent
        if (setPointTo == PlayerType.opponent && state.setsOpponent == (setsToWin - 1)) {
            return PlayerType.opponent
        }
        return PlayerType.neither
    }
    
    func gameReset(state: MatchState) {
        // Swap serve
        state.toServe = !state.toServe
        
        // Additional reset steps if was a tie break
        if state.tieBreak {
            // Restore next serve from var
            state.toServe = state.toServePostTieBreak
            // Reset point counter
            state.tieBreakPointCounter = 0
            state.tieBreak = false
        }
        
        // Points reset
        state.pointsUser = String(0)
        state.pointsOpponent = String(0)
        state.pointsUserInt = 0
        state.pointsOpponentInt = 0
    }
    
    func setReset(state: MatchState) {
        state.gamesUser = 0
        state.gamesOpponent = 0
        gameReset(state: state)
    }
    
}
