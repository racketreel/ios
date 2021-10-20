//
//  SignInView.swift
//  RacketReel
//
//  Created by Tom Elvidge on 03/10/2021.
//

import SwiftUI

struct LogInView: View {
    
    @ObservedObject var viewModel: LogInViewModel
    @Binding var currentSubview: AuthenticationSubview

    init(viewModel: LogInViewModel, currentSubview: Binding<AuthenticationSubview>) {
        self.viewModel = viewModel
        self._currentSubview = currentSubview
    }
    
    var body: some View {
        // Todo: Animation between these
        if (viewModel.showLoggingInSpinner) {
            HStack {
                ActivityIndicator(isAnimating: $viewModel.showLoggingInSpinner, style: .medium)
                Text("Logging In...")
            }
                .foregroundColor(Color.gray)
        } else {
            VStack {
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RRTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(UITextAutocapitalizationType.none)
                
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RRTextFieldStyle())
                
                // Forgot Password
                Button(action: {
                    viewModel.forgotPassword()
                }, label: {
                    Text("I forgot my password")
                        .foregroundColor(Color.gray)
                })
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .alert(isPresented: $viewModel.showPasswordResetEmailAlert) {
                        Alert(
                            title: Text("Password Reset"),
                            message: Text(viewModel.passwordResetEmailAlertMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                
                // Log In
                Button("Log In") {
                    viewModel.logIn()
                }
                    .buttonStyle(GrowingPrimaryButtonStyle())
                    .alert(isPresented: $viewModel.showLogInFailedAlert) {
                        Alert(
                            title: Text("Cannot Log In"),
                            message: Text(viewModel.logInFailedAlertMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                
                // Register
                Button("Register") {
                    self.currentSubview = AuthenticationSubview.Register
                }
                    .buttonStyle(GrowingSecondaryButtonStyle())
            }
        }
    }
    
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView(viewModel: LogInViewModel(auth: PreviewAuth()), currentSubview: .constant(AuthenticationSubview.LogIn))
    }
}
