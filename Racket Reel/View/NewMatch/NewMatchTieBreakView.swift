//
//  NewMatchTieBreakView.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 24/10/2021.
//

import SwiftUI

struct NewMatchTieBreakView: View {
    
    @Binding var finalSetTieBreak: Bool
    @Binding var pointsForTieBreak: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("What are the minimum points needed to win a tie break?")
            HStack {
                Button("7", action: {
                    self.pointsForTieBreak = 7
                })
                    .buttonStyle(SelectableButtonStyle(selected: self.pointsForTieBreak == 7))
                Button("12", action: {
                    self.pointsForTieBreak = 12
                })
                    .buttonStyle(SelectableButtonStyle(selected: self.pointsForTieBreak == 12))
            }
            Text("Allow a tie break in the deciding set?")
            HStack {
                Button("Yes", action: {
                    self.finalSetTieBreak = true
                })
                    .buttonStyle(SelectableButtonStyle(selected: finalSetTieBreak))
                Button("No", action: {
                    self.finalSetTieBreak = false
                })
                    .buttonStyle(SelectableButtonStyle(selected: !finalSetTieBreak))
            }
        }
    }
}

struct NewMatchTieBreakView_Previews: PreviewProvider {
    static var previews: some View {
        NewMatchTieBreakView(finalSetTieBreak: .constant(false), pointsForTieBreak: .constant(7))
    }
}
