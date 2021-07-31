//
//  MatchOverView.swift
//  Game Set Match WatchKit Extension
//
//  Created by Tom Elvidge on 24/07/2021.
//

import SwiftUI

struct MatchOverView: View {
    
    @ObservedObject var model: ViewModelWatch
    
    var body: some View {
        VStack {
            Button("Save match to iPhone", action: {
                model.saveMatch()
            })
            Button("Done", action: {
                model.changeView(view: ViewType.welcome)
            })
        }
    }
}

struct MatchOverView_Previews: PreviewProvider {
    static var previews: some View {
        MatchOverView(model: ViewModelWatch())
    }
}