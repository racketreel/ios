//
//  AuthenticationView.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 20/10/2021.
//

import SwiftUI

struct AuthenticationView: View {
    
    @State var currentSubview: AuthenticationSubview = AuthenticationSubview.None
    
    var body: some View {
        ZStack {
            // Custom background color.
            Color("Background")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .cornerRadius(30)
                    .padding(30)
                if (currentSubview == AuthenticationSubview.LogIn) {
                    LogInView(currentSubview: $currentSubview)
                } else if (currentSubview == AuthenticationSubview.Register) {
                    RegisterView(currentSubview: $currentSubview)
                } else { // currentSubview == AuthenticationSubview.None
                    // Log In
                    Button("Log In") {
                        self.currentSubview = AuthenticationSubview.LogIn
                    }
                        .buttonStyle(PrimaryButtonStyle(fillWidth: true))
                    // Register
                    Button("Register") {
                        self.currentSubview = AuthenticationSubview.Register
                    }
                        .buttonStyle(SecondaryButtonStyle(fillWidth: true))
                }
            }
                .padding()
        }
            .edgesIgnoringSafeArea(.all)
    }
    
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        Resolver.shared.setContainer(PreviewContainer.build())
        return AuthenticationView()
    }
}
