//
//  MatchState+CoreDataClass.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 14/08/2021.
//
//

import Foundation
import CoreData


public class MatchState: NSManagedObject, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case breakPoint
        case gamesOpponent
        case gamesUser
        case generationEventTimestamp
        case generationEventType
        case pointsOpponent
        case pointsUser
        case pointType
        case setsOpponent
        case setsUser
        case toServe
    }
    
    // 'required' initializer cannot be defined in an extension
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.breakPoint = try container.decodeIfPresent(Bool.self, forKey: .breakPoint)!
        self.gamesOpponent = try container.decodeIfPresent(Int64.self, forKey: .gamesOpponent)!
        self.gamesUser = try container.decodeIfPresent(Int64.self, forKey: .gamesUser)!
        self.generationEventTimestamp = try container.decodeIfPresent(Double.self, forKey: .generationEventTimestamp)!
        self.generationEventType = try container.decodeIfPresent(String.self, forKey: .generationEventType)
        self.pointsOpponent = try container.decodeIfPresent(String.self, forKey: .pointsOpponent)
        self.pointsUser = try container.decodeIfPresent(String.self, forKey: .pointsUser)
        self.pointType = try container.decodeIfPresent(String.self, forKey: .pointType)
        self.setsOpponent = try container.decodeIfPresent(Int64.self, forKey: .setsOpponent)!
        self.setsUser = try container.decodeIfPresent(Int64.self, forKey: .setsUser)!
        self.toServe = try container.decodeIfPresent(Bool.self, forKey: .toServe)!
    }

}
