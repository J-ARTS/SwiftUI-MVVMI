//
//  StarWarsPerson.swift
//  Starwars
//
//  Created by Jeremy Teichmann on 30.09.21.
//

import Foundation

struct StarWarsPerson : Codable, Identifiable {
    let id = UUID()
    let name : String?
    let height : String?
    let mass : String?
    let hairColor : String?
    let gender: String?
    let films : [String]?
}
