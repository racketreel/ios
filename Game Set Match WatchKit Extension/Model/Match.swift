//
//  Match.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 24/07/2021.
//

import Foundation

class Match: Codable, Identifiable, Hashable {
        
    let id: String 
    let matchPreferences: MatchPreferences
    var history: [MatchState]
    
    init(matchPreferences: MatchPreferences, history: [MatchState]) {
        self.id = UUID().uuidString
        self.matchPreferences = matchPreferences
        self.history = history
    }
    
    init(matchPreferences: MatchPreferences) {
        self.id = UUID().uuidString
        self.matchPreferences = matchPreferences
        self.history = [MatchState(toServe: matchPreferences.firstServe)]
    }
    
    static func == (lhs: Match, rhs: Match) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
}
