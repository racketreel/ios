//
//  NoPersistDataProvider+MatchesPreview.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 06/11/2021.
//

import Foundation

extension NoPersistDataProvider where T == TennisMatch {
    
    convenience init() {
        // Create a test match.
        let testMatch = TennisMatch(
            createdByUserId: UUID().uuidString,
            preferences: TennisPreferences(
                sets: 1,
                games: 1,
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
                TennisEvent(timestamp: Date(), type: TennisEventType.TeamTwoPoint),
                TennisEvent(timestamp: Date(), type: TennisEventType.FirstServe),
                TennisEvent(timestamp: Date(), type: TennisEventType.TeamTwoPoint),
                TennisEvent(timestamp: Date(), type: TennisEventType.FirstServe),
                TennisEvent(timestamp: Date(), type: TennisEventType.TeamTwoPoint),
                TennisEvent(timestamp: Date(), type: TennisEventType.FirstServe),
                TennisEvent(timestamp: Date(), type: TennisEventType.TeamTwoPoint)
                
            ]
        )
        
        self.init(store: [testMatch.id: testMatch])
    }
    
}
