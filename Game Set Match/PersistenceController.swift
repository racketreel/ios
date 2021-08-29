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
        
        let decoder = JSONDecoder()
        // Custom decoder to add decoded matches to CoreData container
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = controller.container.viewContext
        _ = getTestMatches(decoder: decoder)

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
    
    static func getTestMatches(decoder: JSONDecoder = JSONDecoder()) -> [Match]? {
        if let path = Bundle.main.path(forResource: "matches", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode([Match].self, from: data)
            } catch {
                print("Cannot decode test matches: \(error)")
            }
        }
        return nil
    }
    
}
