//
//  ContentView.swift
//  MovieApp
//
//  Created by Sifatul Islam on 24/11/23.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject var viewModel = MovieViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.movieList) { result in
                SingleView(model: SingleView.Model(id: result.id, title: result.title, overview: result.overview, imagePath: result.posterPath))
                
            }
            .listStyle(.plain)
            .navigationTitle("Movie List")
        }
        .searchable(text: $viewModel.searchText)
        .onSubmit(of: .search) {
            viewModel.search()
        }
        .onAppear {
            viewModel.search()
        }
    }
}

#Preview(body: {
    ContentView()
})
