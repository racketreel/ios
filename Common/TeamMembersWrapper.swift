//
//  TeamMembersWrapper.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 19/10/2021.
//

import Foundation

// Wrap teams dictionary so it can be encoded/decoded using Team as the key.
struct TeamMembersWrapper: Codable {
    
    var dict: Dictionary<TeamNumber, Team>
    
    init(dict: Dictionary<TeamNumber, Team>) {
        self.dict = dict
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringDictionary = try container.decode([String: Team].self)

        dict = [:]
        for (stringKey, value) in stringDictionary {
            guard let key = TeamNumber(rawValue: stringKey) else {
                throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid key '\(stringKey)'"
                )
            }
            dict[key] = value
        }
    }

    func encode(to encoder: Encoder) throws {
      let stringDictionary: [String: Team] = Dictionary(
        uniqueKeysWithValues: dict.map { ($0.rawValue, $1) }
      )
      var container = encoder.singleValueContainer()
      try container.encode(stringDictionary)
    }
    
}
