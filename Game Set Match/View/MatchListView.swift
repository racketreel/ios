//
//  ContentView.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 17/07/2021.
//

import SwiftUI

struct MatchListView: View {
    
    @ObservedObject var viewModel = MatchListViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach (viewModel.matches, id: \.self) { match in
                    MatchListItemView(match: match)
                }
                .onDelete(perform: self.viewModel.deleteMatches)
            }
            .navigationTitle("Matches")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MatchListView()
    }
}
