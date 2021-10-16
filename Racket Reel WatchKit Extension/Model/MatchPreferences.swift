//
//  MatchPreferences.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 24/07/2021.
//

import Foundation

struct MatchPreferences: Codable {
    
    enum CodingKeys: String, CodingKey {
        case setsToWin
        case gamesForSet
        case firstServe
    }

    var setsToWin: Int = 3
    var gamesForSet: Int = 6
    var firstServe: Bool = true

}
