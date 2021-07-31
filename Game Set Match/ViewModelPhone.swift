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
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        NSLog("didReceiveApplicationContext : %@", applicationContext)
        let match_json = applicationContext["match"] as! Data
        print(match_json)
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = persistentContainer.viewContext
        do {
            
            let match = try decoder.decode(Match.self, from: match_json)
            print(match.id!)
//            // Publish changes to view from main thread
//            DispatchQueue.main.async {
//                self.matches.append(match)
//                print("done")
//            }
        } catch{
            print(error)
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) { }
    
    func sessionDidDeactivate(_ session: WCSession) { }
    
}
