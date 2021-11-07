//
//  AuthenticationError.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 06/11/2021.
//

import Foundation

public enum AuthenticationError: Error {
    case notLoggedIn
}

extension AuthenticationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .notLoggedIn:
                return NSLocalizedString("There is no user currently logged in.", comment: "Not Logged In")
        }
    }
}
