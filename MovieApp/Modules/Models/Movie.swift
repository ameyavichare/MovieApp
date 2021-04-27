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
    let poster_path: String?
    let release_date: String
}

//MARK:- Hold various types of movie detail data
struct MovieDetailResponse {
    var synopsis: Synopsis? = nil
    var reviews: [Review] = []
    var cast: [Cast] = []
    var similarMovies: [Movie] = []
}

struct Synopsis: Decodable {
    
    let id: Int
    let original_title: String
    let overview: String
    let poster_path: String
    let release_date: String
    let genres: [Genre]
    let runtime: Int
    let vote_average: Double
    let vote_count: Int
}

struct Genre: Decodable {
    
    let id: Int
    let name: String
}

struct MovieReviewResponse: Decodable {
    
    let results: [Review]
}

struct Review: Decodable {
    
    let id: String
    let content: String
    let author: String
}

struct MovieCastResponse: Decodable {
    
    let cast: [Cast]
}

struct Cast: Decodable {
    
    let id: Int
    let name: String
    let character: String
    let profile_path: String?
}

