//
//  MainContainer.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 23/10/2021.
//
//  Swinject dependency injection container used by the main application.
//

import Foundation
import Swinject

class MainContainer: ContainerDefinition {
    
    static func build() -> Container {
        let container = Container()
        
        container.register(AuthenticationProvider.self) { _ in
            return FirebaseAuthenticationProvider()
        }
        .inObjectScope(.container)
        
        container.register(AnyDataProvider<UserInfo>.self) { _ in
            return AnyDataProvider(
                wrappedConnector: FirestoreDataProvider<UserInfo>(path: "userInfo")
            )
        }
        .inObjectScope(.container)
        
        container.register(AnyDataProvider<TennisMatch>.self) { _ in
            return AnyDataProvider(
                wrappedConnector: FirestoreDataProvider<TennisMatch>(path: "matches")
            )
        }
        .inObjectScope(.container)
        
        return container
    }
    
}
