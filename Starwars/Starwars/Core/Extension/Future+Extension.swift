//
//  Future+Extension.swift
//  Starwars
//
//  Created by Jeremy Teichmann on 19.10.21.
//

import Foundation
import Combine

extension Publisher {
    
    func then<T: Publisher>(_ closure: @escaping (Output) -> T) -> Publishers.FlatMap<T, Self>
    where T.Failure == Self.Failure {
        flatMap(closure)
    }
    
    func asVoid() -> Future<Void, Error> {
        return Future<Void, Error> { promise in
            let box = Box()
            let cancellable = self.sink { completion in
                if case .failure(let error) = completion {
                    promise(.failure(error))
                } else if case .finished = completion {
                    box.cancellable = nil
                }
            } receiveValue: { value in
                promise(.success(()))
            }
            box.cancellable = cancellable
        }
    }
    
    @discardableResult
    func done(_ handler: @escaping (Output) -> Void) -> Self {
        let box = Box()
        let cancellable = self.sink(receiveCompletion: {compl in
            if case .finished = compl {
                box.cancellable = nil
            }
        }, receiveValue: {
            handler($0)
        })
        box.cancellable = cancellable
        return self
    }
    
    @discardableResult
    func `catch`(_ handler: @escaping (Failure) -> Void) -> Self {
        let box = Box()
        let cancellable = self.sink(receiveCompletion: { compl in
            if case .failure(let failure) = compl {
                handler(failure)
            } else if case .finished = compl {
                box.cancellable = nil
            }
        }, receiveValue: { _ in })
        box.cancellable = cancellable
        return self
    }
    
    @discardableResult
    func finally(_ handler: @escaping () -> Void) -> Self {
        let box = Box()
        let cancellable = self.sink(receiveCompletion: { compl in
            if case .finished = compl {
                handler()
                box.cancellable = nil
            }
        }, receiveValue: { _ in })
        box.cancellable = cancellable
        return self
    }
}

fileprivate class Box {
    var cancellable: AnyCancellable?
}
