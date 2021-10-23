//
//  MiscTests.swift
//  Racket Reel Tests
//
//  Created by Tom Elvidge on 17/10/2021.
//

import XCTest
@testable import Racket_Reel

class MiscTests: XCTestCase {

    func testInitialState() {
        // Force unwrap since set up before every test.
        let match = TennisMatch.empty
        let state = match.initialState
        
        XCTAssert(state.isSecondServe == false, "Initial state should be at a first serve.")
        XCTAssert(state.isTieBreak == false, "Initial state should not be in a tie break.")
        XCTAssert(state.tieBreakPointCounter == nil, "Initial state should not be in a tie break.")
        XCTAssert(state.toServePostTieBreak == nil, "Initial state should not be in a tie break.")
        
        XCTAssert(state.scores[Team.One]!.points == 0, "Team one should have no points in the initial state.")
        XCTAssert(state.scores[Team.Two]!.points == 0, "Team two should have no points in the initial state.")
        XCTAssert(state.scores[Team.One]!.games == 0, "Team one should have no games in the initial state.")
        XCTAssert(state.scores[Team.Two]!.games == 0, "Team two should have no games in the initial state.")
        XCTAssert(state.scores[Team.One]!.sets == 0, "Team one should have no sets in the initial state.")
        XCTAssert(state.scores[Team.Two]!.sets == 0, "Team two should have no sets in the initial state.")
    }
    
    func testInitialStateServingDependsOnPreferences() {
        for team in Team.allCases {
            var teamMembers = Dictionary<Team, [TeamMember]>()
            teamMembers[Team.One] = [TeamMember(firstname: "Tom", surname: "Elvidge")]
            teamMembers[Team.Two] = [TeamMember(firstname: "John", surname: "Smith")]
            
            let preferences = TennisPreferences(
                sets: 1,
                games: 6,
                timestamp: Date.now,
                initialServe: team,
                finalSetTieBreak: false,
                pointsForTieBreak: 7,
                teamType: TeamType.Singles,
                teamMembers: TeamMembersWrapper(dict: teamMembers)
            )
            
            let match = TennisMatch(preferences: preferences, events: [])
            
            XCTAssert(match.initialState.serving == match.preferences.initialServe, "The initialState.serving team should be set from preferences.initialServe.")
        }
    }
    
}
