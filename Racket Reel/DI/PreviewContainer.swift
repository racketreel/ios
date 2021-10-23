//
//  PreviewContainer.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 23/10/2021.
//
//  Swinject dependency injection container used for XCode previews.
//

import Foundation
import Swinject

class PreviewContainer: ContainerDefinition {
    
    static func build() -> Container {
        let container = Container()
        
        container.register(AuthProtocol.self) { _ in
            return PreviewAuth()
        }
        .inObjectScope(.container)
        
        return container
    }
    
}
