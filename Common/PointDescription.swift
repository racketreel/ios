//
//  PointDescription.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 14/08/2021.
//

import Foundation

enum PointDescription: Int64, Codable, CustomStringConvertible {
    case None = 0
    case GameFor = 1
    case GameAgainst = 2
    case SetFor = 3
    case SetAgainst = 4
    case MatchFor = 5
    case MatchAgainst = 6
    
    var description : String {
        switch self {
            case .None: return ""
            case .GameFor: return "Game For"
            case .GameAgainst: return "Game Against"
            case .SetFor: return "Set For"
            case .SetAgainst: return "Set Against"
            case .MatchFor: return "Match For"
            case .MatchAgainst: return "Match Against"
        }
    }
    
}
