//
//  STError.swift
//  Starwars
//
//  Created by Jeremy Teichmann on 01.10.21.
//

import Foundation
import Alamofire

enum STError: Error {
    case notFound
    case noInternetConnection
    case defaultError
    
}

extension Error {
    func toSTError(code: Int?) -> Error {
        
        guard let statusCode = code else {
            return self
        }
        switch statusCode {
            case 404:
                return STError.notFound
            default:
                return STError.defaultError
        }
    }
}



