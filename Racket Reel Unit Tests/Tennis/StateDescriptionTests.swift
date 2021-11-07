//
//  StateDescriptionTests.swift
//  Racket Reel Tests
//
//  Created by Tom Elvidge on 18/10/2021.
//

import XCTest
@testable import Racket_Reel

class StateDescriptionTests: XCTestCase {
    
    func testIsGamePointTrue() {
        let match = TennisMatch.empty
        
        let gamePointToTeamOneStates = [
            // Simple win
            TennisState(
                scores: [
                    TeamNumber.One: TennisScore(points: TennisPoint.Forty.rawValue, games: 5, sets: 0),
                    TeamNumber.Two: TennisScore(points: TennisPoint.Love.rawValue, games: 0, sets: 0)
                ],
                serving: TeamNumber.One,
                isSecondServe: false,
                tieBreakPointCounter: nil,
                toServePostTieBreak: nil
            ),
            // Win from deuce
            TennisState(
                scores: [
                    TeamNumber.One: TennisScore(points: TennisPoint.Advantage.rawValue, games: 0, sets: 0),
                    TeamNumber.Two: TennisScore(points: TennisPoint.Forty.rawValue, games: 0, sets: 0)
                ],
                serving: TeamNumber.One,
                isSecondServe: false,
                tieBreakPointCounter: nil,
                toServePostTieBreak: nil
            ),
            // Win min points in tie break
            TennisState(
                scores: [
                    TeamNumber.One: TennisScore(points: 6, games: 6, sets: 0),
                    TeamNumber.Two: TennisScore(points: 5, games: 6, sets: 0)
                ],
                serving: TeamNumber.One,
                isSecondServe: false,
                tieBreakPointCounter: 11,
                toServePostTieBreak: TeamNumber.One
            ),
            // Win more than min points in tie break (at least two ahead)
            TennisState(
                scores: [
                    TeamNumber.One: TennisScore(points: 20, games: 6, sets: 0),
                    TeamNumber.Two: TennisScore(points: 19, games: 6, sets: 0)
                ],
                serving: TeamNumber.One,
                isSecondServe: false,
                tieBreakPointCounter: 49,
                toServePostTieBreak: TeamNumber.One
            )
        ]
        
        for state in gamePointToTeamOneStates {
            XCTAssert(match.isGamePoint(to: TeamNumber.One, when: state), "Should be game point when state is \(state).")
        }
    }
    
    func testIsGamePointFalse() {
        let match = TennisMatch.empty
        
        let notGamePointToTeamOneStates = [
            // Deuce
            TennisState(
                scores: [
                    TeamNumber.One: TennisScore(points: TennisPoint.Forty.rawValue, games: 0, sets: 0),
                    TeamNumber.Two: TennisScore(points: TennisPoint.Forty.rawValue, games: 0, sets: 0)
                ],
                serving: TeamNumber.One,
                isSecondServe: false,
                tieBreakPointCounter: nil,
                toServePostTieBreak: nil
            ),
            // Game point to opponent
            TennisState(
                scores: [
                    TeamNumber.One: TennisScore(points: TennisPoint.Thirty.rawValue, games: 0, sets: 0),
                    TeamNumber.Two: TennisScore(points: TennisPoint.Forty.rawValue, games: 0, sets: 0)
                ],
                serving: TeamNumber.One,
                isSecondServe: false,
                tieBreakPointCounter: nil,
                toServePostTieBreak: nil
            ),
            // Both have min points for tie break
            TennisState(
                scores: [
                    TeamNumber.One: TennisScore(points: 7, games: 6, sets: 0),
                    TeamNumber.Two: TennisScore(points: 7, games: 6, sets: 0)
                ],
                serving: TeamNumber.One,
                isSecondServe: false,
                tieBreakPointCounter: 14,
                toServePostTieBreak: TeamNumber.One
            )
        ]
        
        for state in notGamePointToTeamOneStates {
            XCTAssert(!match.isGamePoint(to: TeamNumber.One, when: state), "Should not be game point when state is \(state).")
        }
    }
    
    func testIsBreakPointTrue() {
        
    }
    
    func testIsBreakPointFalse() {
        
    }
    
    func testIsSetPointTrue() {
        let match = TennisMatch.empty
        
        let states = [
            TennisState(
                scores: [
                    TeamNumber.One: TennisScore(points: TennisPoint.Forty.rawValue, games: 5, sets: 0),
                    TeamNumber.Two: TennisScore(points: TennisPoint.Love.rawValue, games: 0, sets: 0)
                ],
                serving: TeamNumber.One,
                isSecondServe: false,
                tieBreakPointCounter: nil,
                toServePostTieBreak: nil
            )
        ]
        
        for state in states {
            XCTAssert(match.isSetPoint(to: TeamNumber.One, when: state), "Should be set point when state \(state).")
        }
    }
    
    func testIsSetPointFalse() {
        
    }
    
    func testIsMatchPointTrue() {
        let match = TennisMatch.empty
        
        let states = [
            TennisState(
                scores: [
                    TeamNumber.One: TennisScore(points: TennisPoint.Forty.rawValue, games: 5, sets: 1),
                    TeamNumber.Two: TennisScore(points: TennisPoint.Love.rawValue, games: 0, sets: 0)
                ],
                serving: TeamNumber.One,
                isSecondServe: false,
                tieBreakPointCounter: nil,
                toServePostTieBreak: nil
            )
        ]
        
        for state in states {
            XCTAssert(match.isMatchPoint(to: TeamNumber.One, when: state), "Should be match point when state \(state).")
        }
    }
    
    func testIsMatchPointTrueForOneGameMatch() {
        let oneGameMatch = TennisMatch(
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
                            TeamMember(firstname: "", surname: "")
                        ]
                    ),
                    TeamNumber.Two: Team(
                        number: TeamNumber.Two,
                        membership: TeamMembershipType.Singles,
                        members: [
                            TeamMember(firstname: "", surname: "")
                        ]
                    )
                ])
            ),
            events: [
                TennisEvent(timestamp: Date(), type: TennisEventType.FirstServe),
                TennisEvent(timestamp: Date(), type: TennisEventType.Fault),
                TennisEvent(timestamp: Date(), type: TennisEventType.FirstServe),
                TennisEvent(timestamp: Date(), type: TennisEventType.Fault),
                TennisEvent(timestamp: Date(), type: TennisEventType.FirstServe),
                TennisEvent(timestamp: Date(), type: TennisEventType.Fault),
                TennisEvent(timestamp: Date(), type: TennisEventType.FirstServe)
            ]
        )
        
        let state = TennisState(
            scores: [
                TeamNumber.One: TennisScore(points: TennisPoint.Love.rawValue, games: 0, sets: 0),
                TeamNumber.Two: TennisScore(points: TennisPoint.Forty.rawValue, games: 0, sets: 0)
            ],
            serving: TeamNumber.One,
            isSecondServe: false,
            tieBreakPointCounter: nil,
            toServePostTieBreak: nil
        )
        
        XCTAssert(oneGameMatch.isGamePoint(to: TeamNumber.Two, when: state), "Should be match point when state \(state).")
        
        XCTAssert(oneGameMatch.isSetPoint(to: TeamNumber.Two, when: state), "Should be match point when state \(state).")
    
        XCTAssert(oneGameMatch.isMatchPoint(to: TeamNumber.Two, when: state), "Should be match point when state \(state).")
    }
    
    func testIsMatchPointFalse() {
        
    }
    
    func testIsTieBreakTrue() {
        
    }
    
    func testIsTieBreakFalse() {
        
    }
    
}
