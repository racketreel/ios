//
//  ScoreBoardView.swift
//  Game Set Match WatchKit Extension
//
//  Created by Tom Elvidge on 24/07/2021.
//

import SwiftUI

struct ScoreBoardView: View {
    
//    var matchState: MatchState
    @ObservedObject var model: ViewModelWatch
    
    var body: some View {
        HStack {
            // Player
            VStack {
                HStack {
                    Text("ME")
                    Image(systemName: "circle.fill")
                        .font(.system(size: 6))
//                        .opacity(matchState.toServe ? 1 : 0)
                        .opacity(model.match!.currentState.toServe ? 1 : 0)
                }
                HStack {
                    Text("OP")
                    Image(systemName: "circle.fill")
                        .font(.system(size: 6))
//                        .opacity(matchState.toServe ? 0 : 1)
                        .opacity(model.match!.currentState.toServe ? 0 : 1)
                }
            }
            // Sets
            VStack {
                Text(String(model.match!.currentState.setsUser))
                Text(String(model.match!.currentState.setsOpponent))
            }
            // Games
            VStack {
                Text(String(model.match!.currentState.gamesUser))
                Text(String(model.match!.currentState.gamesOpponent))
            }
            // Points
            VStack {
                Text(model.match!.currentState.pointsUser)
                Text(model.match!.currentState.pointsOpponent)
            }
        }
    }
}

struct ScoreBoardView_Previews: PreviewProvider {
    static var previews: some View {
//        ScoreBoardView(matchState: MatchState(toServe: true))
        ScoreBoardView(model: ViewModelWatch())
    }
}
