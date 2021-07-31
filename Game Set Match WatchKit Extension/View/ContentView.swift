//
//  ContentView.swift
//  Game Set Match WatchKit Extension
//
//  Created by Tom Elvidge on 24/07/2021.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var model = ViewModelWatch()
    
    var body: some View {
        if (model.currentView == ViewType.welcome) {
            WelcomeView(model: model)
        }
        if (model.currentView == ViewType.matchSetUp) {
            MatchSetUpView(model: model)
        }
        if (model.currentView == ViewType.matchInProgress) {
            MatchView(model: model)
        }
        if (model.currentView == ViewType.matchOver) {
            MatchOverView(model: model)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}