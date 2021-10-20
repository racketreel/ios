//
//  TennisPreferences.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 17/10/2021.
//

import Foundation

struct TennisPreferences: Codable {
    
    // You must not change the preferences after the match so let.
    let sets: Int // Sets needed to win the match
    let games: Int // Games needed to win the set without any ties
    let timestamp: Date // Start time of the match
    let initialServe: Team
    let finalSetTieBreak: Bool
    let pointsForTieBreak: Int
    let teamType: TeamType
    
    // No harm in changing team members after the match so var.
    var teamMembers: TeamMembersWrapper
    
}
