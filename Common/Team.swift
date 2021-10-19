//
//  Team.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 17/10/2021.
//

import Foundation

enum Team: String, CaseIterable, Codable {
    
    case One = "TEAM_ONE"
    case Two = "TEAM_TWO"
    
    var opponent: Team {
        if (self == Team.One) {
            return Team.Two
        } else {
            return Team.One
        }
    }
    
}
