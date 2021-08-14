//
//  Match+CoreDataClass.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 14/08/2021.
//
//

import Foundation
import CoreData


public class Match: NSManagedObject, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case history
        case id
        case matchPreferences
    }
    
    // 'required' initializer cannot be defined in an extension
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.history = NSOrderedSet(array: try container.decode([MatchState].self, forKey: .history))
        self.id = try container.decode(String.self, forKey: .id)
        self.matchPreferences = try container.decode(MatchPreferences.self, forKey: .matchPreferences)
    }

}

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
