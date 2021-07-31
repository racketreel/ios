//
//  MatchState+CoreDataProperties.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 31/07/2021.
//
//

import Foundation
import CoreData


extension MatchState {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MatchState> {
        return NSFetchRequest<MatchState>(entityName: "MatchState")
    }

    @NSManaged public var breakPoint: Bool
    @NSManaged public var gamesOpponent: Int64
    @NSManaged public var gamesUser: Int64
    @NSManaged public var generationEventTimestamp: Double
    @NSManaged public var generationEventType: String?
    @NSManaged public var pointsOpponent: String?
    @NSManaged public var pointsUser: String?
    @NSManaged public var pointType: String?
    @NSManaged public var setsOpponent: Int64
    @NSManaged public var setsUser: Int64
    @NSManaged public var toServe: Bool
    @NSManaged public var match: Match?

}

extension MatchState : Identifiable {

}
