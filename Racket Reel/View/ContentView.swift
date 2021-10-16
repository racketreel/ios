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
                MatchListView(auth: self.auth)
                    .environmentObject(videoEditor)
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
