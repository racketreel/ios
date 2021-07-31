//
//  WelcomeView.swift
//  Game Set Match WatchKit Extension
//
//  Created by Tom Elvidge on 24/07/2021.
//

import SwiftUI

struct WelcomeView: View {
    
    @ObservedObject var model: ViewModel
    
    var body: some View {
        VStack {
            Button("New Match", action: {
                model.currentView = ViewType.matchSetUp
            })
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(model: ViewModel())
    }
}
