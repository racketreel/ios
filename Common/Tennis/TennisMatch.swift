//
//  TennisMatch.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 17/10/2021.
//

import Foundation

class TennisMatch {
    
    // Todo: Validation?
    
    // You must not change the preferences after the match so let.
    let preferences: TennisPreferences
    
    // This can be changed after the match to enable editing videos.
    // TennisEvent objects cannot be modified directly but they can be removed and new ones added.
    var events: [TennisEvent] {
        didSet {
            // _states depends on preferences, so no longer valid, set back to nil.
            self._states = nil
        }
    }
    
    // Computed from preferences, only needs to be done once since preferences is immutable.
    // Using lazy var with a closure allows safe access to self after initialization.
    lazy var initialState: TennisState = {
        let initialScore = TennisScore(points: 0, games: 0, sets: 0)
        
        var scores = Dictionary<Team, TennisScore>()
        scores[Team.One] = initialScore
        scores[Team.Two] = initialScore
        
        return TennisState(
            scores: scores,
            serving: self.preferences.initialServe,
            isSecondServe: false,
            tieBreakPointCounter: nil,
            toServePostTieBreak: nil
        )
    }()
    
    // Initialize states on demand since expensive to compute.
    var states: [TennisState] {
        if (self._states == nil) {
            self.updateStates()
        }
        return self._states!
    }
    
    // Depends on preferences and events, so if either changes set this back to nil.
    private var _states: [TennisState]?
    
    private func updateStates(){
        var lastState = self.initialState
        var states: [TennisState] = [lastState]
        
        for event in self.events {
            let newState = self.state(after: lastState, when: event.type)
            // newState is nil if match is over
            if (newState != nil) {
                states.append(newState!)
                lastState = newState!
            }
        }
        
        self._states = states
    }
    
    init(preferences: TennisPreferences, events: [TennisEvent]) {
        self.preferences = preferences
        self.events = events
    }
    
}
