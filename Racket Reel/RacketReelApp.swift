//
//  Game_Set_MatchApp.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 17/07/2021.
//

import SwiftUI
import WatchConnectivity
import Firebase
import FirebaseFirestore
import Swinject

@main
struct RacketReelApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @Environment(\.scenePhase) var scenePhase
    let persistenceController = PersistenceController.shared
    
    private var watchSession: WCSession?
    private var watchSessionDelegate: CoreDataWCSessionDelegate?
    
    init() {
        if WCSession.isSupported() {
            watchSession = WCSession.default
            watchSessionDelegate = CoreDataWCSessionDelegate(persistenceController: persistenceController)
            watchSession!.delegate = watchSessionDelegate
            watchSession!.activate()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
            .onChange(of: scenePhase) { _ in
                // Save CoreData changes when app goes to background
                persistenceController.save()
            }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        if (ProcessInfo.processInfo.environment["USE_FIREBASE_EMULATORS"] == "YES") {
            // Authentication
            Auth.auth().useEmulator(withHost:"localhost", port:9099)
            
            // Firestore
            let settings = Firestore.firestore().settings
            settings.host = "localhost:8080"
            settings.isPersistenceEnabled = false
            settings.isSSLEnabled = false
            Firestore.firestore().settings = settings
        }
        
        return true
    }
}

