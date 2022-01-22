//
//  DIContainer.swift
//  Starwars
//
//  Created by Jeremy Teichmann on 01.10.21.
//

import Foundation
import Resolver

final class DIContainer {
    
    init() {
        setupStarWarsDIContainer()
    }
    func setupStarWarsDIContainer() {
        Resolver.register { DefaultStarWarsService() as StarWarsService }
        Resolver.register { DefaultStarWarsRepository() as StarWarsRepository }
        Resolver.register { DefaultStarWarsUseCase() as StarWarsUseCase }
        Resolver.register { StarWarsViewModel() }.scope(.shared)
    }
}
