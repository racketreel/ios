//
//  MatchPreferences+CoreDataClass.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 14/08/2021.
//
//

import Foundation
import CoreData


public class MatchPreferences: NSManagedObject, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case firstServe
        case setsToWin
        case gamesForSet
    }

    // 'required' initializer cannot be defined in an extension
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
       
        // All non-optional
        self.firstServe = try container.decode(Bool.self, forKey: .firstServe)
        self.setsToWin = try container.decode(Int64.self, forKey: .setsToWin)
        self.gamesForSet = try container.decode(Int64.self, forKey: .gamesForSet)
    }

}
