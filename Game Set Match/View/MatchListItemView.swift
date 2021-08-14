//
//  MatchListItemView.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 24/07/2021.
//

import SwiftUI

struct MatchListItemView: View {
    
    @ObservedObject var model: ViewModel
    let match: Match
    
    var body: some View {
        NavigationLink(destination: MatchView(model: model, match: match)) {
            HStack {
                Text(String(match.name))
            }
        }
    }
}

struct MatchListItemView_Previews: PreviewProvider {
    static var previews: some View {
        MatchListItemView(model: ViewModel(), match: Match())
    }
}
