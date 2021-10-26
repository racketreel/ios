//
//  TeamMember.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 17/10/2021.
//

import Foundation

struct TeamMember: Codable {
    
    var firstname: String
    var surname: String
    
    func fullname() -> String {
        return "\(firstname) \(surname)"
    }
    
}
