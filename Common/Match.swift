//
//  Match.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 24/07/2021.
//

import Foundation

struct Match: Codable, Identifiable, Hashable {
        
    let id: String
    
    // Match preferences
    let setsToWin: Int
    let gamesForSet: Int
    let firstServe: Bool
    
    // State history of match
    let history: [MatchState]
    
    init(setsToWin: Int, gamesForSet: Int, firstServe: Bool, history: [MatchState]) {
        self.id = UUID().uuidString
        self.setsToWin = setsToWin
        self.gamesForSet = gamesForSet
        self.firstServe = firstServe
        self.history = history
    }
    
    static func == (lhs: Match, rhs: Match) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
}
