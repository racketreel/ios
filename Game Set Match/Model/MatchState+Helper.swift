//
//  MatchState+Helper.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 14/08/2021.
//

import Foundation


// Unwrap optionals from CoreData model into non-optionals
extension MatchState {
    
    var generationEventType: GenerationEvent {
        get {
            return GenerationEvent(rawValue: generationEventType_!) ?? GenerationEvent.Unknown
        }
        set {
            generationEventType_ = newValue.rawValue
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
    
    var pointType: PointDescription {
        get {
            return PointDescription(rawValue: pointType_!) ?? PointDescription.None
        }
        set {
            pointType_ = newValue.rawValue
        }
    }
    
}
