//
//  FirebaseFirestoreAuth.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 10/10/2021.
//
//  Maintain an instance of RacketReel.User using Firebase Authentication
//  and user data stored in Firestore. The user is updated whenever there are
//  changes to the user in either Firebase Authentication or Firestore and
//  observers can listen to changes to this user. Also provides authentication
//  functions which are wrappers on existing functions in Firebase Authentication
//  and Firestore.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseFirestoreAuth : AuthProtocol {

    private struct FirestoreUserData: Codable {
        var firstname: String
        var surname: String
    }

    // Extra user data store in Firestore
    private let db = Firestore.firestore()
    private var firestoreUserData: FirestoreUserData? {
        didSet {
            if let firestoreUserData = self.firestoreUserData {
                // Copy Firestore user data into RacketReel.User
                self.user?.firstname = firestoreUserData.firstname
                self.user?.surname = firestoreUserData.surname
            } else {
                // Cannot get user data then set as nil
                // User may still be logged in so just clear fields
                self.user?.firstname = nil
                self.user?.surname = nil
            }
        }
    }
    // Keep reference to listener so it can be removed if the user logs out
    private var firestoreUserDataListener: ListenerRegistration?

    private let auth = Auth.auth()
    private var firebaseAuthUser: FirebaseAuth.User? {
        didSet {
            if let firebaseAuthUser = self.firebaseAuthUser {
                // Create RacketReel.User from FirebaseAuth.User
                self.user = User(
                    uid: firebaseAuthUser.uid,
                    email: firebaseAuthUser.email,
                    verifiedEmail: firebaseAuthUser.isEmailVerified
                )
            } else {
                // Reset user to sign if logged out
                self.user = nil
            }
        }
    }

    var user: User? {
        didSet {
            // Notify userObservers that user changed
            for observer in userObservers {
                observer(self.user)
            }
        }
    }

    var userObservers: [UserUpdate]

    public init() {
        self.userObservers = []

        // Listen for changes to Firebase Authentication
        auth.addStateDidChangeListener{ auth, user in
            // Todo: Log errors

            // Update firebaseUser
            self.firebaseAuthUser = user

            // If user logged in
            if let user = user {
                // Listen for changes to user's data in Firestore
                self.firestoreUserDataListener = self.db.collection("users").document(user.uid)
                    .addSnapshotListener { documentSnapshot, error in
                        // Update firestoreUserData
                        try? self.firestoreUserData = documentSnapshot?.data(as: FirestoreUserData.self)
                        // Todo: Log errors
                    }
            } else {
                // Clear old user data listener
                self.firestoreUserDataListener?.remove()
                self.firestoreUserData = nil
            }
        }
    }

    func logIn(email: String, password: String, completion: @escaping AuthTaskCompletion) {
        if (email.isEmpty) {
            completion(LogInError.emptyEmail)
            return
        }
        if (password.isEmpty) {
            completion(LogInError.emptyPassword)
            return
        }
        
        auth.signIn(withEmail: email, password: password) { authResult, error in
            completion(error)
        }
    }

    func logOut(completion: @escaping AuthTaskCompletion) {
        do {
            try auth.signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }

    func register(email: String, password: String, confirmPassword: String, firstname: String, surname: String, completion: @escaping AuthTaskCompletion) {
        // Custom validation and error messages.
        if (password != confirmPassword) {
            completion(RegistrationError.passwordDoesNotMatch)
            return
        }
        if (firstname.isEmpty) {
            completion(RegistrationError.emptyFirstname)
            return
        }
        if (surname.isEmpty) {
            completion(RegistrationError.emptySurname)
            return
        }
        
        
        // Try create user, Firebase does some additional validation.
        auth.createUser(withEmail: email, password: password, completion: { authResult, error in
            // If user was created add additional user data to Firestore.
            if let user = authResult?.user {
                let uid = user.uid
                self.db.collection("users").document(uid).setData([
                    "firstname": firstname,
                    "surname": surname
                ]) { error in
                    if let error = error {
                        // Created user but could not add user data
                        // Todo: Add custom error here so it can be logged in the completion block
                        completion(error)
                    } else {
                        // Created user and added user data
                        completion(nil)
                    }
                }
            }

            // Could not create user
            completion(error)
        })
    }

    func sendEmailVerification(completion: @escaping AuthTaskCompletion) {
        if (auth.currentUser != nil) {
            auth.currentUser!.sendEmailVerification(completion: completion)
        } else {
            completion(AuthError.notSignedIn)
        }
    }

    func sendPasswordReset(email: String, completion: @escaping AuthTaskCompletion) {
        auth.sendPasswordReset(withEmail: email, completion: completion)
    }

    func updateEmail(to: String, completion: @escaping AuthTaskCompletion) {
        if (auth.currentUser != nil) {
            auth.currentUser!.updateEmail(to: to, completion: completion)
        } else {
            completion(AuthError.notSignedIn)
        }
    }

    func updateUserData(firstname: String, surname: String, completion: @escaping AuthTaskCompletion) {
        if let user = self.user {
            // Update user data in Firestore
            let firestoreUserData = FirestoreUserData(firstname: firstname, surname: surname)
            do {
                try self.db.collection("users").document(user.uid).setData(from: firestoreUserData) { error in
                    if let error = error {
                        // Cannot update user data
                        completion(error)
                    } else {
                        // Updated user data
                        completion(nil)
                    }
                }
            } catch let error {
                // Cannot encode user data
                completion(error)
            }
        } else {
            completion(AuthError.notSignedIn)
        }
    }

}
