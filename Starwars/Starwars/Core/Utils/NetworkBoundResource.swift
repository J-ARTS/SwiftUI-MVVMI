//
//  NetworkBoundResource.swift
//  Starwars
//
//  Created by Jeremy Teichmann on 19.10.21.
//

import Foundation
import Combine

public final class NetworkBoundResource<ResultType, RequestType> {
    
    var resultOld : Resource<ResultType>? = nil
    private var disposables: Set<AnyCancellable> = []
    
 
    func build(       
                      shouldFetch: Bool,
                      loadFromDb:@escaping () -> AnyPublisher<ResultType, Error>,
                      createCall:@escaping () -> AnyPublisher<RequestType, Error>,
                      processResponse:@escaping (_ response: RequestType) -> AnyPublisher<ResultType, Error>,/*
                      saveCallResults: @escaping (_ items: ResultType) -> Future<Void, Error>,*/
                      shouldReloadFromDB: Bool = false) -> AnyPublisher<Resource<ResultType>, Error> {
      
        let subject = PassthroughSubject<Resource<ResultType>, Error>()
        return subject.handleEvents(receiveSubscription: { subscription in

            loadFromDb().flatMap { dbResult -> AnyPublisher<(RequestType?, ResultType?), Error> in
                
                Future<(RequestType?, ResultType?), Error>.init { (promise) in
                    self.notifyPromise(Resource.loading(data: dbResult), subject).map {
                        promise(.success((nil, dbResult)))
                    }
                }.eraseToAnyPublisher()
 
            }.flatMap { (networkResult, dbResult) -> AnyPublisher<(ResultType?, ResultType?), Error> in
    
                Future<(ResultType?, ResultType?), Error>.init { (promise) in
                    guard shouldFetch else {
                        return promise(.success((nil, dbResult)))
                    }
                    createCall().flatMap { response in
                        processResponse(response)
                    }.map { result in
                        promise(.success((result, dbResult)))
                    }
                }.eraseToAnyPublisher()
                
            }.flatMap { (networkResult, dbResult) -> AnyPublisher<(ResultType?, ResultType?), Error> in
                Future<(ResultType?, ResultType?), Error>.init { (promise) in
                    self.notifyPromise(Resource.success(data: networkResult), subject).map { promise(.success((networkResult, dbResult)))
                    }
                    
                }.eraseToAnyPublisher()
            }.sink(
                receiveCompletion: { completion in
                    switch completion {
                        case .failure(let error): print("Error \(error)")
                        case .finished: print("Publisher is finished")
                    }
                },
                receiveValue: { value in
                    print(value)
                }
            ).store(in: &self.disposables)
    
        }).eraseToAnyPublisher()
        

            /*
            DispatchQueue.global().async {
                
                loadFromDb().then { dbResult in
                    self.notifyPromise(.loading(data: dbResult, index: self.itemIndex), observer).map { dbResult }
                }.then { dbResult -> Promise<(Error?, ResultType?, ResultType)> in
                    
                    guard shouldFetch else {
                        return Promise<(Error?, ResultType?, ResultType)> { p in p.fulfill((nil, nil, dbResult)) }
                    }
                    
                    return createCall().then { request in
                        processResponse(request)
                    }.then { networkResult in
                        saveCallResults(networkResult).map { (nil, networkResult, dbResult) }
                    }.recover { error in
                        return Promise<(Error?, ResultType?, ResultType)> { p in p.fulfill((error, nil, dbResult)) }
                    }
                }.then { (error, result, dbResult) -> Promise<(Error?, ResultType?)> in
                    
                    if let error = error {
                        return Promise<(Error?, ResultType?)> { p in p.fulfill((error, dbResult)) }
                    }
                        
                    guard shouldReloadFromDB else {
                        return Promise<(Error?, ResultType?)> { p in p.fulfill((error, result)) }
                    }
                    
                    return loadFromDb().then { loadDbResult in
                        Promise<(Error?, ResultType?)> { p in p.fulfill((nil, loadDbResult)) }
                    }.recover { error in
                        return Promise<(Error?, ResultType?)> { p in p.fulfill((error, dbResult)) }
                    }
                }.done { (error, result) in
                    if let error = error {
                        self.setValue(.error(error: error, data: result, index: self.itemIndex), observer)
                    } else {
                        self.setValue(.success(data: result, index: self.itemIndex), observer)
                    }
                    observer.onCompleted()
                }.catch(policy: .allErrors) { error in
                    self.setValue(.error(error: error, data: nil), observer)
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()*/
        
    }

    private func notifyPromise(_ newValue: Resource<ResultType>,_ observer: PassthroughSubject
<Resource<ResultType>, Error>) -> Future<Void,Error> {
        
        return Future<Void, Error>  { promise in
            print("hello2 \(newValue)")
            self.setValue(newValue, observer)
            promise(.success(()))
        }
    }
    
    private func setValue(_ newValue: Resource<ResultType>,_ observer: PassthroughSubject
<Resource<ResultType>, Error>) {
        if (resultOld?.status != newValue.status) {
            resultOld = newValue
            observer.send(newValue)
        }
    }
}
