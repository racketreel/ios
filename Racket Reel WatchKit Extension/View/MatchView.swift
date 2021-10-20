//
//  MatchView.swift
//  Racket Reel WatchKit Extension
//
//  Created by Tom Elvidge on 24/07/2021.
//

import SwiftUI

struct MatchView: View {
    
    @ObservedObject var model: ViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                ScoreBoardView(tState: model.tMatch!.states.last!)
                Button("First Serve", action: {
                    model.newtEvent(event: TennisEventType.FirstServe)
                })
                Button("Second Serve", action: {
                    model.newtEvent(event: TennisEventType.SecondServe)
                })
                Button("Fault", action: {
                    model.newtEvent(event: TennisEventType.Fault)
                })
                Button("Let", action: {
                    model.newtEvent(event: TennisEventType.Let)
                })
                Button("Point won", action: {
                    model.newtEvent(event: TennisEventType.TeamOnePoint)
                })
                Button("Point lost", action: {
                    model.newtEvent(event: TennisEventType.TeamTwoPoint)
                })
                Button("Undo", action: {
                    model.undotEvent()
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
