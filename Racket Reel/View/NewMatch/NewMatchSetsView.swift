//
//  NewMatchSetsView.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 24/10/2021.
//

import SwiftUI

struct NewMatchSetsView: View {
    
    @Binding var sets: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("How many sets to win the match?")
            HStack {
                Button("1", action: {
                    self.sets = 1
                })
                    .buttonStyle(SelectableButtonStyle(selected: self.sets == 1))
                Button("2", action: {
                    self.sets = 2
                })
                    .buttonStyle(SelectableButtonStyle(selected: self.sets == 2))
                Button("3", action: {
                    self.sets = 3
                })
                    .buttonStyle(SelectableButtonStyle(selected: self.sets == 3))
            }
        }
    }
}

struct NewMatchSetsView_Previews: PreviewProvider {
    static var previews: some View {
        NewMatchSetsView(sets: .constant(1))
    }
}
