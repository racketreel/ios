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
    
    var members: [TeamMember] {
        get {
            return _members
        }
        set {
            // Singles
            if (membership == TeamMembershipType.Singles) {
                if (newValue.count == 1) {
                    self._members = newValue
                } else {
                    print("Tried to set Team.members with a list not with 1 element when in Singles.")
                    // Create placeholder Singles _members.
                    self._members = [
                        TeamMember(firstname: "Player", surname: (number == TeamNumber.One) ? "One" : "Two")
                    ]
                }
            } else { // membership == TeamMembershipType.Doubles
                if (newValue.count == 2) {
                    self._members = newValue
                } else {
                    print("Tried to set Team.members with a list not with 2 elements when in Doubles.")
                    // Create placeholder Doubles _members.
                    self._members = [
                        // Player's One and Two in Team.One, and Three and Four in Team.Two.
                        TeamMember(firstname: "Player", surname: (number == TeamNumber.One) ? "One" : "Three"),
                        TeamMember(firstname: "Player", surname: (number == TeamNumber.One) ? "Two" : "Four")
                    ]
                }
            }
        }
    }
    
    // Count of 1 in singles and 2 in doubles.
    private var _members: [TeamMember]
    
    var name: String {
        let fullnames = members.map { $0.fullname() }
        return fullnames.joined(separator: " & ")
    }
    
    init(number: TeamNumber, membership: TeamMembershipType, members: [TeamMember]) {
        self.number = number
        self.membership = membership
        self._members = [] // Overwritten by the next line.
        self.members = members
    }
    
}
