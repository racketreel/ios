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
        
        container.register(AuthenticationProvider.self) { _ in
            return PreviewAuthenticationProvider()
        }
        .inObjectScope(.container)
        
        container.register(AnyDataProvider<UserInfo>.self) { _ in
            return AnyDataProvider(
                wrappedConnector: NoPersistDataProvider<UserInfo>()
            )
        }
        .inObjectScope(.container)
        
        container.register(AnyDataProvider<TennisMatch>.self) { _ in
            return AnyDataProvider(
                wrappedConnector: NoPersistDataProvider<TennisMatch>()
            )
        }
        .inObjectScope(.container)
        
        return container
    }
    
}
