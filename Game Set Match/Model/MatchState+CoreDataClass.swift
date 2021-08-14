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
        case generationEvent
        case pointsOpponent
        case pointsUser
        case pointDescription
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
        self.breakPoint = try container.decode(Bool.self, forKey: .breakPoint)
        self.gamesOpponent = try container.decode(Int64.self, forKey: .gamesOpponent)
        self.gamesUser = try container.decode(Int64.self, forKey: .gamesUser)
        self.generationEventTimestamp = try container.decode(Double.self, forKey: .generationEventTimestamp)
        self.generationEvent_ = try container.decode(Int64.self, forKey: .generationEvent)
        self.pointsOpponent_ = try container.decode(String.self, forKey: .pointsOpponent)
        self.pointsUser_ = try container.decode(String.self, forKey: .pointsUser)
        self.pointDescription_ = try container.decode(Int64.self, forKey: .pointDescription)
        self.setsOpponent = try container.decode(Int64.self, forKey: .setsOpponent)
        self.setsUser = try container.decode(Int64.self, forKey: .setsUser)
        self.toServe = try container.decode(Bool.self, forKey: .toServe)
    }

}
