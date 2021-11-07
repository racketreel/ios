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
    
    @Inject var auth: AuthenticationProvider
    
    func logIn() {
        // Ensure fields are valid before attempting to log in
        do {
            try validate()
        } catch {
            self.showLogInFailedAlert = true
            self.logInFailedAlertMessage = error.localizedDescription
            return
        }
        
        // Show spinner while attempting to log in
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
        auth.sendPasswordReset(to: self.email, completion: { error in
            if (error != nil) {
                self.passwordResetEmailAlertMessage = error!.localizedDescription
            } else {
                self.passwordResetEmailAlertMessage = "A password reset email has been sent."
            }
            self.showPasswordResetEmailAlert = true
        })
    }
    
    func validate() throws {
        if (password.isEmpty) {
            throw LogInError.emptyPassword
        }
        
        if (email.isEmpty) {
            throw LogInError.emptyEmail
        }
    }
    
}

public enum LogInError: Error {
    case emptyEmail
    case emptyPassword
}

extension LogInError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .emptyEmail:
                return NSLocalizedString("Email cannot be empty.", comment: "Empty Email")
            case .emptyPassword:
                return NSLocalizedString("Password cannot be empty.", comment: "Empty Password")
        }
    }
}
