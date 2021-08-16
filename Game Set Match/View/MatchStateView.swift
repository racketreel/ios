//
//  MatchStateView.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 16/08/2021.
//

import SwiftUI

struct MatchStateView: View {
    
    var state: MatchState
    
    var body: some View {
        HStack {
            ScoreBoardView(state: state)
            VStack(alignment: .leading) {
                Text(state.generationEvent.description)
                    .font(.system(size: 16))
                Text(String(state.generationEventTimestamp)) // todo format date
                Text(state.pointDescription == .None ? "" : state.pointDescription.description)
                Text(state.breakPoint ? "Break Point" : "")
                Spacer() // todo use frame
            }
            .font(.system(size: 12))
        }
    }
}

struct MatchStateView_Previews: PreviewProvider {
    static var previews: some View {
        MatchStateView(state: MatchState())
    }
}
