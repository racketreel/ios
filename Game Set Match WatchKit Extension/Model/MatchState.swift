//
//  MatchState.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 24/07/2021.
//

import Foundation

class MatchState: Codable {
    
    // The match event which caused this new state to be generated
    var generationEventType: MatchEventType
    
    // The timestamp when the generation event occured
    var generationEventTimestamp: TimeInterval
    
    // true: the user is serving, false: the opponent is serving
    var toServe: Bool
    
    // Score board
    var setsUser: Int
    var setsOpponent: Int
    var gamesUser: Int
    var gamesOpponent: Int
    var pointsUser: String
    var pointsOpponent: String
    
    var breakPoint: Bool
    var pointType: PointType
    
    
    init(generationEventType: MatchEventType, generationEventTimestamp: TimeInterval, toServe: Bool, setsUser: Int, setsOpponent: Int, gamesUser: Int, gamesOpponent: Int, pointsUser: String, pointsOpponent: String, breakPoint: Bool, pointType: PointType) {
        self.generationEventType = generationEventType
        self.generationEventTimestamp = generationEventTimestamp
        self.toServe = toServe
        self.setsUser = setsUser
        self.setsOpponent = setsOpponent
        self.gamesUser = gamesUser
        self.gamesOpponent = gamesOpponent
        self.pointsUser = pointsUser
        self.pointsOpponent = pointsOpponent
        self.breakPoint = breakPoint
        self.pointType = pointType
    }

    // Used to initialise the first MatchState for a game
    init(toServe: Bool) {
        self.generationEventType = MatchEventType.start
        self.generationEventTimestamp = NSDate().timeIntervalSince1970
        self.toServe = toServe
        self.setsUser = 0
        self.setsOpponent = 0
        self.gamesUser = 0
        self.gamesOpponent = 0
        self.pointsUser = "0"
        self.pointsOpponent = "0"
        self.breakPoint = false
        self.pointType = PointType.none
    }
    
}
