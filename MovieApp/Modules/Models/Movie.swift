//
//  Movie.swift
//  MovieApp
//
//  Created by Ameya on 26/04/21.
//

import Foundation

struct MovieListResponse: Decodable {
    
    let results: [Movie]
}

struct Movie: Decodable {
    
    let id: Int
    let original_title: String
    let overview: String
    let poster_path: String
    let release_date: String
}
