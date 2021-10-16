//
//  ContentView.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 17/07/2021.
//

import SwiftUI
import WatchConnectivity

struct MatchListView: View {
    
    @EnvironmentObject var videoEditor: VideoEditor
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(
        entity: Match.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Match.id_, ascending: true)
        ]
    ) var matches: FetchedResults<Match>
    
    var body: some View {
        VStack(alignment: .center, spacing: 0, content: {
            if (videoEditor.progress != nil) {
                Text(String(videoEditor.progress!))
            }
            NavigationView {
                List {
                    ForEach (matches, id: \.self) { match in
                        MatchListItemView(match: match)
                    }
                    .onDelete(perform: deleteMatches)
                }
                .navigationTitle("Matches")
                .navigationBarTitleDisplayMode(.inline)
                .alert(isPresented: $videoEditor.success) {
                    Alert(title: Text("Done"), message: Text("Match video exported to Photo Library"), dismissButton: .default(Text("OK")))
                }
            }
            .alert(isPresented: $videoEditor.error) {
                Alert(title: Text("Error"), message: Text("Could not process match video"), dismissButton: .default(Text("OK")))
            }
        })
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
