//
//  StateTransitionTests.swift
//  Racket Reel Tests
//
//  Created by Tom Elvidge on 18/10/2021.
//
//  These tests should have the general pattern:
//    let startState = ...
//    let event = ...
//    let expectedState = ...
//    let nextState = match.state(after: startState, when: event)
//    XCTAssert(nextState == expectedState)

import XCTest
@testable import Racket_Reel

class StateTransitionTests: XCTestCase {
    
    func testSomeEventTypesDoNotChangeState() {
        let match = TennisMatch.empty
        let startState = match.initialState
        
        // Events which should not change the state.
        let events = [TennisEventType.FirstServe, TennisEventType.SecondServe, TennisEventType.Let]
        
        for event in events {
            let nextState = match.state(after: startState, when: event)!
            XCTAssert(startState == nextState, "TennisEventType \(event) should not change the state.")
        }
    }
    
    func testNextStateNilAfterWin() {
        let match = TennisMatch.empty
        
        let startState = TennisState(
            scores: [
                Team.One: TennisScore(points: TennisPoint.Forty.rawValue, games: 5, sets: 1),
                Team.Two: TennisScore(points: TennisPoint.Love.rawValue, games: 0, sets: 0)
            ],
            serving: Team.One,
            isSecondServe: false,
            tieBreakPointCounter: nil,
            toServePostTieBreak: nil
        )
        
        let nextState = match.state(after: startState, when: TennisEventType.TeamOnePoint)
        
        XCTAssert(nextState == nil, "State should be nil after match win.")
    }
    
    func testFaultOnFirstServeChangesToSecondServe() {
        let match = TennisMatch.empty
        
        // Initial state isSecondServe == false.
        let startState = match.initialState
        let event = TennisEventType.Fault
        
        // Only change is isSecondServe == true.
        let expectedState = TennisState(
            scores: startState.scores,
            serving: startState.serving,
            isSecondServe: true,
            tieBreakPointCounter: startState.tieBreakPointCounter,
            toServePostTieBreak: startState.toServePostTieBreak
        )
        
        let nextState = match.state(after: startState, when: event)
        XCTAssert(nextState == expectedState, "Next state is on second serve.")
    }
    
    func testFaultOnSecondServeLosesPoint() {
        let match = TennisMatch.empty
        
        // Create a state on a second serve with Team.One serving and no points scored.
        let serving = Team.One
        let startState = TennisState(
            scores: match.initialState.scores,
            serving: serving,
            isSecondServe: true,
            tieBreakPointCounter: nil,
            toServePostTieBreak: nil
        
        )
        
        var expectedScores = startState.scores
        expectedScores[serving.opponent] = TennisScore(
            points: 1, // Opponent gains a point.
            games: 0,
            sets: 0
        )
        
        let expectedState = TennisState(
            scores: expectedScores,
            serving: startState.serving,
            isSecondServe: false, // Back to first serve.
            tieBreakPointCounter: startState.tieBreakPointCounter,
            toServePostTieBreak: startState.toServePostTieBreak
        )
        
        
        let nextState = match.state(after: startState, when: TennisEventType.Fault)!
        XCTAssert(nextState == expectedState, "Next state the opponent has scored a point and it is back to the first serve.")
    }
    
    // Tie break
    
    func testTieBreakIsTriggered() {
        let match = TennisMatch.empty
        
        let startState = TennisState(
            scores: [
                Team.One: TennisScore(points: TennisPoint.Forty.rawValue, games: 5, sets: 0),
                Team.Two: TennisScore(points: TennisPoint.Love.rawValue, games: 6, sets: 0)
            ],
            serving: Team.One,
            isSecondServe: false,
            tieBreakPointCounter: nil,
            toServePostTieBreak: nil
        )
        let event = TennisEventType.TeamOnePoint
        
        // serving switches
        // toServePostTieBreak set to previous server
        // tieBreakPointCounter initialised
        let expectedState = TennisState(
            scores: [
                Team.One: TennisScore(points: 0, games: 6, sets: 0),
                Team.Two: TennisScore(points: 0, games: 6, sets: 0)
            ],
            serving: Team.Two,
            isSecondServe: false,
            tieBreakPointCounter: 0,
            toServePostTieBreak: Team.Two
        )
        
        let nextState = match.state(after: startState, when: event)!
        
        XCTAssert(nextState == expectedState, "Tie break fields should be set correctly, serving switched, and games 6 a piece.")
    }

    func testTieBreakNotWonUntilTwoPointsAhead() {
        
    }

    func testTieBreakMinimumPointsDependsOnPreferences() {
        
    }

    func testTieBreakOnLastSetDependsOnPreferences() {
        
    }
    
    func testServingTeamRestoredAfterTieBreak() {
        
    }
    
    func testTieBreakSwitchesServeEveryOtherPoint() {
        
    }
    
    func testTieBreakPropertiesResetAfter() {
        
    }
    
}
