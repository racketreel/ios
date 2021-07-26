//
//  ViewModelWatch.swift
//  Game Set Match WatchKit Extension
//
//  Created by Tom Elvidge on 23/07/2021.
//

import Foundation
import WatchConnectivity

class ViewModelWatch : NSObject, ObservableObject, WCSessionDelegate {
    
    var session: WCSession?
    
    @Published var currentView = ViewType.welcome
    
    @Published var match: MatchWatch?
    
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
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
    
    func changeView(view: ViewType) {
        self.currentView = view
    }
    
    func newMatch(matchPreferences: MatchPreferences) {
        self.match = MatchWatch(matchPreferences: matchPreferences)
    }
    
    func saveMatch() {
        // Upcast historyWatch to MatchState and set history
        match!.history = [MatchState](match!.historyWatch)
        // Encode match into json
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(match)
            print(String(data: data, encoding: .utf8)!)
            do {
                try self.session?.updateApplicationContext(["match": data])
            } catch {
                print("Something went wrong sending data")
            }
        } catch {
            print("Something went wrong encoding match")
        }
    }
    
    func applyServe() {
        let nextState = self.match!.currentState.copy() as! MatchStateWatch
        nextState.generationEventTimestamp = NSDate().timeIntervalSince1970
        
        // Set state as second serve if previous state was a first serve
        if (self.match!.currentState.generationEventType == MatchEventType.firstServe) {
            nextState.generationEventType = MatchEventType.secondServe
        }
        
        objectWillChange.send()
        self.match!.historyWatch.append(nextState)
        self.match!.currentState = nextState
    }
    
    func applyWin() {
        let currentState = self.match!.currentState
        let newState = currentState.copy() as! MatchStateWatch
        newState.generationEventTimestamp = NSDate().timeIntervalSince1970
        newState.generationEventType = MatchEventType.win
        
        if (currentState.pointType == PointType.setFor) {
            // Resolve set
            newState.setsUser += 1
            setReset(state: newState)
        } else if (currentState.pointType == PointType.gameFor) {
            // Resolve game
            newState.gamesUser += 1
            gameReset(state: newState)
        } else {
            // Score points for a win
            if currentState.setTieBreak {
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
        updatePointType(state: newState)
        
        // If state now in a tie break then keep track of who will serve after
        if isTieBreak(state: newState) {
            newState.setTieBreak = true
            newState.toServePostTieBreak = newState.toServe
        }
        
        // ViewModelWatch cannot tell that match has changed so manually notify observers that there is about to be a change in self
        objectWillChange.send()
        match!.historyWatch.append(newState)
        match!.currentState = newState
        
        // If won on match point then change to MatchOverView
        if (currentState.pointType == PointType.matchFor) {
            currentView = ViewType.matchOver
        }
    }
    
    func applyLoss() {
        let currentState = self.match!.currentState
        let newState = currentState.copy() as! MatchStateWatch
        newState.generationEventTimestamp = NSDate().timeIntervalSince1970
        newState.generationEventType = MatchEventType.loss
        
        if (currentState.pointType == PointType.setAgainst) {
            // Resolve set
            newState.setsOpponent += 1
            setReset(state: newState)
        } else if (currentState.pointType == PointType.gameAgainst) {
            // Resolve game
            newState.gamesOpponent += 1
            gameReset(state: newState)
        } else {
            // Score points for a win
            if currentState.setTieBreak {
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
        updatePointType(state: newState)
        
        // If state now in a tie break then keep track of who will serve after
        if isTieBreak(state: newState) {
            newState.setTieBreak = true
            newState.toServePostTieBreak = newState.toServe
        }
        
        // ViewModelWatch cannot tell that match has changed so manually notify observers that there is about to be a change in self
        objectWillChange.send()
        match!.historyWatch.append(newState)
        match!.currentState = newState
        
        // If opponent won on match point then change to MatchOverView
        if (currentState.pointType == PointType.matchAgainst) {
            currentView = ViewType.matchOver
        }
    }
    
    func undo() {
        if (match!.historyWatch.count > 1) {
            objectWillChange.send()
            match!.historyWatch.removeLast()
            match!.currentState = match!.historyWatch.last!
        }
    }
    
    private func updatePointType(state: MatchStateWatch) {
        state.pointType = PointType.none
        state.breakPoint = false
        
        let gamePointTo = gamePointTo(state: state)
        state.breakPoint = isBreakPoint(state: state, gamePointTo: gamePointTo)
        
        let setPointTo = setPointTo(state: state, gamePointTo: gamePointTo)
        let matchPointTo = matchPointTo(state: state, setPointTo: setPointTo)
        
        if (matchPointTo == PlayerType.user) {
            state.pointType = PointType.matchFor
        }
        if (matchPointTo == PlayerType.opponent) {
            state.pointType = PointType.matchAgainst
        }
        if (matchPointTo == PlayerType.neither) {
            if (setPointTo == PlayerType.user) {
                state.pointType = PointType.setFor
            }
            if (setPointTo == PlayerType.opponent) {
                state.pointType = PointType.setAgainst
            }
            if (setPointTo == PlayerType.neither) {
                if (gamePointTo == PlayerType.user) {
                    state.pointType = PointType.gameFor
                }
                if (gamePointTo == PlayerType.opponent) {
                    state.pointType = PointType.gameAgainst
                }
            }
        }
    }
    
    private func isTieBreak(state: MatchStateWatch) -> Bool {
        let gamesForSet = match?.matchPreferences.gamesForSet
        return (state.gamesUser == gamesForSet && state.gamesOpponent == gamesForSet)
    }
    
    private func isBreakPoint(state: MatchStateWatch, gamePointTo: PlayerType) -> Bool {
        // User or opponent on game point but not serving
        if ((gamePointTo == PlayerType.user && state.toServe == false)
                || (gamePointTo == PlayerType.opponent && state.toServe == true)) {
            return true
        }
        return false
    }
    
    private func gamePointTo(state: MatchStateWatch) -> PlayerType {
        if state.setTieBreak {
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
    
    private func setPointTo(state: MatchStateWatch, gamePointTo: PlayerType) -> PlayerType {
        // Different condition when in tie break
        if state.setTieBreak {
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
    
    private func matchPointTo(state: MatchStateWatch, setPointTo: PlayerType) -> PlayerType {
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
    
    func gameReset(state: MatchStateWatch) {
        // Swap serve
        state.toServe = !state.toServe
        
        // Additional reset steps if was a tie break
        if state.setTieBreak {
            // Restore next serve from var
            state.toServe = state.toServePostTieBreak
            // Reset point counter
            state.tieBreakPointCounter = 0
            state.setTieBreak = false
        }
        
        // Points reset
        state.pointsUser = String(0)
        state.pointsOpponent = String(0)
        state.pointsUserInt = 0
        state.pointsOpponentInt = 0
    }
    
    func setReset(state: MatchStateWatch) {
        state.gamesUser = 0
        state.gamesOpponent = 0
        gameReset(state: state)
    }
    
}
