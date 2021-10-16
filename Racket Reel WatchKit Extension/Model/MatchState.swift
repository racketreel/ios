//
//  MatchState.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 24/07/2021.
//

import Foundation

class MatchState: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case breakPoint
        case gamesOpponent
        case gamesUser
        case generationEventTimestamp
        case generationEvent
        case pointsOpponent
        case pointsUser
        case pointDescription
        case setsOpponent
        case setsUser
        case toServe
        case tieBreak
    }
    
    // The match event which caused this new state to be generated
    var generationEvent: GenerationEvent
    
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
    var pointDescription: PointDescription
    
    // Use alternate point scoring when set in a tie break
    var tieBreak: Bool
    // Used to track serves in tie breaks
    var tieBreakPointCounter: Int
    // Keep track of who is due to serve after the tie break
    var toServePostTieBreak: Bool
    
    // 0=0, 1=15, 2=30, 3=40, 4=adv when not in a tie break
    // using Int makes scoring easier
    var pointsUserInt: Int
    var pointsOpponentInt: Int
    
    init(generationEvent: GenerationEvent, generationEventTimestamp: TimeInterval, toServe: Bool, setsUser: Int, setsOpponent: Int, gamesUser: Int, gamesOpponent: Int, pointsUser: String, pointsOpponent: String, setTieBreak: Bool, tieBreakPointCounter: Int, toServePostTieBreak: Bool, pointsUserInt: Int, pointsOpponentInt: Int, breakPoint: Bool, pointDescription: PointDescription) {
        self.generationEvent = generationEvent
        self.generationEventTimestamp = generationEventTimestamp
        self.toServe = toServe
        self.setsUser = setsUser
        self.setsOpponent = setsOpponent
        self.gamesUser = gamesUser
        self.gamesOpponent = gamesOpponent
        self.pointsUser = pointsUser
        self.pointsOpponent = pointsOpponent
        self.breakPoint = breakPoint
        self.pointDescription = pointDescription
        self.tieBreak = setTieBreak
        self.tieBreakPointCounter = tieBreakPointCounter
        self.toServePostTieBreak = toServePostTieBreak
        self.pointsUserInt = pointsUserInt
        self.pointsOpponentInt = pointsOpponentInt
    }

    // Used to initialise the first MatchState for a game
    init(toServe: Bool) {
        self.generationEvent = GenerationEvent.Start
        self.generationEventTimestamp = NSDate().timeIntervalSince1970
        self.toServe = toServe
        self.setsUser = 0
        self.setsOpponent = 0
        self.gamesUser = 0
        self.gamesOpponent = 0
        self.pointsUser = "0"
        self.pointsOpponent = "0"
        self.breakPoint = false
        self.pointDescription = PointDescription.None
        self.tieBreak = false
        self.tieBreakPointCounter = 0
        self.toServePostTieBreak = false
        self.pointsUserInt = 0
        self.pointsOpponentInt = 0
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = MatchState(generationEvent: generationEvent, generationEventTimestamp: generationEventTimestamp, toServe: toServe, setsUser: setsUser, setsOpponent: setsOpponent, gamesUser: gamesUser, gamesOpponent: gamesOpponent, pointsUser: pointsUser, pointsOpponent: pointsOpponent, setTieBreak: tieBreak, tieBreakPointCounter: tieBreakPointCounter, toServePostTieBreak: toServePostTieBreak, pointsUserInt: pointsUserInt, pointsOpponentInt: pointsOpponentInt,  breakPoint: breakPoint, pointDescription: pointDescription)
        return copy
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(breakPoint, forKey: .breakPoint)
        try container.encode(gamesOpponent, forKey: .gamesOpponent)
        try container.encode(gamesUser, forKey: .gamesUser)
        try container.encode(generationEventTimestamp, forKey: .generationEventTimestamp)
        try container.encode(generationEvent, forKey: .generationEvent)
        try container.encode(pointsOpponentInt, forKey: .pointsOpponent)
        try container.encode(pointsUserInt, forKey: .pointsUser)
        try container.encode(pointDescription, forKey: .pointDescription)
        try container.encode(setsOpponent, forKey: .setsOpponent)
        try container.encode(setsUser, forKey: .setsUser)
        try container.encode(toServe, forKey: .toServe)
        try container.encode(tieBreak, forKey: .tieBreak)
    }
    
}
