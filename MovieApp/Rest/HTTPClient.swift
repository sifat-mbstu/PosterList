//
//  HTTPClient.swift
//  MovieApp
//
//  Created by Sifatul Islam on 24/11/23.
//

import UIKit
import Combine

enum HTTPError: Error {
    case invalidResponse
    case invalidURL
    
}
class HTTPClient {
    static let shared = HTTPClient()
    let apiKey = "b2fcfafe5ab8ae14abd03ac7e58cf028"
    let baseImageURLString = "https://image.tmdb.org/t/p/original/"
    let searchBaseURLString = "https://api.themoviedb.org/3/search/movie"
    private init() { }
    func loadSearch(for searchText: String) -> AnyPublisher<[Result], Never> {
        guard var url = URL(string: searchBaseURLString) else {
            print("Base URL for search not found")
            return Just([]).eraseToAnyPublisher()
        }
        url.append(queryItems: [URLQueryItem(name: "api_key", value: apiKey),
                                URLQueryItem(name: "query", value: searchText)])
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: Movie.self, decoder: JSONDecoder())
            .map(\.results)
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
    func loadImage(imagePath: String) -> AnyPublisher<UIImage?, Never> {
        guard var url = URL(string: baseImageURLString) else {
            print("Base URL for search not found")
            return Just(nil).eraseToAnyPublisher()
        }
        url.append(component: imagePath)
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .compactMap({ imageData in
                return UIImage(data: imageData)
            })
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
}
