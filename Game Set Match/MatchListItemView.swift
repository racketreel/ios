//
//  MatchListItemView.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 24/07/2021.
//

import SwiftUI

struct MatchListItemView: View {
    
    @ObservedObject var model: ViewModelPhone
    let match: Match
    
    init(model: ViewModelPhone, match: Match) {
        self.model = model
        self.match = match
    }
    
    var body: some View {
        VStack {
            Text(self.match.id ?? "ehh")
            Text("\(self.match.history?.count ?? 0) events in match")
            Button("Delete", action: {
                model.deleteMatch(match: self.match)
            })
        }
    }
}

struct MatchListItemView_Previews: PreviewProvider {
    static var previews: some View {
        MatchListItemView(model: ViewModelPhone(), match: Match())
    }
}
