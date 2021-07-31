//
//  Match+CoreDataProperties.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 31/07/2021.
//
//

import Foundation
import CoreData


extension Match {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Match> {
        return NSFetchRequest<Match>(entityName: "Match")
    }

    @NSManaged public var id: String?
    @NSManaged public var matchPreferences: MatchPreferences?
    @NSManaged public var history: NSOrderedSet?

}

// MARK: Generated accessors for history
extension Match {

    @objc(insertObject:inHistoryAtIndex:)
    @NSManaged public func insertIntoHistory(_ value: MatchState, at idx: Int)

    @objc(removeObjectFromHistoryAtIndex:)
    @NSManaged public func removeFromHistory(at idx: Int)

    @objc(insertHistory:atIndexes:)
    @NSManaged public func insertIntoHistory(_ values: [MatchState], at indexes: NSIndexSet)

    @objc(removeHistoryAtIndexes:)
    @NSManaged public func removeFromHistory(at indexes: NSIndexSet)

    @objc(replaceObjectInHistoryAtIndex:withObject:)
    @NSManaged public func replaceHistory(at idx: Int, with value: MatchState)

    @objc(replaceHistoryAtIndexes:withHistory:)
    @NSManaged public func replaceHistory(at indexes: NSIndexSet, with values: [MatchState])

    @objc(addHistoryObject:)
    @NSManaged public func addToHistory(_ value: MatchState)

    @objc(removeHistoryObject:)
    @NSManaged public func removeFromHistory(_ value: MatchState)

    @objc(addHistory:)
    @NSManaged public func addToHistory(_ values: NSOrderedSet)

    @objc(removeHistory:)
    @NSManaged public func removeFromHistory(_ values: NSOrderedSet)

}

extension Match : Identifiable {

}
