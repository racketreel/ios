//
//  TennisPoint.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 17/10/2021.
//

import Foundation

enum TennisPoint: Int, Codable {
    
    case Love = 0
    case Fifteen = 1
    case Thirty = 2
    case Forty = 3
    case Advantage = 4
    
    // Convert to a String for use in a scoreboard.
    var forScoreboard: String {
        switch self {
            case .Love:
                return "0"
            case .Fifteen:
                return "15"
            case .Thirty:
                return "30"
            case .Forty:
                return "40"
            case .Advantage:
                return "AD"
         }
    }
    
}
