//
//  StarWarsDomain.swift
//  Starwars
//
//  Created by Jeremy Teichmann on 30.09.21.
//

import Foundation
import Combine
import Resolver

protocol StarWarsUseCase {
    func getStarWarsPeople() -> AnyPublisher<Resource<StarWarsApiResponse>, Error>
}

final class DefaultStarWarsUseCase : StarWarsUseCase {
    
    @LazyInjected var repository : StarWarsRepository
    
    func getStarWarsPeople() -> AnyPublisher<Resource<StarWarsApiResponse>, Error> {
        return self.repository.getStarWarsPeople()
    }
}
