////
////  AuthIntegrationTests.swift
////  RacketReelTests
////
////  Created by Tom Elvidge on 10/10/2021.
////
//// Integration tests of FirebaseFirestoreAuth with Firebase backend.
////
//
//import XCTest
//@testable import Racket_Reel
//import Firebase
//
//class AuthIntegrationTests: XCTestCase {
//    
//    enum AuthTestError: Error {
//        case missingEnvironmentVariable(String)
//    }
//    
//    private var authService: FirebaseFirestoreAuth?
//    
//    private static let EMAIL_ENV = "AUTH_TEST_EMAIL"
//    private var testEmail = ProcessInfo.processInfo.environment[EMAIL_ENV]
//    
//    private static let PASSWORD_ENV = "AUTH_TEST_PASSWORD"
//    private var testPassword = ProcessInfo.processInfo.environment[PASSWORD_ENV]
//    
//    override func setUpWithError() throws {
//        // Do not run the tests if the environment variables have not been set.
//        if (testEmail == nil) {
//            throw AuthTestError.missingEnvironmentVariable("Environment variable \(AuthIntegrationTests.EMAIL_ENV) is missing.")
//        }
//        if (testPassword == nil) {
//            throw AuthTestError.missingEnvironmentVariable("Environment variable \(AuthIntegrationTests.PASSWORD_ENV) is missing.")
//        }
//        
//        // Reset authService before every test
//        self.authService = FirebaseFirestoreAuth()
//        
//        // Ensure user is signed out before each test
//        self.authService?.logOut(completion: { error in
//            if (error != nil) {
//                print(error!.localizedDescription)
//            }
//        })
//    }
//
//    func testLogInGetsFromFirebaseAuth() {
//        // Log in and store error
//        var e: Error?
//        let expectation = self.expectation(description: "Logging In")
//        authService!.logIn(email: testEmail!, password: testPassword!, completion: { error in
//            e = error
//            expectation.fulfill()
//        })
//        
//        // Wait for user to be logged in, or time out afer 5s
//        waitForExpectations(timeout: 5, handler: nil)
//        
//        // Assertions
//        XCTAssert(e == nil, "There should be no error when logging in.")
//        XCTAssert(self.authService?.user?.email == self.testEmail!, "The user's email should have been added to user from Firebase Auth.")
//    }
//    
//    func testUserObserverCalledAfterLogIn() {
//        // Update userLoggedIn every time there is a change to user
//        var userLoggedIn = false
//        authService!.addUserObserver { user in
//            if (user != nil) {
//                userLoggedIn = true
//            }
//        }
//        
//        // Log in and store error
//        let expectation = self.expectation(description: "Logging In")
//        var e: Error?
//        authService!.logIn(email: testEmail!, password: testPassword!, completion: { error in
//            e = error
//            expectation.fulfill()
//        })
//        
//        // Wait for user to be logged in, or time out afer 5s
//        waitForExpectations(timeout: 5, handler: nil)
//        
//        // Assertions
//        XCTAssert(e == nil, "There should be no error when logging in.")
//        XCTAssert(userLoggedIn, "userLoggedIn should have been updated to true by the user observer after log in.")
//    }
//    
//    func testUserObserverCalledAfterLogOut() {
//        // Update userLoggedIn every time there is a change to user
//        var userLoggedIn = false
//        authService!.addUserObserver { user in
//            if (user != nil) {
//                userLoggedIn = true
//            }
//        }
//        
//        // Log in and store error
//        let logInExpectation = self.expectation(description: "Logging In")
//        var logInError: Error?
//        authService!.logIn(email: testEmail!, password: testPassword!, completion: { error in
//            logInError = error
//            logInExpectation.fulfill()
//        })
//        
//        // Wait for user to be logged in, or time out afer 5s
//        waitForExpectations(timeout: 5, handler: nil)
//        
//        
//        // Log out
//        let logOutExpectation = self.expectation(description: "Logging Out")
//        var logOutError: Error?
//        authService!.logOut(completion: { error in
//            logOutError = error
//            logOutExpectation.fulfill()
//        })
//        // Wait for user to be logged out, or time out afer 5s
//        waitForExpectations(timeout: 5, handler: nil)
//        
//        // Assertions
//        XCTAssert(logInError == nil, "There should be no error when logging out.")
//        XCTAssert(logOutError == nil, "There should be no error when logging out.")
//        XCTAssert(userLoggedIn, "userLoggedIn should have been updated to false by the user observer after log out.")
//    }
//    
//    func testRegistrationCreatesExpectedUser() {
//        // New user details
//        let uuid = UUID().uuidString.lowercased()
//        let email = "\(uuid)@racketreeltests.com"
//        let password = uuid
//        let firstname = "Racket"
//        let surname = "Reel"
//        
//        // Update newUser every time there is a change to user
//        var newUser: Racket_Reel.User?
//        let expectation = self.expectation(description: "Registering")
//        authService!.addUserObserver { user in
//            newUser = user
//            
//            // Check recieved some correct user data from Firebase Auth (email) and Firestore (surname)
//            // Must check both since they are being updated from different sources
//            if (newUser?.email == email && newUser?.surname == surname) {
//                // User been updated to our newly registered user
//                expectation.fulfill()
//            }
//        }
//        
//        // Register the user.
//        var e: Error?
//        authService!.register(email: email, password: password, confirmPassword: password, firstname: firstname, surname: surname, completion: { error in
//            e = error
//        })
//        
//        // Wait for user to be registered and authService.user updated, or time out afer 10s
//        waitForExpectations(timeout: 10, handler: nil)
//        
//        // Assertions
//        XCTAssert(e == nil, "There should be no error when registering.")
//        XCTAssert(newUser?.email == email, "newUser should have the email passed into authService.register.")
//        XCTAssert(newUser?.firstname == firstname, "newUser should have the firstname passed into authService.register.")
//        XCTAssert(newUser?.surname == surname, "newUser should have the surname passed into authService.register.")
//    }
//    
//    func testUserObserverCalledAfterUserDataChanges() {
//        // Update firstname and surname every time there is a change to user
//        var firstname: String?
//        var surname: String?
//        authService!.addUserObserver { user in
//            firstname = user?.firstname
//            surname = user?.surname
//        }
//        
//        // Log in
//        let logInExpectation = self.expectation(description: "Logging In")
//        var logInError: Error?
//        authService!.logIn(email: testEmail!, password: testPassword!, completion: { error in
//            logInError = error
//            logInExpectation.fulfill()
//        })
//        
//        // Wait for user to be logged in, or time out afer 5s
//        waitForExpectations(timeout: 5, handler: nil)
//        
//        // Update user's firstname and surname
//        let updateUserExpectation = self.expectation(description: "Updating User Data")
//        var updateUserError: Error?
//        let newFirstname = UUID().uuidString
//        let newSurname = UUID().uuidString
//        authService!.updateUserData(firstname: newFirstname, surname: newSurname, completion: { error in
//            updateUserError = error
//            updateUserExpectation.fulfill()
//        })
//        
//        // Wait for user to be updated, or time out afer 5s
//        waitForExpectations(timeout: 5, handler: nil)
//        
//        // Assertions
//        XCTAssert(logInError == nil, "There should be no error when logging in.")
//        XCTAssert(updateUserError == nil, "There should be no error when updating user data.")
//        XCTAssert(newFirstname == firstname, "firstname should have been updated to newFirstname.")
//        XCTAssert(newSurname == surname, "surname should have been updated to newSurname.")
//    }
//    
//}
