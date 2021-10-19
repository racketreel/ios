//
//  TennisMatch.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 17/10/2021.
//

import Foundation

class TennisMatch {
    
    // Todo: Validation?
    
    public var inProgress: Bool {
        get {
            return _inProgress
        }
    }
    
    private var _inProgress = false
    
    // You must not change the preferences after the match so let.
    let preferences: TennisPreferences
    
    // This can be changed after the match to enable editing videos.
    // TennisEvent objects cannot be modified directly but they can be removed and new ones added.
    var events: [TennisEvent] {
        didSet {
            // Do not reset _states with each event if events are still being logged.
            // States can be added sequentially when still logging (match in progress).
            if (!self._inProgress) {
                // _states depends on preferences, so no longer valid, set back to nil.
                self._states = nil
            }
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
    
    convenience init(preferences: TennisPreferences) {
        self.init(preferences: preferences, events: [])
    }
    
}

// Live Logging Functions
extension TennisMatch {
    
    func startMatch() throws {
        if (self._inProgress || (self._states != nil) || (!self.events.isEmpty)) {
            // Todo: Custom errors for each of these conditions.
            throw TennisLoggingError.matchHasAlreadyStarted
        }
        
        self._inProgress = true
        // Add the initial state.
        self._states = [initialState]
    }
    
    func logEvent(_ event: TennisEventType) throws {
        if !self._inProgress {
            // Do not allow event logging after the match.
            throw TennisLoggingError.matchNotInProgress
        }
        
        // Ensure _states is not nil before doing anything.
        if (self._states == nil) {
            throw TennisLoggingError.statesNilDuringMatch
        }
        
        // Add the event.
        self.events.append(
            TennisEvent(timestamp: Date(), type: event)
        )
        
        // Compute the next state.
        let lastState = self.states.last!
        let nextState = self.state(after: lastState, when: event)
        
        // Next state is nil then the match is over.
        if (nextState == nil) {
            self._inProgress = false
            return
        }
        
        // Add the next state. Force unwraps as neither can be nil now.
        self._states!.append(nextState!)
    }
    
    func undoLastEvent() throws {
        if !self._inProgress {
            // Do not allow event logging after the match.
            throw TennisLoggingError.matchNotInProgress
        }
        
        // Ensure _states is not nil before doing anything.
        if (self._states == nil) {
            throw TennisLoggingError.statesNilDuringMatch
        }
        
        // More than one state (cannot remove initial state) and at least one event.
        if ((self._states!.count > 1) && (!self.events.isEmpty)) {
            self._states!.removeLast()
            self.events.removeLast()
        } else {
            throw TennisLoggingError.noEventsToUndo
        }
    }
    
}