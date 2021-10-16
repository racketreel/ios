//
//  SignUpView.swift
//  RacketReel
//
//  Created by Tom Elvidge on 03/10/2021.
//

import SwiftUI

struct RegisterView: View {
    
    // Allow custom dissmiss/back button
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var viewModel: RegisterViewModel
    
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
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
                
                if (viewModel.showRegisteringSpinner) {
                    HStack {
                        ActivityIndicator(isAnimating: $viewModel.showRegisteringSpinner, style: .medium)
                        Text("Registering...")
                    }
                    .foregroundColor(.gray)
                } else {
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
                        presentationMode.wrappedValue.dismiss()
                    }
                        .foregroundColor(Color.gray)
                }
            }
            .padding()
            .textFieldStyle(RRTextFieldStyle())
        }
        .navigationBarHidden(true)
        .alert(isPresented: $viewModel.showRegisterFailedAlert) {
            Alert(
                title: Text("Register Failed"),
                message: Text(viewModel.registerFailedAlertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(viewModel: RegisterViewModel(auth: PreviewAuth()))
    }
}
