//
//  LoggingButton.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 29/10/2021.
//

import SwiftUI

struct LoggingButton: View {
    
    let text: String
    let action: () -> Void
    let enabled: Bool
    
    init(text: String, enabled: Bool, action: @escaping () -> Void) {
        self.text = text
        self.enabled = enabled
        self.action = action
    }

    var body: some View {
        Button(text) {
            self.action()
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .buttonStyle(LoggingButtonStyle(enabled: self.enabled))
            .disabled(!self.enabled)
    }
}

struct LoggingButton_Previews: PreviewProvider {
    static var previews: some View {
        LoggingButton(text: "First Serve", enabled: true, action: {})
    }
}
