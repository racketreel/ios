//
//  MatchState+CoreDataClass.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 14/08/2021.
//
//

import Foundation
import CoreData


public class MatchState: NSManagedObject, Codable {
    
    // Cannot be stored in an extension
    let pointIntStringMap = [
        0: "0",
        1: "15",
        2: "30",
        3: "40",
        4: "AD"
    ]
    
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
        case tieBreak
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
        self.pointsOpponent_ = try container.decode(Int64.self, forKey: .pointsOpponent)
        self.pointsUser_ = try container.decode(Int64.self, forKey: .pointsUser)
        self.pointDescription_ = try container.decode(Int64.self, forKey: .pointDescription)
        self.setsOpponent = try container.decode(Int64.self, forKey: .setsOpponent)
        self.setsUser = try container.decode(Int64.self, forKey: .setsUser)
        self.toServe = try container.decode(Bool.self, forKey: .toServe)
        self.tieBreak = try container.decode(Bool.self, forKey: .tieBreak)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(breakPoint, forKey: .breakPoint)
        try container.encode(gamesOpponent, forKey: .gamesOpponent)
        try container.encode(gamesUser, forKey: .gamesUser)
        try container.encode(generationEventTimestamp, forKey: .generationEventTimestamp)
        try container.encode(generationEvent_, forKey: .generationEvent)
        try container.encode(pointsOpponent_, forKey: .pointsOpponent)
        try container.encode(pointsUser_, forKey: .pointsUser)
        try container.encode(pointDescription_, forKey: .pointDescription)
        try container.encode(setsOpponent, forKey: .setsOpponent)
        try container.encode(setsUser, forKey: .setsUser)
        try container.encode(toServe, forKey: .toServe)
        try container.encode(tieBreak, forKey: .tieBreak)
    }

}
