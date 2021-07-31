//
//  ScoreBoardView.swift
//  Game Set Match WatchKit Extension
//
//  Created by Tom Elvidge on 24/07/2021.
//

import SwiftUI

struct ScoreBoardView: View {
    
    let state: MatchState
    
    var body: some View {
        HStack {
            // Player
            VStack {
                HStack {
                    Text("ME")
                    Image(systemName: "circle.fill")
                        .font(.system(size: 6))
                        .opacity(state.toServe ? 1 : 0)
                }
                HStack {
                    Text("OP")
                    Image(systemName: "circle.fill")
                        .font(.system(size: 6))
                        .opacity(state.toServe ? 0 : 1)
                }
            }
            // Sets
            VStack {
                Text(String(state.setsUser))
                Text(String(state.setsOpponent))
            }
            // Games
            VStack {
                Text(String(state.gamesUser))
                Text(String(state.gamesOpponent))
            }
            // Points
            VStack {
                Text(state.pointsUser!)
                Text(state.pointsOpponent!)
            }
        }
        .font(.system(size: 20))
        .padding(10)
        .background(Color(red: 0.9, green: 0.9, blue: 0.9))
        .cornerRadius(10)
    }
}

struct ScoreBoardView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreBoardView(state: MatchState())
    }
}
