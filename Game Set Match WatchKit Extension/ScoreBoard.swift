//
//  Score.swift
//  Game Set Match WatchKit Extension
//
//  Created by Tom Elvidge on 21/07/2021.
//

import Foundation

struct ScoreBoard {
    
    var toServe: Bool
    var setsUser: Int
    var setsOpponent: Int
    var gamesUser: Int
    var gamesOpponent: Int
    // String to allow adv as point
    var pointsUser: String
    var pointsOpponent: String
    
    internal init(toServe: Bool, setsUser: Int, setsOpponent: Int, gamesUser: Int, gamesOpponent: Int, pointsUser: String, pointsOpponent: String) {
        self.toServe = toServe
        self.setsUser = setsUser
        self.setsOpponent = setsOpponent
        self.gamesUser = gamesUser
        self.gamesOpponent = gamesOpponent
        self.pointsUser = pointsUser
        self.pointsOpponent = pointsOpponent
    }
    
}
