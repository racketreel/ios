//
//  TeamMembersWrapper.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 19/10/2021.
//

import Foundation

// Wrap teamMembers dictionary so it can be encoded/decoded using Team as the key.
struct TeamMembersWrapper: Codable {
    
    var dict: Dictionary<Team, [TeamMember]>
    
    init(dict: Dictionary<Team, [TeamMember]>) {
        self.dict = dict
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringDictionary = try container.decode([String: [TeamMember]].self)

        dict = [:]
        for (stringKey, value) in stringDictionary {
            guard let key = Team(rawValue: stringKey) else {
                throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid key '\(stringKey)'"
                )
            }
            dict[key] = value
        }
    }

    func encode(to encoder: Encoder) throws {
      let stringDictionary: [String: [TeamMember]] = Dictionary(
        uniqueKeysWithValues: dict.map { ($0.rawValue, $1) }
      )
      var container = encoder.singleValueContainer()
      try container.encode(stringDictionary)
    }
    
}
