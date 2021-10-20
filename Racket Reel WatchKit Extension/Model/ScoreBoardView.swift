//
//  ScoreBoardView.swift
//  Racket Reel WatchKit Extension
//
//  Created by Tom Elvidge on 24/07/2021.
//

import SwiftUI

struct ScoreBoardView: View {
    
    let tState: TennisState
    
    var body: some View {
        HStack {
            // Player
            VStack {
                HStack {
                    Text("ME")
                    Image(systemName: "circle.fill")
                        .font(.system(size: 6))
                        .opacity(tState.serving == Team.One ? 1 : 0)
                }
                HStack {
                    Text("OP")
                    Image(systemName: "circle.fill")
                        .font(.system(size: 6))
                        .opacity(tState.serving == Team.Two ? 1 : 0)
                }
            }
            // Sets
            VStack {
                Text(String(tState.scores[Team.One]!.sets))
                Text(String(tState.scores[Team.Two]!.sets))
            }
            // Games
            VStack {
                Text(String(tState.scores[Team.One]!.games))
                Text(String(tState.scores[Team.Two]!.games))
            }
            // Points
            VStack {
                Text(displayablePoint(team: Team.One))
                Text(displayablePoint(team: Team.Two))
            }
        }
    }
    
    func displayablePoint(team: Team) -> String {
        let intPoints = self.tState.scores[team]!.points
        if tState.isTieBreak {
            return String(intPoints)
        } else {
            return TennisPoint(rawValue: intPoints)?.forScoreboard ?? "ERR"
        }
    }
    
}

struct ScoreBoardView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreBoardView(tState: TennisMatch.empty.initialState)
    }
}
