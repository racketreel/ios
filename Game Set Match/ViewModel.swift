//
//  ViewModel.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 23/07/2021.
//

import Foundation
import WatchConnectivity
import CoreData

class ViewModel : NSObject, ObservableObject, WCSessionDelegate {
    
    // WatchConnectivity for recording match data on watchOS
    var session: WCSession?
    
    @Published var matches: [Match] = []
    
    // CoreData
    var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "Model")
            container.loadPersistentStores { description, error in
                if let error = error {
                    fatalError("Unable to load persistent stores: \(error)")
                }
            }
            return container
        }()
    
    override init() {
        super.init()
        
        if WCSession.isSupported() {
            self.session = WCSession.default
            self.session!.delegate = self
            self.session!.activate()
        }
        
        fetchMatches()
    }
    
    func fetchMatches() {
        do {
            // Fetch all Match objects from CoreData
            let matches: [Match] = try persistentContainer.viewContext.fetch(Match.fetchRequest())
            // Update published matches var on main thread to alert views
            DispatchQueue.main.async {
                self.matches = matches
            }
        } catch {
            NSLog("Unable to fetch Match objects from CoreData")
        }
    }
    
    func deleteMatches(at indexSet: IndexSet) {
        indexSet.forEach { i in
            // Delete match from CoreData
            let match = matches[i]
            self.persistentContainer.viewContext.delete(match)
            // Save changes
            do {
                try self.persistentContainer.viewContext.save()
            } catch {
                NSLog("Unable to save changes to CoreData")
            }
        }
        fetchMatches()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        NSLog("didReceiveApplicationContext : \(applicationContext)")
        
        // Extract match from context
        let matchJSON = applicationContext["match"] as! Data
        
        let decoder = JSONDecoder()
        // Once decoded add Match to CoreData
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = persistentContainer.viewContext
        
        do {
            let match = try decoder.decode(Match.self, from: matchJSON)
            NSLog("Match with id \(match.id!) decoded")
        } catch{
            NSLog("Unable to decode match JSON")
        }
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            NSLog("Unable to save changes to CoreData")
        }
        
        fetchMatches()
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) { }
    
    func sessionDidDeactivate(_ session: WCSession) { }
    
}
