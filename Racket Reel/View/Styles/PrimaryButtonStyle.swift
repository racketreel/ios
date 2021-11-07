//
//  GrowingPrimaryButtonStyle.swift
//  RacketReel
//
//  Created by Tom Elvidge on 03/10/2021.
//

import Foundation
import SwiftUI

struct PrimaryButtonStyle: ButtonStyle  {
    
    let fillWidth: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: fillWidth ? .infinity : .none) // Fill width
            .padding(12)
            .background(
                Color("Primary") // Primary fill
                    .opacity(configuration.isPressed ? 0.5 : 1) // On press animation
            )
            .foregroundColor(Color.white) // White text
            .cornerRadius(10)
    }
}
