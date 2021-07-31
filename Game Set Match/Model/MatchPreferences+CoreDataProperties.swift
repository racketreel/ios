//
//  MatchPreferences+CoreDataProperties.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 31/07/2021.
//
//

import Foundation
import CoreData


extension MatchPreferences {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MatchPreferences> {
        return NSFetchRequest<MatchPreferences>(entityName: "MatchPreferences")
    }

    @NSManaged public var firstServe: Bool
    @NSManaged public var gamesForSet: Int64
    @NSManaged public var setsToWin: Int64

}

extension MatchPreferences : Identifiable {

}
