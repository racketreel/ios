//
//  Match+CoreDataClass.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 14/08/2021.
//
//

import Foundation
import CoreData


public class Match: NSManagedObject, Codable {
    
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
        
        // Allow decode without CoreData for testing (DOESN'T WORK)
//        let context = decoder.userInfo[.managedObjectContext] as? NSManagedObjectContext
//        if (context == nil) {
//            self.init()
//        } else {
//            self.init(context: context!)
//        }
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.history_ = NSOrderedSet(array: try container.decode([MatchState].self, forKey: .history))
        self.id_ = try container.decode(String.self, forKey: .id)
        self.matchPreferences_ = try container.decode(MatchPreferences.self, forKey: .matchPreferences)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(history, forKey: .history)
        try container.encode(id, forKey: .id)
        try container.encode(matchPreferences, forKey: .matchPreferences)
    }

}

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
