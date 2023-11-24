//
//  ViewModels.swift
//  MovieApp
//
//  Created by Sifatul Islam on 24/11/23.
//

import Foundation
import Combine

class MovieViewModel: ObservableObject, Identifiable {
    @Published var movieList = [Result]()
    @Published var searchText = "Marvel"
    var cancellables = Set<AnyCancellable>()
    
    func search() {
        HTTPClient.shared.loadSearch(for: searchText)
            .receive(on: DispatchQueue.main)
            .sink { result in
                self.movieList = result
            }
            .store(in: &cancellables)
    }
    
}
