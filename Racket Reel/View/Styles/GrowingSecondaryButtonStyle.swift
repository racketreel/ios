//
//  GrowingSecondaryButtonStyle.swift
//  RacketReel
//
//  Created by Tom Elvidge on 03/10/2021.
//

import Foundation
import SwiftUI

struct GrowingSecondaryButtonStyle: ButtonStyle  {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity) // Fill width
            .padding(12)
            .background(
                Color("CustomGray") // Secondary fill
                    .opacity(configuration.isPressed ? 0.5 : 1) // On press animation
            )
            .foregroundColor(Color.black) // Black text
            .cornerRadius(10)
    }
}
