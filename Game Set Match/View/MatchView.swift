//
//  MatchView.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 31/07/2021.
//

import SwiftUI

struct MatchView: View {
    
    let match: Match
    
    var body: some View {
        List {
            ForEach ((match.history!.array as! [MatchState]), id: \.self) { matchState in
                HStack {
                    ScoreBoardView(state: matchState)
                    VStack(alignment: .leading) {
                        Text(matchState.generationEventType!)
                            .font(.system(size: 16))
                        Text(String(matchState.generationEventTimestamp))
                        if (matchState.pointType != "none") {
                            Text(matchState.pointType! + (matchState.breakPoint ? " and break" : ""))
                        }
                        Spacer()
                    }
                    .font(.system(size: 12))
                }
            }
        }
        .toolbar {
            Button("Cut Video", action: {
                // Todo
                print("Cutting video...")
            })
        }
        .navigationTitle(String((match.history!.array[0] as! MatchState).generationEventTimestamp))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView(match: Match())
    }
}
