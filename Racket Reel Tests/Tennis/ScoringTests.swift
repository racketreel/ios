//
//  ScoringTests.swift
//  Racket Reel Tests
//
//  Created by Tom Elvidge on 18/10/2021.
//

import XCTest
@testable import Racket_Reel

class ScoringTests: XCTestCase {
    
    func testNewScoresPointsAreIncrementedPointWin() {
        let match = TennisMatch.empty
        
        let state = match.initialState
        
        let expectedScores = [
            Team.One: TennisScore(points: 1, games: 0, sets: 0),
            Team.Two: TennisScore(points: 0, games: 0, sets: 0)
        ]
        
        let newScores = match.newScores(after: state, whenWonBy: Team.One)
        
        XCTAssert(newScores == expectedScores, "Team which wins has their points incremented.")
    }
    
    func testNewScoresPointsAreDecrementedAfterLosingOnAdvantage() {
        let match = TennisMatch.empty
        
        let state = TennisState(
            scores: [
                Team.One: TennisScore(points: TennisPoint.Advantage.rawValue, games: 0, sets: 0),
                Team.Two: TennisScore(points: TennisPoint.Forty.rawValue, games: 0, sets: 0)
            ],
            serving: Team.One,
            isSecondServe: false,
            tieBreakPointCounter: nil,
            toServePostTieBreak: nil
        )
        
        let expectedScores = [
            Team.One: TennisScore(points: TennisPoint.Forty.rawValue, games: 0, sets: 0),
            Team.Two: TennisScore(points: TennisPoint.Forty.rawValue, games: 0, sets: 0)
        ]
        
        let newScores = match.newScores(after: state, whenWonBy: Team.Two)
        
        XCTAssert(newScores == expectedScores, "Back to deuce after losing on advantage.")
    }
    
    func testNewScoresGamesAreIncrementedOnGameWin() {
        let match = TennisMatch.empty
        
        let state = TennisState(
            scores: [
                Team.One: TennisScore(points: TennisPoint.Forty.rawValue, games: 0, sets: 0),
                Team.Two: TennisScore(points: TennisPoint.Love.rawValue, games: 0, sets: 0)
            ],
            serving: Team.One,
            isSecondServe: false,
            tieBreakPointCounter: nil,
            toServePostTieBreak: nil
        )
        
        let expectedScores = [
            Team.One: TennisScore(points: 0, games: 1, sets: 0),
            Team.Two: TennisScore(points: 0, games: 0, sets: 0)
        ]
        
        let newScores = match.newScores(after: state, whenWonBy: Team.One)
        
        XCTAssert(newScores == expectedScores, "Team which wins a game has their games incremented.")
    }
    
    func testNewScoresSetsAreIncrementedOnSetWin() {
        let match = TennisMatch.empty
        
        let state = TennisState(
            scores: [
                Team.One: TennisScore(points: TennisPoint.Forty.rawValue, games: 5, sets: 0),
                Team.Two: TennisScore(points: TennisPoint.Love.rawValue, games: 0, sets: 0)
            ],
            serving: Team.One,
            isSecondServe: false,
            tieBreakPointCounter: nil,
            toServePostTieBreak: nil
        )
        
        let expectedScores = [
            Team.One: TennisScore(points: 0, games: 0, sets: 1),
            Team.Two: TennisScore(points: 0, games: 0, sets: 0)
        ]
        
        let newScores = match.newScores(after: state, whenWonBy: Team.One)
        
        XCTAssert(newScores == expectedScores, "Team which wins a set has their sets incremented.")
    }
    
}
