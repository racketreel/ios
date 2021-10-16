//
//  CoreDataWCSessionDelegate.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 23/08/2021.
//

import Foundation
import CoreData
import WatchConnectivity

class CoreDataWCSessionDelegate: NSObject, WCSessionDelegate {
    
    private var persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        NSLog("didReceiveApplicationContext : \(applicationContext)")
        
        let matchData = applicationContext["match"] as! Data
        // print(matchData)
        
        // Decode matchData
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        // Add decoded Match to CoreData
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = persistenceController.container.viewContext
        do {
            _ = try decoder.decode(Match.self, from: matchData)
        } catch{
            print("Unable to decode: \(error.localizedDescription)")
        }
        
        // Save the new match to CoreData
        persistenceController.save()
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) { }
    
    func sessionDidDeactivate(_ session: WCSession) { }
    
}
