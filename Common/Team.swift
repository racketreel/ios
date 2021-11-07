//
//  TeamC.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 26/10/2021.
//

import Foundation
import SwiftUI

struct Team: Codable {
    
    // Team number, only two possible teams in a match.
    let number: TeamNumber
    
    // Either a Singles or Doubles team
    let membership: TeamMembershipType
    
    // Count of 1 in singles and 2 in doubles.
    var members: [TeamMember]
    
    var name: String {
        if (membership == TeamMembershipType.Doubles) {
            let surnames = members.map { $0.surname }
            return surnames.joined(separator: " & ")
        } else {
            return members.first!.fullname()
        }
    }
    
}
