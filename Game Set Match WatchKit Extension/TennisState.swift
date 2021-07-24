//
//  TennisState.swift
//  Game Set Match WatchKit Extension
//
//  Created by Tom Elvidge on 21/07/2021.
//

import Foundation

class TennisState: Codable {
    
    // The event type which caused this state to be generated
    var generationEventType: MatchEventType
    // The timestamp of the generation event
    var generationEventTimestamp: TimeInterval
    
    // Used to export the state to a ScoreBoard
    // Don't decode/encode by default as immutable
    private let pointMapping = [
        0: "0",
        1: "15",
        2: "30",
        3: "40",
        4: "AD"
    ]
    
    // State
    
    // true: the user is serving, false: the opponent is serving
    var toServe: Bool
    
    // Use alternate point scoring when set in a tie break
    var setTieBreak: Bool
    // Used to track serves in tie breaks
    var tieBreakPointCounter: Int
    // Keep track of who is due to serve after the tie break
    var toServePostTieBreak: Bool
    
    // Score board
    var setsUser: Int
    var setsOpponent: Int
    var gamesUser: Int
    var gamesOpponent: Int
    // 0=0, 1=15, 2=30, 3=40, 4=adv when not in a tie break
    var pointsUser: Int
    var pointsOpponent: Int

    // Called to create the TennisState for game start
    init(toServe: Bool) {
        self.generationEventType = MatchEventType.start
        self.generationEventTimestamp = NSDate().timeIntervalSince1970
        self.toServe = toServe
        self.setTieBreak = false
        self.tieBreakPointCounter = 0
        // Does not matter as it will be set at the start of a tie break
        self.toServePostTieBreak = false
        self.setsUser = 0
        self.setsOpponent = 0
        self.gamesUser = 0
        self.gamesOpponent = 0
        self.pointsUser = 0
        self.pointsOpponent = 0
    }
    
    convenience init() {
        // User serves first if none given.
        self.init(toServe: true)
    }
    
    func copy() -> TennisState {
        let state = TennisState()
        state.generationEventType = self.generationEventType
        state.generationEventTimestamp = self.generationEventTimestamp
        state.toServe = self.toServe
        state.setTieBreak = self.setTieBreak
        state.tieBreakPointCounter = self.tieBreakPointCounter
        state.toServePostTieBreak = self.toServePostTieBreak
        state.setsUser = self.setsUser
        state.setsOpponent = self.setsOpponent
        state.gamesUser = self.gamesUser
        state.gamesOpponent = self.gamesOpponent
        state.pointsUser = self.pointsUser
        state.pointsOpponent = self.pointsOpponent
        return state
    }
    
    func exportScoreBoard() -> ScoreBoard {
        // Use scoring 0, 15, 30, 40, ADV when not in a tie break
        if !setTieBreak {
            let parsedPointsUser = String(pointMapping[pointsUser] ?? "ERR")
            let parsedPointsOpponent = String(pointMapping[pointsOpponent] ?? "ERR")
            return ScoreBoard(toServe: self.toServe, setsUser: self.setsUser, setsOpponent: self.setsOpponent, gamesUser: self.gamesUser, gamesOpponent: self.gamesOpponent, pointsUser: parsedPointsUser, pointsOpponent: parsedPointsOpponent)
        }
        // Use scoring 0, 1, 2, etc when in a tie break
        return ScoreBoard(toServe: self.toServe, setsUser: self.setsUser, setsOpponent: self.setsOpponent, gamesUser: self.gamesUser, gamesOpponent: self.gamesOpponent, pointsUser: String(self.pointsUser), pointsOpponent: String(self.pointsOpponent))
    }
    
    func getGamePointTo() -> PlayerType {
        if self.setTieBreak {
            // User on 6 or more points
            // and at least one point ahead
            if (self.pointsUser >= 6 && self.pointsUser >= (self.pointsOpponent + 1)) {
                return PlayerType.user
            }

            // Vice versa for opponent
            if (self.pointsOpponent >= 6 && self.pointsOpponent >= (self.pointsUser + 1)) {
                return PlayerType.opponent
            }
        } else {
            // User on 40 or advantage and opponent at least one point behind
            if (self.pointsUser >= 3
                    && (self.pointsUser - self.pointsOpponent) >= 1) {
                return PlayerType.user
            }
            
            // Vice versa for opponent
            if (self.pointsOpponent >= 3
                    && (self.pointsOpponent - self.pointsUser) >= 1) {
                return PlayerType.opponent
            }
        }
        
        return PlayerType.neither
    }
    
    func getSetPointTo(gamesForSet: Int) -> PlayerType {
        // Different condition when in tie break
        if setTieBreak {
            // Just comes down to the tie break (game)
            return self.getGamePointTo()
        } else {
            // User has game point condition
            // and has at least one game less than the amount to win the set
            // and opponent at least one game behind
            if (self.getGamePointTo() == PlayerType.user
                    &&  self.gamesUser >= (gamesForSet - 1)
                    && (self.gamesUser - self.gamesOpponent) >= 1) {
                return PlayerType.user
            }
            
            // Vice versa for opponent
            if (self.getGamePointTo() == PlayerType.opponent
                    && self.gamesOpponent >= (gamesForSet - 1)
                    && (self.gamesOpponent - self.gamesUser) >= 1) {
                return PlayerType.opponent
            }
        }
        
        return PlayerType.neither
    }
    
    func getMatchPointTo(gamesForSet: Int, setsToWin: Int) -> PlayerType {
        // User has set point condition and is one off the sets required for the match
        if (self.getSetPointTo(gamesForSet: gamesForSet) == PlayerType.user
                && self.setsUser == (setsToWin - 1)) {
            return PlayerType.user
        }
        
        // Vice versa for opponent
        if (self.getSetPointTo(gamesForSet: gamesForSet) == PlayerType.opponent
                && self.setsOpponent == (setsToWin - 1)) {
            return PlayerType.opponent
        }
        
        return PlayerType.neither
    }
    
    func getBreakPointTo() -> PlayerType {
        // User on game point and not serving
        if (getGamePointTo() == PlayerType.user && self.toServe == false) {
            return PlayerType.user
        }
        
        if (getGamePointTo() == PlayerType.opponent && self.toServe == true) {
            return PlayerType.opponent
        }
        
        return PlayerType.neither
    }
    
    func isTieBreak(gamesForSet: Int) -> Bool {
        if (self.gamesUser == gamesForSet && self.gamesOpponent == gamesForSet) {
            return true
        }
        return false
    }
    
    func gameReset() {
        // Swap serve
        self.toServe = !self.toServe
        
        // Additional reset steps if was a tie break
        if self.setTieBreak {
            // Restore next serve from var
            self.toServe = self.toServePostTieBreak
            // Reset point counter
            self.tieBreakPointCounter = 0
            self.setTieBreak = false
        }
        
        // Points reset
        self.pointsUser = 0
        self.pointsOpponent = 0
    }
    
    func setReset() {
        self.gamesUser = 0
        self.gamesOpponent = 0
    }
    
    func describe() -> String {
        return "\(self.generationEventType) - \(self.generationEventTimestamp)"
    }
    
    func export() -> MatchState {
        let scoreBoard = exportScoreBoard()
        return MatchState(generationEventType: self.generationEventType, generationEventTimestamp: self.generationEventTimestamp, toServe: self.toServe, setsUser: self.setsUser, setsOpponent: self.setsOpponent, gamesUser: self.gamesUser, gamesOpponent: self.gamesOpponent, pointsUser: scoreBoard.pointsUser, pointsOpponent: scoreBoard.pointsOpponent)
    }
    
}
