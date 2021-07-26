//
//  MatchStateWatch.swift
//  Game Set Match WatchKit Extension
//
//  Created by Tom Elvidge on 24/07/2021.
//

import Foundation

// Additional variables needed on Watch app to allow scoring logic
class MatchStateWatch: MatchState, NSCopying {
    
    // Use alternate point scoring when set in a tie break
    var setTieBreak: Bool
    // Used to track serves in tie breaks
    var tieBreakPointCounter: Int
    // Keep track of who is due to serve after the tie break
    var toServePostTieBreak: Bool
    
    // 0=0, 1=15, 2=30, 3=40, 4=adv when not in a tie break
    // using Int makes scoring easier
    var pointsUserInt: Int
    var pointsOpponentInt: Int
    
    internal init(generationEventType: MatchEventType, generationEventTimestamp: TimeInterval, toServe: Bool, setsUser: Int, setsOpponent: Int, gamesUser: Int, gamesOpponent: Int, pointsUser: String, pointsOpponent: String, setTieBreak: Bool, tieBreakPointCounter: Int, toServePostTieBreak: Bool, pointsUserInt: Int, pointsOpponentInt: Int, breakPoint: Bool, pointType: PointType) {
        self.setTieBreak = setTieBreak
        self.tieBreakPointCounter = tieBreakPointCounter
        self.toServePostTieBreak = toServePostTieBreak
        self.pointsUserInt = pointsUserInt
        self.pointsOpponentInt = pointsOpponentInt
        super.init(generationEventType: generationEventType, generationEventTimestamp: generationEventTimestamp, toServe: toServe, setsUser: setsUser, setsOpponent: setsOpponent, gamesUser: gamesUser, gamesOpponent: gamesOpponent, pointsUser: pointsUser, pointsOpponent: pointsOpponent, breakPoint: breakPoint, pointType: pointType)
    }
    
    override init(toServe: Bool) {
        // Not initially in a tie break
        self.setTieBreak = false
        self.tieBreakPointCounter = 0
        self.toServePostTieBreak = false
        
        self.pointsUserInt = 0
        self.pointsOpponentInt = 0
        
        super.init(toServe: toServe)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = MatchStateWatch(generationEventType: generationEventType, generationEventTimestamp: generationEventTimestamp, toServe: toServe, setsUser: setsUser, setsOpponent: setsOpponent, gamesUser: gamesUser, gamesOpponent: gamesOpponent, pointsUser: pointsUser, pointsOpponent: pointsOpponent, setTieBreak: setTieBreak, tieBreakPointCounter: tieBreakPointCounter, toServePostTieBreak: toServePostTieBreak, pointsUserInt: pointsUserInt, pointsOpponentInt: pointsOpponentInt,  breakPoint: breakPoint, pointType: pointType)
        return copy
    }
    
}
