//
//  ContentView.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 17/07/2021.
//

import SwiftUI
import WatchConnectivity

struct MatchListView: View {
    
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(
        entity: Match.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Match.id_, ascending: true)
        ]
    ) var matches: FetchedResults<Match>
    
    var body: some View {
        NavigationView {
            List {
                ForEach (matches, id: \.self) { match in
                    MatchListItemView(match: match)
                }
                .onDelete(perform: deleteMatches)
            }
            .navigationTitle("Matches")
        }
    }
    
    func deleteMatches(at offsets: IndexSet) {
        for index in offsets {
            let match = matches[index]
            managedObjectContext.delete(match)
        }
    }
    
}

struct MatchListView_Previews: PreviewProvider {
    static var previews: some View {
        MatchListView()
            .environment(\.managedObjectContext,
                PersistenceController.preview.container.viewContext)
    }
}
