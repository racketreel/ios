//
//  AuthenticationUser.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 06/11/2021.
//

import Foundation

public struct AuthenticationUser: Identifiable {
    public let id: String
    public let email: String
    public let verified: Bool
}
