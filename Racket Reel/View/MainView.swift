//
//  ContentView.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 17/07/2021.
//

import SwiftUI
import WatchConnectivity

struct MainView: View {
    
    @ObservedObject var viewModel = MainViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach (viewModel.matches, id: \.self) { match in
                    MatchListItemView(match: match)
                }
                .onDelete(perform: viewModel.deleteMatches)
            }
            .navigationTitle("Matches")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Resolver.shared.setContainer(PreviewContainer.build())
        return MainView()
    }
}
