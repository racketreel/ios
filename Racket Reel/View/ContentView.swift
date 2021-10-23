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
    @ObservedObject var viewModel = ContentViewModel()

    var body: some View {
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
                UserView()
                    .tabItem {
                        Image(systemName: "person")
                    }
            }
        } else {
            AuthenticationView()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Resolver.shared.setContainer(PreviewContainer.build())
        return ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
