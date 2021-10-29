//
//  TennisMatch+StateDescription.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 17/10/2021.
//

import Foundation

// These belong in TennisMatch since they depend on preferences.
extension TennisMatch {
    
    func isGamePoint(to: TeamNumber, when: TennisState) -> Bool {
        // Get points for both teams.
        // Force unwraps since we will always have a score for both teams.
        let pointsTo = when.scores[to]!.points
        let pointsOpponent = when.scores[to.opponent]!.points
        
        // Different conditions when in tie break.
        if when.isTieBreak {
            // Todo: Why is this 6? Move to preferences...
            return (pointsTo >= 6) && (pointsTo >= (pointsOpponent + 1))
        } else {
            // Team is on 40 or advantage, and is at least one point ahead.
            return (pointsTo >= TennisPoint.Forty.rawValue) && ((pointsTo - pointsOpponent) >= 1)
        }
    }
    
    func isBreakpoint(when: TennisState) -> Bool {
        for team in TeamNumber.allCases {
            // Game point to a team not serving
            return self.isGamePoint(to: team, when: when) && (when.serving != team)
        }
        return false
    }
    
    func isSetPoint(to: TeamNumber, when: TennisState) -> Bool {
        // Get games for both teams.
        // Force unwraps since we will always have a score for both teams.
        let gamesTo = when.scores[to]!.games
        let gamesOpponent = when.scores[to.opponent]!.games
        
        // Must already be game point.
        let isGamePointTo = isGamePoint(to: to, when: when)
        
        // Todo: Is this different for final set tiebreak enabled/disabled?
        
        // Different conditions when in tie break or just one game per set.
        if when.isTieBreak || preferences.games == 1 {
            return isGamePointTo
        } else {
            return (
                isGamePointTo
                && (gamesTo >= (preferences.games - 1)) // One game less than the amount required to win (or more).
                && ((gamesTo - gamesOpponent) >= 1) // Opponent is at least one game behind.
            )
        }
    }
    
    func isMatchPoint(to: TeamNumber, when: TennisState) -> Bool {
        // Get sets for both teams.
        // Force unwraps since we will always have a score for both teams.
        let setsTo = when.scores[to]!.sets
        
        // Must already be set point.
        let isSetPointTo = isSetPoint(to: to, when: when)
        
        // Todo: Is this different for final set tiebreak enabled/disabled?
        
        // Team is one off the required sets to win.
        return (isSetPointTo && (setsTo == (preferences.sets - 1)))
    }
    
    func isTieBreak(when: TennisState) -> Bool {
        // Both teams have the games required to win the set.
        return (when.scores[TeamNumber.One]!.games == preferences.games) && (when.scores[TeamNumber.Two]!.games == preferences.games)
    }
    
}
