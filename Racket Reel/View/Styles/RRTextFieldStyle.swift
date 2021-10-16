//
//  RRTextFieldStyle.swift
//  RacketReel
//
//  Created by Tom Elvidge on 03/10/2021.
//

import Foundation
import SwiftUI

struct RRTextFieldStyle: TextFieldStyle  {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding()
            .background(Color.white)
            .cornerRadius(10)
    }
}

