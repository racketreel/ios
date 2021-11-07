//
//  Team.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 17/10/2021.
//

import Foundation

enum TeamNumber: String, CaseIterable, Codable {
    
    case One = "TEAM_ONE"
    case Two = "TEAM_TWO"
    
    var opponent: TeamNumber {
        if (self == TeamNumber.One) {
            return TeamNumber.Two
        } else {
            return TeamNumber.One
        }
    }
    
}
