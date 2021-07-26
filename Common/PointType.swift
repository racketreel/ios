//
//  PointType.swift
//  Game Set Match WatchKit Extension
//
//  Created by Tom Elvidge on 24/07/2021.
//

import Foundation

enum PointType: String, Codable {
    case gameFor
    case gameAgainst
    case setFor
    case setAgainst
    case matchFor
    case matchAgainst
    case none
}
