//
//  MatchListItemView.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 24/07/2021.
//

import SwiftUI

struct MatchListItemView: View {
    
    let match: Match
    
    init(match: Match) {
        self.match = match
    }
    
    var body: some View {
        VStack {
            Text(self.match.id!)
            Text("\(self.match.history!.count) events in match")
        }
    }
}

struct MatchListItemView_Previews: PreviewProvider {
    static var previews: some View {
        MatchListItemView(match: Match())
    }
}