//
//  NewMatchGamesView.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 24/10/2021.
//

import SwiftUI

struct NewMatchGamesView: View {
    
    @Binding var games: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("How many games to win the set?")
            HStack {
                Button("1", action: {
                    self.games = 1
                })
                    .buttonStyle(SelectableButtonStyle(selected: self.games == 1))
                Button("6", action: {
                    self.games = 6
                })
                    .buttonStyle(SelectableButtonStyle(selected: self.games == 6))
            }
        }
    }
}

struct NewMatchGamesView_Previews: PreviewProvider {
    static var previews: some View {
        NewMatchGamesView(games: .constant(1))
    }
}
