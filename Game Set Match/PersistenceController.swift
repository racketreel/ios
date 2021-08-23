//
//  PersistenceController.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 23/08/2021.
//

import Foundation
import CoreData

struct PersistenceController {
    
    // CoreData container
    let container: NSPersistentContainer
    
    // A singleton for our entire app to use
    static let shared = PersistenceController()
    
    // Dummy data for previews
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)

        // Todo: Decode test matches from json
        for _ in 0..<4 {
            let match = Match(context: controller.container.viewContext)
            
            let matchPreferences = MatchPreferences()
            matchPreferences.firstServe = true
            matchPreferences.gamesForSet = 6
            matchPreferences.setsToWin = 3
//            matchPreferences.match_ = match
            match.matchPreferences = matchPreferences
            
            let initialState = MatchState()
            initialState.breakPoint = false
            initialState.gamesOpponent = 0
            initialState.gamesUser = 0
            initialState.generationEvent = GenerationEvent.Start
            initialState.generationEventTimestamp = Date().timeIntervalSince1970
//            initialState.match_ = match
            initialState.pointDescription = PointDescription.None
            initialState.pointsOpponent_ = 0
            initialState.pointsUser_ = 0
            initialState.setsOpponent = 0
            initialState.setsUser = 0
            initialState.tieBreak = false
            initialState.toServe = true
            match.history = [initialState]
        }

        return controller
    }()


    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")

        // Don't persist data for when inMemory
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Unable to save to CoreData: \(error.localizedDescription)")
            }
        }
    }
    
}
