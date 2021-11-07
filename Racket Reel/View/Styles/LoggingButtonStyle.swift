//
//  LoggingButtonStyle.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 29/10/2021.
//

import SwiftUI

struct LoggingButtonStyle: ButtonStyle  {
    
    let enabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color(.white) // Primary fill
                    // Animation if enabled.
                    .opacity(enabled ? (configuration.isPressed ? 0.5 : 1) : 1)
            )
            .foregroundColor(enabled ? .black : .gray)
            .cornerRadius(20)
            .padding(10)
    }
}
