//
//  Game.swift
//  Game Set Match WatchKit Extension
//
//  Created by Tom Elvidge on 18/07/2021.
//

import Foundation

class Game: ObservableObject {
        
    // Game preferences
    private let setsToWin: Int
    private let gamesForSet: Int
    private let firstServe: Bool
    
    // Keep track of the game state history
    private var stateHistory: [TennisState]
    
    // "" if game in progress
    @Published var winner: String
    
    // Display the score board
    @Published var scoreBoard: ScoreBoard
    
    init (setsToWin: Int, gamesForSet: Int, firstServe: Bool) {
        // Set game preferences
        self.setsToWin = setsToWin
        self.gamesForSet = gamesForSet
        self.firstServe = firstServe
        
        // Create initial TennisState and history
        self.stateHistory = []
        self.stateHistory.append(TennisState(toServe: firstServe))
        
        // Create score board from the current state
        // Use bang as the state history will always have the initial state
        self.scoreBoard = self.stateHistory.last!.exportScoreBoard()
        
        // winner = "" when game in progress
        self.winner = ""
    }
    
    func undoLastEvent() {
        // Todo: Undo point vs undo event, so should we also undo serves?
        // Do not allow removal of the initial state
        if (self.stateHistory.count > 1) {
            self.stateHistory.removeLast()
            
            // Update the score board
            self.scoreBoard = self.stateHistory.last!.exportScoreBoard()
        }
    }
    
    func newEvent(event: MatchEventType) {
        // Get current state from end of history
        // Use bang as there will alsways be at least the initial state
        let currentState = self.stateHistory.last!
        
        // Create new state from current state
        let newState = currentState.copy()
        newState.generationEventType = event
        newState.generationEventTimestamp = NSDate().timeIntervalSince1970
        
        // Update newState using currentState and event
        
        // firstServe always passed by Button, check not actually secondServe
        if (event == MatchEventType.firstServe
                && currentState.generationEventType == MatchEventType.firstServe) {
            newState.generationEventType = MatchEventType.secondServe
        }
        
        if (event == MatchEventType.win || event == MatchEventType.loss) {
            // Different scoring when in a tie break
            if currentState.setTieBreak {
                newState.tieBreakPointCounter += 1
                
                // Switch serve after first point and then after every other point (i.e. odd points)
                if (newState.tieBreakPointCounter % 2 != 0) {
                    newState.toServe = !newState.toServe
                }

                if (event == MatchEventType.win) {
                    newState.pointsUser += 1
                }
                
                if (event == MatchEventType.loss) {
                    newState.pointsOpponent += 1
                }
            } else {
                // No tie break so score normally
                if (event == MatchEventType.win) {
                    // If opponent was on advantage put it back to duece
                    if (currentState.pointsOpponent == 4) {
                        newState.pointsOpponent -= 1
                    } else {
                        // Otherwise just increment points
                        newState.pointsUser += 1
                    }
                }
                if (event == MatchEventType.loss) {
                    // If user was on advantage put it back to duece
                    if (currentState.pointsUser == 4) {
                        newState.pointsUser -= 1
                    } else {

                        // Otherwise just increment points
                        newState.pointsOpponent += 1
                    }
                }
            }
            
            // Resolve game
            let gamePointTo: PlayerType = currentState.getGamePointTo()
            // Game win
            if (gamePointTo == PlayerType.user && event == MatchEventType.win) {
                newState.gamesUser += 1
                newState.gameReset()
                
            }
            // Game loss
            if (gamePointTo == PlayerType.opponent && event == MatchEventType.loss) {
                newState.gamesOpponent += 1
                newState.gameReset()
            }
            
            // Resolve set
            let setPointTo: PlayerType = currentState.getSetPointTo(gamesForSet: self.gamesForSet)
            // Set win
            if (setPointTo == PlayerType.user && event == MatchEventType.win) {
                newState.setsUser += 1
                newState.setReset()
            }
            // Set loss
            if (setPointTo == PlayerType.opponent && event == MatchEventType.loss) {
                newState.setsOpponent += 1
                newState.setReset()
            }
            
            // Resolve match
            let matchPointTo: PlayerType = currentState.getMatchPointTo(gamesForSet: self.gamesForSet, setsToWin: self.setsToWin)
            // Match win!
            if (matchPointTo == PlayerType.user && event == MatchEventType.win) {
                self.winner = "user"
            }
            // Match loss...
            if (matchPointTo == PlayerType.opponent && event == MatchEventType.loss) {
                self.winner = "opponent"
            }
            
            // If state now in a tie break then keep track of who will serve after
            if newState.isTieBreak(gamesForSet: self.gamesForSet) {
                newState.setTieBreak = true
                newState.toServePostTieBreak = newState.toServe
            }
            
            // Update the score board
            self.scoreBoard = newState.exportScoreBoard()
        }
        
        // Debug
        // print(newState.describe())
        
        // Add the fully updated new state to history
        self.stateHistory.append(newState)
    }
    
    func export() -> Match {
        var history = [MatchState]()
        for state in stateHistory {
            history.append(state.export())
        }
        return Match(setsToWin: self.setsToWin, gamesForSet: self.gamesForSet, firstServe: self.firstServe, history: history)
    }
    
}
