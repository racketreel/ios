//
//  TennisMatch+StateTransition.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 17/10/2021.
//

import Foundation

// These belong in TennisMatch since they depend on preferences.
extension TennisMatch {
    
    func state(after: TennisState, when: TennisEventType) -> TennisState? {
        // Properties for the new state.
        var isSecondServe = after.isSecondServe
        var scores = after.scores
        var serving = after.serving
        var tieBreakPointCounter = after.tieBreakPointCounter
        var toServePostTieBreak = after.toServePostTieBreak
        
        // No changes to state for these events.
        if ((when == TennisEventType.FirstServe)
            || (when == TennisEventType.SecondServe)
            || (when == TennisEventType.Let)) {
            // Return early
            return TennisState(
                scores: scores,
                serving: serving,
                isSecondServe: isSecondServe,
                tieBreakPointCounter: tieBreakPointCounter,
                toServePostTieBreak: toServePostTieBreak
            )
        }
        
        if (when == TennisEventType.Fault) {
            // Fault on second serve, then serving team loses a point.
            if (after.isSecondServe) {
                // Non-serving team wins a point.
                scores = newScores(after: after, whenWonBy: after.serving.opponent)
                // Back to a first serve.
                isSecondServe = false
            } else {
                // Fault on first serve, then go to second serve.
                isSecondServe = true
            }
            
            // Return early
            return TennisState(
                scores: scores,
                serving: serving,
                isSecondServe: isSecondServe,
                tieBreakPointCounter: tieBreakPointCounter,
                toServePostTieBreak: toServePostTieBreak
            )
        }
        
        // All other possible events checked but TeamOnePoint and TeamTwoPoint.
        var pointWonBy: TeamNumber
        if (when == TennisEventType.TeamOnePoint) {
            pointWonBy = TeamNumber.One
        } else {
            pointWonBy = TeamNumber.Two
        }
        
        // Must be a first serve again.
        isSecondServe = false
        
        // If Team wins a point when on match point then match over.
        if (isMatchPoint(to: pointWonBy, when: after)) {
            // No next state.
            return nil
        }
        
        // If won on game point then switch serves.
        if (isGamePoint(to: pointWonBy, when: after)) {
            serving = after.serving.opponent
        }
        
        // Update scores
        scores = newScores(after: after, whenWonBy: pointWonBy)
        
        // Init here as we need it to check if there is a tie break.
        var newState = TennisState(
            scores: scores,
            serving: serving,
            isSecondServe: isSecondServe,
            tieBreakPointCounter: tieBreakPointCounter,
            toServePostTieBreak: toServePostTieBreak
        )
        
        // If the new state is a tie break.
        if isTieBreak(when: newState) {
            if (tieBreakPointCounter == nil) {
                // First tie break point, so set up tie break.
                tieBreakPointCounter = 0
                
                // Next team to serve gets the game after the tie break.
                toServePostTieBreak = after.serving.opponent
            } else {
                // Existing tie break, so update.
                tieBreakPointCounter = after.tieBreakPointCounter! + 1
                
                // Switch serving team after first point and then after every other point (odd points).
                if (after.tieBreakPointCounter! % 2 != 0) {
                    serving = after.serving.opponent
                }
            }
            // Overwrite the newState since tie break fields changed.
            newState = TennisState(
                scores: scores,
                serving: serving,
                isSecondServe: isSecondServe,
                tieBreakPointCounter: tieBreakPointCounter,
                toServePostTieBreak: toServePostTieBreak
            )
        }
        
        return newState
    }
    
    func newScores(after: TennisState, whenWonBy: TeamNumber) -> Dictionary<TeamNumber, TennisScore> {
        var newScores = Dictionary<TeamNumber, TennisScore>();
        
        let currentSets = after.scores[whenWonBy]!.sets
        let currentSetsOpponent = after.scores[whenWonBy.opponent]!.sets
        
        // If team wins on their set point.
        if (isSetPoint(to: whenWonBy, when: after)) {
            // Increment team's sets and reset games and points.
            newScores[whenWonBy] = TennisScore(points: 0, games: 0, sets: currentSets + 1)
            newScores[whenWonBy.opponent] = TennisScore(points: 0, games: 0, sets: currentSetsOpponent)
            // Return early
            return newScores
        }
        
        let currentGames = after.scores[whenWonBy]!.games
        let currentGamesOpponent = after.scores[whenWonBy.opponent]!.games
        
        // If team wins on their game point.
        if (isGamePoint(to: whenWonBy, when: after)) {
            // Increment team's games and reset points.
            newScores[whenWonBy] = TennisScore(points: 0, games: currentGames + 1, sets: currentSets)
            newScores[whenWonBy.opponent] = TennisScore(points: 0, games: currentGamesOpponent, sets: currentSetsOpponent)
            
            // Return early
            return newScores
        }
        
        let currentPoints = after.scores[whenWonBy]!.points
        let currentPointsOpponent = after.scores[whenWonBy.opponent]!.points
        
        
        // If opponent was on advantage (not in tie breal) put them back to 40 (deuce).
        if ((!isTieBreak(when: after))
            && (TennisPoint(rawValue: currentPointsOpponent) == TennisPoint.Advantage)
        ) {
            newScores[whenWonBy] = after.scores[whenWonBy]!
            newScores[whenWonBy.opponent] = TennisScore(points: TennisPoint.Forty.rawValue, games: currentGamesOpponent, sets: currentSetsOpponent)
            // Return early
            return newScores
        }
        
        // Just increment winning team's points.
        newScores[whenWonBy] = TennisScore(points: currentPoints + 1, games: currentGames, sets: currentSets)
        newScores[whenWonBy.opponent] = after.scores[whenWonBy.opponent]!
        return newScores
    }
    
}
