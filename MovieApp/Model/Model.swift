//
//  Model.swift
//  MovieApp
//
//  Created by Sifatul Islam on 24/11/23.
//

import UIKit
import Combine

struct Movie: Codable {
    let page: Int
    let results: [Result]
    let totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Result: Codable, Identifiable {
    let id: Int
    let overview: String
    let posterPath: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case overview
        case posterPath = "poster_path"
        case title
    }
}





