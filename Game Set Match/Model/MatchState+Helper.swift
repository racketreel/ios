//
//  MatchState+Helper.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 14/08/2021.
//

import Foundation


// Unwrap optionals from CoreData model into non-optionals
extension MatchState {
    
    var generationEventType: String {
        get {
            return generationEventType_ ?? "none"
        }
        set {
            generationEventType_ = newValue
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
    
    var pointType: String {
        get {
            return pointType_ ?? "none"
        }
        set {
            pointType_ = newValue
        }
    }
    
}
