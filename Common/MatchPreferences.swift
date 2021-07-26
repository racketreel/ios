//
//  MatchPreferences.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 24/07/2021.
//

import Foundation

struct MatchPreferences: Codable {

    var setsToWin: Int = 3
    var gamesForSet: Int = 6
    var firstServe: Bool = true

}
