//
//  SignInViewModel.swift
//  RacketReel
//
//  Created by Tom Elvidge on 09/10/2021.
//

import Foundation

class LogInViewModel: ObservableObject {
    
    // View's text fields
    @Published var email = ""
    @Published var password = ""
    
    @Published var showLoggingInSpinner = false
    
    @Published var showLogInFailedAlert = false
    @Published var logInFailedAlertMessage = ""
    
    @Published var showPasswordResetEmailAlert = false
    @Published var passwordResetEmailAlertMessage = ""
    
    @Inject var auth: AuthProtocol
    
    func logIn() {
        // Show spinner while attempting to sign in
        self.showLoggingInSpinner = true
        
        auth.logIn(email: self.email, password: self.password, completion: { error in
            // Completed attempting to sign in
            self.showLoggingInSpinner = false
            
            // If failed to sign in then show alert and show error
            if (error != nil) {
                self.showLogInFailedAlert = true
                self.logInFailedAlertMessage = error!.localizedDescription
            }
        })
    }
    
    func forgotPassword() {
        auth.sendPasswordReset(email: self.email, completion: { error in
            if (error != nil) {
                self.passwordResetEmailAlertMessage = error!.localizedDescription
            } else {
                self.passwordResetEmailAlertMessage = "A password reset email has been sent."
            }
            self.showPasswordResetEmailAlert = true
        })
    }
    
}
