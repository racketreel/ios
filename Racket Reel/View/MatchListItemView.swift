//
//  MatchListItemView.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 24/07/2021.
//

import SwiftUI

struct MatchListItemView: View {
    
    let match: TennisMatch
    
    var body: some View {
        NavigationLink(destination: MatchView(match: match)) {
            VStack(alignment: .leading) {
                Text(dformat(match.preferences.timestamp))
                    .fontWeight(.bold)
                    .padding(.bottom, 2)
                HStack {
                    VStack(alignment: .leading) {
                        Text(match.preferences.teams.dict[TeamNumber.One]!.name)
                        Text(match.preferences.teams.dict[TeamNumber.Two]!.name)
                    }
                    // Todo: Set scores
                }
            }
            .padding()
        }
        
    }
    
    func dformat(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a 'on' dd MMMM yyyy"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: date)
    }
    
}

struct MatchListItemView_Previews: PreviewProvider {
    static var previews: some View {
        MatchListItemView(match: TennisMatch.inProgress)
    }
}
