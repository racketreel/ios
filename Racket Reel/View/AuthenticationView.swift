//
//  AuthenticationView.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 20/10/2021.
//

import SwiftUI

struct AuthenticationView: View {
    
    var auth: AuthProtocol
    
    @State var currentSubview: AuthenticationSubview = AuthenticationSubview.None
    
    init(auth: AuthProtocol) {
        self.auth = auth
    }
    
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
                    LogInView(viewModel: LogInViewModel(auth: self.auth), currentSubview: $currentSubview)
                } else if (currentSubview == AuthenticationSubview.Register) {
                    RegisterView(viewModel: RegisterViewModel(auth: self.auth), currentSubview: $currentSubview)
                } else { // currentSubview == AuthenticationSubview.None
                    // Log In
                    Button("Log In") {
                        self.currentSubview = AuthenticationSubview.LogIn
                    }
                        .buttonStyle(GrowingPrimaryButtonStyle())
                    // Register
                    Button("Register") {
                        self.currentSubview = AuthenticationSubview.Register
                    }
                        .buttonStyle(GrowingSecondaryButtonStyle())
                }
            }
                .padding()
        }
            .edgesIgnoringSafeArea(.all)
    }
    
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(auth: PreviewAuth())
    }
}
