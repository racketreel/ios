//
//  TennisState.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 17/10/2021.
//

import Foundation

class TennisState {
    
    let scores: Dictionary<Team, TennisScore>
    
    let serving: Team
    let isSecondServe: Bool
    
    // Use alternate point scoring when set in a tie break.
    // Counter needed to track serves in tie breaks.
    let tieBreakPointCounter: Int?
    
    var isTieBreak: Bool {
        // Not in a tie break if we are not counting tie break points.
        return tieBreakPointCounter != nil
    }
    
    // Keep track of who is due to serve after the tie break.
    let toServePostTieBreak: Team?
    
    init(scores: Dictionary<Team, TennisScore>, serving: Team, isSecondServe: Bool, tieBreakPointCounter: Int?, toServePostTieBreak: Team?) {
        self.scores = scores
        self.serving = serving
        self.isSecondServe = isSecondServe
        self.tieBreakPointCounter = tieBreakPointCounter
        self.toServePostTieBreak = toServePostTieBreak
    }
    
}
