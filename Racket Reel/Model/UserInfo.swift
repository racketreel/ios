//
//  UserInfo.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 06/11/2021.
//

import Foundation

struct UserInfo: Identifiable, Codable {
    let id: String
    let firstname: String
    let surname: String
    let matchIds: [String]
}
