//
//  GenerationEvent.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 14/08/2021.
//

import Foundation

enum GenerationEvent: Int64, Codable, CustomStringConvertible {
    
    case Unknown = 0
    case Start = 1
    case FirstServe = 2
    case SecondServe = 3
    case Win = 4
    case Loss = 5
    
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
