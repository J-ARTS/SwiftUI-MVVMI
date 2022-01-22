//
//  Ressource.swift
//  Starwars
//
//  Created by Jeremy Teichmann on 19.10.21.
//

import Foundation
struct Resource<T> {
    
    var status : Status
    var data: T?
    
    public init(status: Status, data: T?) {
        self.status = status
        self.data = data
    }
    
    static func success(data : T?) -> Resource<T> {
        return Resource(status: Status.SUCCESS, data: data)
    }
    
    static func loading(data : T?) -> Resource<T> {
        return Resource(status: Status.LOADING, data: data)
    }
    
    enum Status {
        case SUCCESS
        case LOADING
    }
}

