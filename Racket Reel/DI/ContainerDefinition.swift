//
//  ContainerDefinition.swift
//  Racket Reel
//
//  Created by Tom Elvidge on 23/10/2021.
//

import Foundation
import Swinject

protocol ContainerDefinition {
    
    static func build() -> Container
    
}
