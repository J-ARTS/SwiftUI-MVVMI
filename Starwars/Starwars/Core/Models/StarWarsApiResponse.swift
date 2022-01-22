//
//  StarWarsApiResponse.swift
//  Starwars
//
//  Created by Jeremy Teichmann on 30.09.21.
//

import Foundation

struct StarWarsApiResponse : Codable {
    let count : Int
    let next : String?
    let previous : String?
    let results : [StarWarsPerson]
}
