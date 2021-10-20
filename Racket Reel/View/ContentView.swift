//
//  ContentView.swift
//  RacketReel
//
//  Created by Tom Elvidge on 03/10/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @StateObject var videoEditor = VideoEditor()
    
    var auth: AuthProtocol
    @ObservedObject var viewModel: ContentViewModel
    
    init(auth: AuthProtocol) {
        self.auth = auth
        self.viewModel = ContentViewModel(auth: auth)
    }

    var body: some View {
        NavigationView {
            if (viewModel.isSignedIn) {
                TabView {
                    NewMatchView()
                        .tabItem {
                            Image(systemName: "plus")
                        }
                    MainView()
                        .environmentObject(videoEditor)
                        .tabItem {
                            Image(systemName: "house")
                        }
                    UserView(auth: self.auth)
                        .tabItem {
                            Image(systemName: "person")
                        }
                }
            } else {
                LogInView(viewModel: LogInViewModel(auth: auth))
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(auth: PreviewAuth()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
