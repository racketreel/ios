//
//  SignUpView.swift
//  RacketReel
//
//  Created by Tom Elvidge on 03/10/2021.
//

import SwiftUI

struct RegisterView: View {
    
    @ObservedObject var viewModel = RegisterViewModel()
    @Binding var currentSubview: AuthenticationSubview
    
    var body: some View {
        if (viewModel.showRegisteringSpinner) {
            HStack {
                ActivityIndicator(isAnimating: $viewModel.showRegisteringSpinner, style: .medium)
                Text("Registering...")
            }
            .foregroundColor(.gray)
        } else {
            VStack {
                // Names
                HStack {
                    TextField("Firstname", text: $viewModel.firstname)
                    TextField("Surname", text: $viewModel.surname)
                }
                
                TextField("Email", text: $viewModel.email)
                    .disableAutocorrection(true)
                    .autocapitalization(UITextAutocapitalizationType.none)
                
                // Password
                SecureField("Password", text: $viewModel.password)
                SecureField("Confirm Password", text: $viewModel.confirmPassword)
                
                // Register button
                Button("Register") {
                    viewModel.register()
                }
                    .buttonStyle(GrowingPrimaryButtonStyle())
                    .padding(.top)
                
                // Back to Log In
                Button("I already have an account") {
                    self.currentSubview = AuthenticationSubview.LogIn
                }
                    .foregroundColor(Color.gray)
            }
                .textFieldStyle(RRTextFieldStyle())
                .alert(isPresented: $viewModel.showRegisterFailedAlert) {
                    Alert(
                        title: Text("Cannot Register"),
                        message: Text(viewModel.registerFailedAlertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
        }
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        Resolver.shared.setContainer(PreviewContainer.build())
        return RegisterView(currentSubview: .constant(AuthenticationSubview.Register))
    }
}
