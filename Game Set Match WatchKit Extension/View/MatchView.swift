//
//  MatchView.swift
//  Game Set Match WatchKit Extension
//
//  Created by Tom Elvidge on 24/07/2021.
//

import SwiftUI

struct MatchView: View {
    
    @ObservedObject var model: ViewModelWatch
    
    var body: some View {
        ScrollView {
            VStack {
                Button("Quit", action: {
                    model.changeView(view: ViewType.welcome)
                })
                // Force unwrap as match must have been set if displaying MatchView
//                ScoreBoardView(matchState: model.match!.currentState)
                ScoreBoardView(model: model)
                Button("Serve", action: {
                    model.applyServe()
                })
                Button("Point won", action: {
                    model.applyWin()
                })
                Button("Point lost", action: {
                    model.applyLoss()
                })
                Button("Undo", action: {
                    model.undo()
                })
            }
        }
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView(model: ViewModelWatch())
    }
}
