//
//  ContentView.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 17/07/2021.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var model = ViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach (model.matches, id: \.self) { match in
                    MatchListItemView(model: model, match: match)
                }
                .onDelete(perform: self.model.deleteMatches)
            }
            .navigationTitle("Matches")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
