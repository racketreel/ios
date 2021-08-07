//
//  Match.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 24/07/2021.
//

import Foundation

class Match: Encodable, Identifiable, Hashable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case matchPreferences
        case history
    }
        
    let id: String 
    let matchPreferences: MatchPreferences
    var history: [MatchState]
    
    // Nested published does not cause view to reload
    @Published var currentState: MatchState
    
    init(matchPreferences: MatchPreferences) {
        self.id = UUID().uuidString
        self.matchPreferences = matchPreferences
        
        let initialState = MatchState(toServe: matchPreferences.firstServe)
        self.currentState = initialState
        self.history = [initialState]
    }
    
    static func == (lhs: Match, rhs: Match) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(matchPreferences, forKey: .matchPreferences)
        try container.encode(history, forKey: .history)
    }
    
}
