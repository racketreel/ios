//
//  MatchEventType.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 24/07/2021.
//

import Foundation

enum MatchEventType: String, Codable {
    case win
    case loss
    case firstServe
    case secondServe
    case start
}
