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
    
    // Change generationEvent_ Int64 from CoreData into Enum
    var generationEvent: GenerationEvent {
        get {
            return GenerationEvent(rawValue: generationEvent_) ?? GenerationEvent.Unknown
        }
        set {
            generationEvent_ = newValue.rawValue
        }
    }
    
    // Change pointDescription_ Int64 from CoreData into Enum
    var pointDescription: PointDescription {
        get {
            return PointDescription(rawValue: pointDescription_) ?? PointDescription.None
        }
        set {
            pointDescription_ = newValue.rawValue
        }
    }
    
    // Computed properties for points to convert Int64 to String
    
    var pointsOpponent: String {
        get {
            if tieBreak {
                return String(pointsOpponent_)
            } else {
                return pointIntStringMap[Int(pointsOpponent_)] ?? "??"
            }
        }
    }
    
    var pointsUser: String {
        get {
            if tieBreak {
                return String(pointsUser_)
            } else {
                return pointIntStringMap[Int(pointsUser_)] ?? "??"
            }
        }
    }
    
}

