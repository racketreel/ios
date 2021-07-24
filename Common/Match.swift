//
//  Match.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 24/07/2021.
//

import Foundation

struct Match: Codable {
    
    // Match preferences
    let setsToWin: Int
    let gamesForSet: Int
    let firstServe: Bool
    
    // State history of match
    let history: [MatchState]
    
}
