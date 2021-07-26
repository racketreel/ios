//
//  MatchWatch.swift
//  Game Set Match WatchKit Extension
//
//  Created by Tom Elvidge on 24/07/2021.
//

import Foundation

class MatchWatch: Match {
    
    var historyWatch: [MatchStateWatch]
    
    // Nested published doesnt cause view to reload
    @Published var currentState: MatchStateWatch
    
    override init(matchPreferences: MatchPreferences) {
        let initialState = MatchStateWatch(toServe: true)
        currentState = initialState
        // Must copy historyWatch to history with a downcast before encoding
        historyWatch = [initialState]
        
        super.init(matchPreferences: matchPreferences)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented. Only parent Match should be decoded.")
    }
    
}
