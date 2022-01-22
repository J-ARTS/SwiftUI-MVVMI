//
//  StarWarsRepository.swift
//  Starwars
//
//  Created by Jeremy Teichmann on 30.09.21.
//

import Foundation
import Combine
import Resolver

protocol StarWarsRepository {
    func getStarWarsPeople() -> AnyPublisher<Resource<StarWarsApiResponse>, Error>
}

final class DefaultStarWarsRepository : StarWarsRepository {
    
    @LazyInjected var network : StarWarsService
    
    func getStarWarsPeople() -> AnyPublisher<Resource<StarWarsApiResponse>, Error> {
        
        let loadFromDb: () -> AnyPublisher<StarWarsApiResponse, Error> = {
            return self.network.getStarWarsPeople()
        }
        
        let createCall: () -> AnyPublisher<StarWarsApiResponse, Error> = {
            return self.network.getStarWarsPeople()
        }
        
        let processResponse: (StarWarsApiResponse) -> AnyPublisher<StarWarsApiResponse, Error> = { data in 
            return Future<StarWarsApiResponse, Error> { promise in
                promise(.success(data))
            }.eraseToAnyPublisher()
        }
        
        
        return NetworkBoundResource<StarWarsApiResponse, StarWarsApiResponse>().build( shouldFetch: true, loadFromDb: loadFromDb, createCall: createCall, processResponse: processResponse, shouldReloadFromDB: true)
        
    }
}
