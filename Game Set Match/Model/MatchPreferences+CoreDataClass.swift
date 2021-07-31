//
//  MatchPreferences+CoreDataClass.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 31/07/2021.
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

    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.firstServe = try container.decodeIfPresent(Bool.self, forKey: .firstServe)!
        self.setsToWin = try container.decodeIfPresent(Int64.self, forKey: .setsToWin)!
        self.gamesForSet = try container.decodeIfPresent(Int64.self, forKey: .gamesForSet)!
    }
    
}
