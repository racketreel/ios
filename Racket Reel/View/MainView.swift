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
    
    // Todo: display loading icon when getting from firestore
    
    var body: some View {
        NavigationView {
            ZStack {
                // Custom background color.
                Color("Background")
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack {
                        ForEach (viewModel.matches, id: \.self) { match in
                            MatchListItemView(match: match)
                        }
                        .onDelete(perform: viewModel.deleteMatches)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Matches")
                }
            }
        }
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Resolver.shared.setContainer(PreviewContainer.build())
        return MainView()
    }
}
