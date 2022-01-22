//
//  StarWarsService.swift
//  Starwars
//
//  Created by Jeremy Teichmann on 30.09.21.


import Foundation
import Alamofire
import Combine

protocol StarWarsService  {
    func getStarWarsPeople() -> AnyPublisher<StarWarsApiResponse, Error>
}

final class DefaultStarWarsService : StarWarsService {
    
    private let url = "https://swapi.dev/api"
    
    func getStarWarsPeople() -> AnyPublisher<StarWarsApiResponse, Error> {
        
        return Deferred {
            Future<StarWarsApiResponse, Error>  { promise in
                AF.request("\(self.url)/people", method: .get).validate(statusCode: 200..<300).responseDecodable(of: StarWarsApiResponse.self) { (response) in
                    
                    let status = response.response?.statusCode
                
                    switch response.result {
                        case .failure(let error):
                            print(error)
                            promise(.failure(error.toSTError(code: status)))
                            break
                        case .success(let data):
                            promise(.success(data))
                            break
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}
