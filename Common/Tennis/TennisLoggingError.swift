//
//  TennisLoggingError.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 19/10/2021.
//

import Foundation

public enum TennisLoggingError: Error {
    case matchNotInProgress
    case statesNilDuringMatch
    case noEventsToUndo
    case matchHasAlreadyStarted
}

extension TennisLoggingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .matchNotInProgress:
                return NSLocalizedString("Cannot log new events to matched which are not in progress.", comment: "Match Not In Progress")
            case .statesNilDuringMatch:
                return NSLocalizedString("Property states should never be nil during a match.", comment: "States Nil During Match")
            case .noEventsToUndo:
                return NSLocalizedString("There are no events left to undo.", comment: "No Events To Undo")
            case .matchHasAlreadyStarted:
                return NSLocalizedString("Cannot start a match which is already in progress..", comment: "Match Has Already Started")
        }
    }
}
