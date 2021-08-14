//
//  MatchState+Helper.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 14/08/2021.
//

import Foundation


// Unwrap optionals from CoreData model into non-optionals
// Change Int64 from CoreData into Enum where needed
extension MatchState {
    
    var generationEvent: GenerationEvent {
        get {
            return GenerationEvent(rawValue: generationEvent_) ?? GenerationEvent.Unknown
        }
        set {
            generationEvent_ = newValue.rawValue
        }
    }
    
    var pointsOpponent: String {
        get {
            return pointsOpponent_ ?? "NA"
        }
        set {
            pointsOpponent_ = newValue
        }
    }
    
    var pointsUser: String {
        get {
            return pointsUser_ ?? "NA"
        }
        set {
            pointsUser_ = newValue
        }
    }
    
    var pointDescription: PointDescription {
        get {
            return PointDescription(rawValue: pointDescription_) ?? PointDescription.None
        }
        set {
            pointDescription_ = newValue.rawValue
        }
    }
    
}
