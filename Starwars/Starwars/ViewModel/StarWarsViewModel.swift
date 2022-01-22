//
//  StarWarsViewModel.swift
//  Starwars
//
//  Created by Jeremy Teichmann on 30.09.21.
//
// TODO
// - Add Storing data and extend repository with new StorageAPI
// -

import Foundation
import Combine
import Resolver

final class StarWarsViewModel : ObservableObject {

    @Published var count : Int = 0
    @Published var items = [StarWarsPerson]()

    @LazyInjected var useCase : StarWarsUseCase
    
    private var disposables: Set<AnyCancellable> = []

    func loadPeople() {
        useCase.getStarWarsPeople()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                        case .failure(let error): print("Error \(error)")
                        case .finished: print("Publisher is finished")
                    }
                },
                receiveValue: { [weak self] in
                    self?.count =  $0.data?.count ?? 0
                    self?.items =  $0.data?.results ?? [StarWarsPerson]()
                }
            ).store(in: &disposables)
    }
}

