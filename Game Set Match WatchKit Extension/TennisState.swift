//
//  TennisState.swift
//  Game Set Match WatchKit Extension
//
//  Created by Tom Elvidge on 21/07/2021.
//

import Foundation

class TennisState {
    
    // The event type which caused this state to be generated
    private var generationEventType: TennisEventType
    // The timestamp of the generation event
    private var generationEventTimestamp: TimeInterval
    
    // Used to export the state to a ScoreBoard
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
        self.generationEventType = TennisEventType.start
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
    
}
