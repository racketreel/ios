//
//  GenerationEvent.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 14/08/2021.
//

import Foundation

enum GenerationEvent: String, CustomStringConvertible {
    
    case Start = "start"
    case FirstServe = "firstServe"
    case SecondServe = "secondServe"
    case Win = "win"
    case Loss = "loss"
    case Unknown = "unknown"
    
    var description : String {
        switch self {
            case .Start: return "Start"
            case .FirstServe: return "First Serve"
            case .SecondServe: return "Second Serve"
            case .Win: return "Win"
            case .Loss: return "Loss"
            case .Unknown: return "Unknown"
        }
    }
    
}
