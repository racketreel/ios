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
        
        container.register(AuthProtocol.self) { _ in
            return FirebaseFirestoreAuth()
        }
        .inObjectScope(.container)
        
        return container
    }
    
}
