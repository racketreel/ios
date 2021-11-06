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
        createdByUserId: UUID().uuidString,
        preferences: TennisPreferences(
            sets: 2, // 3 sets total, but only 2 to win.
            games: 6,
            timestamp: Date.distantPast,
            initialServe: TeamNumber.One,
            finalSetTieBreak: false,
            pointsForTieBreak: 7,
            teams: TeamMembersWrapper(dict: [
                TeamNumber.One: Team(
                    number: TeamNumber.One,
                    membership: TeamMembershipType.Singles,
                    members: [
                        TeamMember(
                            firstname: "Tom",
                            surname: "Elvidge"
                        )
                    ]
                ),
                TeamNumber.Two: Team(
                    number: TeamNumber.Two,
                    membership: TeamMembershipType.Singles,
                    members: [
                        TeamMember(
                            firstname: "Andy",
                            surname: "Murray"
                        )
                    ]
                )
            ])
        ),
        events: []
    )
    
    static var inProgress =  TennisMatch(
        createdByUserId: UUID().uuidString,
        preferences: TennisPreferences(
            sets: 2,
            games: 6,
            timestamp: Date(),
            initialServe: TeamNumber.One,
            finalSetTieBreak: false,
            pointsForTieBreak: 7,
            teams: TeamMembersWrapper(dict: [
                TeamNumber.One: Team(
                    number: TeamNumber.One,
                    membership: TeamMembershipType.Singles,
                    members: [
                        TeamMember(firstname: "Tom", surname: "Elvidge")
                    ]
                ),
                TeamNumber.Two: Team(
                    number: TeamNumber.Two,
                    membership: TeamMembershipType.Singles,
                    members: [
                        TeamMember(firstname: "Andy", surname: "Murray")
                    ]
                )
            ])
        ),
        events: [
            TennisEvent(timestamp: Date(), type: TennisEventType.FirstServe),
            TennisEvent(timestamp: Date(), type: TennisEventType.SecondServe),
            TennisEvent(timestamp: Date(), type: TennisEventType.TeamTwoPoint)
        ]
    )
    
}
