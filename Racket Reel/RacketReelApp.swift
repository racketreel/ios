//
//  Game_Set_MatchApp.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 17/07/2021.
//

import SwiftUI
import WatchConnectivity
import Firebase

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
            ContentView(auth: FirebaseFirestoreAuth())
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
        return true
    }
}
