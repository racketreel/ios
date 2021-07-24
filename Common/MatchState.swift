//
//  MatchState.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 24/07/2021.
//

import Foundation

struct MatchState: Codable {
    
    // The match event which caused this new state to be generated
    let generationEventType: MatchEventType
    
    // The timestamp when the generation event occured
    let generationEventTimestamp: TimeInterval
    
    // true: the user is serving, false: the opponent is serving
    let toServe: Bool
    
    // Score board
    let setsUser: Int
    let setsOpponent: Int
    let gamesUser: Int
    let gamesOpponent: Int
    let pointsUser: String
    let pointsOpponent: String
    
}
