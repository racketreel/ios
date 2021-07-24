//
//  ViewModelWatch.swift
//  Game Set Match WatchKit Extension
//
//  Created by Tom Elvidge on 23/07/2021.
//

import Foundation
import WatchConnectivity

class ViewModelWatch : NSObject, WCSessionDelegate {
    
    var session: WCSession?
    
    override init() {
        super.init()
        
        if WCSession.isSupported() {
            self.session = WCSession.default
            self.session!.delegate = self
            self.session!.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
        
}
