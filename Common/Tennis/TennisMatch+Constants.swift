//
//  TennisMatch+Constants.swift
//  Racket Reel Tests
//
//  Created by Tom Elvidge on 18/10/2021.
//

import Foundation

extension TennisMatch {
    
    // Do not change, used for tests.
    static var empty = TennisMatch(
        preferences: TennisPreferences(
            sets: 2, // 3 sets total, but only 2 to win.
            games: 6,
            timestamp: Date.distantPast,
            initialServe: Team.One,
            finalSetTieBreak: false,
            pointsForTieBreak: 7,
            teamType: TeamType.Singles,
            teamMembers: TeamMembersWrapper(dict: [
                Team.One: [
                    TeamMember(
                        firstname: "Tom",
                        surname: "Elvidge"
                    )
                ],
                Team.Two: [
                    TeamMember(
                        firstname: "Andy",
                        surname: "Murray"
                    )
                ]
            ])
        ),
        events: []
    )
    
}
