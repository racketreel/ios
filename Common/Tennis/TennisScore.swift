//
//  TennisScore.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 17/10/2021.
//

import Foundation

struct TennisScore: Equatable, Codable {
    
    let points: Int
    let games: Int
    let sets: Int
    
    func pointsToString(isTieBreak: Bool) -> String {
        return isTieBreak ? String(points) : TennisPoint.init(rawValue: points)!.forScoreboard
    }
    
}
