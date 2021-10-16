//
//  Match+Helper.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 14/08/2021.
//

import Foundation

// Unwrap optionals from CoreData model into non-optionals
extension Match {
    
    public var id: String {
        get {
            return id_ ?? ""
        }
        set {
            id_ = newValue
        }
    }
    
    var history: Array<MatchState> {
        get {
            return history_?.array as? Array<MatchState> ?? []
        }
        set {
            history_ = NSOrderedSet(array: newValue)
        }
    }
    
    var matchPreferences: MatchPreferences {
        get {
            return matchPreferences_ ?? MatchPreferences()
        }
        set {
            matchPreferences_ = newValue
        }
    }
    
    // Computed name for displaying in UI
    var name: String {
        get {
            if (history.count > 0) {
                // Parse timestamp into Date
                let startTimestamp = history[0].generationEventTimestamp
                let startDate = Date(timeIntervalSince1970: TimeInterval(startTimestamp))
                // Format Date into a custom string and return
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d MMM y (HH:mm)"
                return dateFormatter.string(from: startDate)
            } else {
                return "No Start Date"
            }
        }
    }
    
}
