//
//  ViewModelPhone.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 23/07/2021.
//

import Foundation
import WatchConnectivity
import CoreData

class ViewModelPhone : NSObject, ObservableObject, WCSessionDelegate {
    
    var session: WCSession?
    @Published var matches: [Match] = []
    
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
        
        // Get saved matches from core data
        getExistingMatches()
    }
    
    func getExistingMatches() {
        // Fetch matches from core data
        do {
            let matches: [Match] = try persistentContainer.viewContext.fetch(Match.fetchRequest())
            DispatchQueue.main.async {
                self.matches = matches
            }
        } catch {
            print("cannot fetch matches from core data")
        }
    }
    
    func deleteMatches(at indexSet: IndexSet) {
        indexSet.forEach { i in
            // Delete match
            let match = matches[i]
            self.persistentContainer.viewContext.delete(match)
            
            // Save changes in CoreData
            do {
                try self.persistentContainer.viewContext.save()
            } catch {
                print("Could not delete match...")
            }
        }
        // Reload matches
        getExistingMatches()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        // Get match from Apple Watch as json
        NSLog("didReceiveApplicationContext : %@", applicationContext)
        let match_json = applicationContext["match"] as! Data
        print(match_json)
        
        // Decode match json into Match class
        let decoder = JSONDecoder()
        // Add context to allow it to be saved in core data
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = persistentContainer.viewContext
        // Decode
        do {
            let match = try decoder.decode(Match.self, from: match_json)
            print("decode worked: \(match.id!)")
        } catch{
            print(error)
        }
        // Save to core data
        do {
            try persistentContainer.viewContext.save()
            print("saved!")
        } catch {
            print("save data error")
        }
        // Update matches from core data
        getExistingMatches()
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) { }
    
    func sessionDidDeactivate(_ session: WCSession) { }
    
}
