//
//  TennisEvent.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 17/10/2021.
//

import Foundation

struct TennisEvent: Codable {
    
    // Must not be changed so let.
    let timestamp: Date
    let type: TennisEventType
    
}
