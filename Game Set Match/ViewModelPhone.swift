//
//  ViewModelPhone.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 23/07/2021.
//

import Foundation
import WatchConnectivity

class ViewModelPhone : NSObject, ObservableObject, WCSessionDelegate {
    
    var session: WCSession?
    @Published var matches: [Match] = []
    
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
        let decoder = JSONDecoder()
        do {
            let match = try decoder.decode(Match.self, from: match_json)
            // Publish changes to view from main thread
            DispatchQueue.main.async {
                self.matches.append(match)
            }
        } catch {
            print("cannot decode")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) { }
    
    func sessionDidDeactivate(_ session: WCSession) { }
    
}
