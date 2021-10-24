//
//  SelectableButtonStyle.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 23/10/2021.
//

import Foundation

import SwiftUI

struct SelectableButtonStyle: ButtonStyle  {
    
    let selected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(12)
            .background(
                Color(selected ? "Primary" : "CustomGray")
            )
            .foregroundColor(selected ? Color.white : Color.black)
            .cornerRadius(10)
    }
}
