//
//  MatchView.swift
//  Game Set Match WatchKit Extension
//
//  Created by Tom Elvidge on 24/07/2021.
//

import SwiftUI

struct MatchView: View {
    
    @ObservedObject var model: ViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                ScoreBoardView(state: model.match!.currentState)
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
                Button("Quit", action: {
                    model.quit()
                })
            }
        }
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView(model: ViewModel())
    }
}
