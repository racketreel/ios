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
        NavigationLink(destination: MatchView(match: match)) {
            HStack {
                Text(time())
            }
        }
    }
    
    func time() -> String {
        let optTimestamp = (self.match.history?.array[0] as? MatchState)?.generationEventTimestamp
        return optTimestamp == nil ? "" : String(optTimestamp!)
    }
}

struct MatchListItemView_Previews: PreviewProvider {
    static var previews: some View {
        MatchListItemView(model: ViewModelPhone(), match: Match())
    }
}
