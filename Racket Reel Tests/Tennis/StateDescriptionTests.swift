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
                    Team.One: TennisScore(points: TennisPoint.Forty.rawValue, games: 5, sets: 0),
                    Team.Two: TennisScore(points: TennisPoint.Love.rawValue, games: 0, sets: 0)
                ],
                serving: Team.One,
                isSecondServe: false,
                tieBreakPointCounter: nil,
                toServePostTieBreak: nil
            ),
            // Win from deuce
            TennisState(
                scores: [
                    Team.One: TennisScore(points: TennisPoint.Advantage.rawValue, games: 0, sets: 0),
                    Team.Two: TennisScore(points: TennisPoint.Forty.rawValue, games: 0, sets: 0)
                ],
                serving: Team.One,
                isSecondServe: false,
                tieBreakPointCounter: nil,
                toServePostTieBreak: nil
            ),
            // Win min points in tie break
            TennisState(
                scores: [
                    Team.One: TennisScore(points: 6, games: 6, sets: 0),
                    Team.Two: TennisScore(points: 5, games: 6, sets: 0)
                ],
                serving: Team.One,
                isSecondServe: false,
                tieBreakPointCounter: 11,
                toServePostTieBreak: Team.One
            ),
            // Win more than min points in tie break (at least two ahead)
            TennisState(
                scores: [
                    Team.One: TennisScore(points: 20, games: 6, sets: 0),
                    Team.Two: TennisScore(points: 19, games: 6, sets: 0)
                ],
                serving: Team.One,
                isSecondServe: false,
                tieBreakPointCounter: 49,
                toServePostTieBreak: Team.One
            )
        ]
        
        for state in gamePointToTeamOneStates {
            XCTAssert(match.isGamePoint(to: Team.One, when: state), "Should be game point when state is \(state).")
        }
    }
    
    func testIsGamePointFalse() {
        let match = TennisMatch.empty
        
        let notGamePointToTeamOneStates = [
            // Deuce
            TennisState(
                scores: [
                    Team.One: TennisScore(points: TennisPoint.Forty.rawValue, games: 0, sets: 0),
                    Team.Two: TennisScore(points: TennisPoint.Forty.rawValue, games: 0, sets: 0)
                ],
                serving: Team.One,
                isSecondServe: false,
                tieBreakPointCounter: nil,
                toServePostTieBreak: nil
            ),
            // Game point to opponent
            TennisState(
                scores: [
                    Team.One: TennisScore(points: TennisPoint.Thirty.rawValue, games: 0, sets: 0),
                    Team.Two: TennisScore(points: TennisPoint.Forty.rawValue, games: 0, sets: 0)
                ],
                serving: Team.One,
                isSecondServe: false,
                tieBreakPointCounter: nil,
                toServePostTieBreak: nil
            ),
            // Both have min points for tie break
            TennisState(
                scores: [
                    Team.One: TennisScore(points: 7, games: 6, sets: 0),
                    Team.Two: TennisScore(points: 7, games: 6, sets: 0)
                ],
                serving: Team.One,
                isSecondServe: false,
                tieBreakPointCounter: 14,
                toServePostTieBreak: Team.One
            )
        ]
        
        for state in notGamePointToTeamOneStates {
            XCTAssert(!match.isGamePoint(to: Team.One, when: state), "Should not be game point when state is \(state).")
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
                    Team.One: TennisScore(points: TennisPoint.Forty.rawValue, games: 5, sets: 0),
                    Team.Two: TennisScore(points: TennisPoint.Love.rawValue, games: 0, sets: 0)
                ],
                serving: Team.One,
                isSecondServe: false,
                tieBreakPointCounter: nil,
                toServePostTieBreak: nil
            )
        ]
        
        for state in states {
            XCTAssert(match.isSetPoint(to: Team.One, when: state), "Should be set point when state \(state).")
        }
    }
    
    func testIsSetPointFalse() {
        
    }
    
    func testIsMatchPointTrue() {
        let match = TennisMatch.empty
        
        let states = [
            TennisState(
                scores: [
                    Team.One: TennisScore(points: TennisPoint.Forty.rawValue, games: 5, sets: 1),
                    Team.Two: TennisScore(points: TennisPoint.Love.rawValue, games: 0, sets: 0)
                ],
                serving: Team.One,
                isSecondServe: false,
                tieBreakPointCounter: nil,
                toServePostTieBreak: nil
            )
        ]
        
        for state in states {
            XCTAssert(match.isMatchPoint(to: Team.One, when: state), "Should be match point when state \(state).")
        }
    }
    
    func testIsMatchPointFalse() {
        
    }
    
    func testIsTieBreakTrue() {
        
    }
    
    func testIsTieBreakFalse() {
        
    }
    
}
