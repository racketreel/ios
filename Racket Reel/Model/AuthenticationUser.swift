//
//  AuthenticationUser.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 06/11/2021.
//

import Foundation

struct AuthenticationUser: Identifiable {
    let id: String
    let email: String
    let verified: Bool
}
