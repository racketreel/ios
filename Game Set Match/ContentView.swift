//
//  ContentView.swift
//  Game Set Match
//
//  Created by Tom Elvidge on 17/07/2021.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var model = ViewModelPhone()
    
    var body: some View {
        ForEach (model.matches, id: \.self) { match in
            Text(match.id)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
