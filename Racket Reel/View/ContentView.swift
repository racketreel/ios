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
            TabView(selection: $viewModel.tabSelected) {
                NewMatchView()
                    .tabItem {
                        Image(systemName: "plus")
                    }
                    .tag(1)
                MainView()
                    .environmentObject(videoEditor)
                    .tabItem {
                        Image(systemName: "house")
                    }
                    .tag(2)
                UserView()
                    .tabItem {
                        Image(systemName: "person")
                    }
                    .tag(3)
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
