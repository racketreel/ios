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
        
        XCTAssert(state.scores[TeamNumber.One]!.points == 0, "Team one should have no points in the initial state.")
        XCTAssert(state.scores[TeamNumber.Two]!.points == 0, "Team two should have no points in the initial state.")
        XCTAssert(state.scores[TeamNumber.One]!.games == 0, "Team one should have no games in the initial state.")
        XCTAssert(state.scores[TeamNumber.Two]!.games == 0, "Team two should have no games in the initial state.")
        XCTAssert(state.scores[TeamNumber.One]!.sets == 0, "Team one should have no sets in the initial state.")
        XCTAssert(state.scores[TeamNumber.Two]!.sets == 0, "Team two should have no sets in the initial state.")
    }
    
    func testInitialStateServingDependsOnPreferences() {
        for team in TeamNumber.allCases {
            var teams = Dictionary<TeamNumber, Team>()
            teams[TeamNumber.One] = Team(
                number: TeamNumber.One,
                membership: TeamMembershipType.Singles,
                members: []
            )
            teams[TeamNumber.Two] = Team(
                number: TeamNumber.Two,
                membership: TeamMembershipType.Singles,
                members: []
            )
            
            let preferences = TennisPreferences(
                sets: 1,
                games: 6,
                timestamp: Date.now,
                initialServe: team,
                finalSetTieBreak: false,
                pointsForTieBreak: 7,
                teams: TeamMembersWrapper(dict: teams)
            )
            
            let match = TennisMatch(createdByUserId: UUID().uuidString, preferences: preferences, events: [])
            
            XCTAssert(match.initialState.serving == match.preferences.initialServe, "The initialState.serving team should be set from preferences.initialServe.")
        }
    }
    
}
