//
//  MovieSynopsisViewModel.swift
//  MovieApp
//
//  Created by Ameya on 27/04/21.
//

import Foundation
import Combine

struct MovieSynopsisViewModel {
    
    private let movieSynopsis: Synopsis
}

extension MovieSynopsisViewModel {
    
    init(_ movieSynopsis: Synopsis) {
        self.movieSynopsis = movieSynopsis
    }
}

extension MovieSynopsisViewModel {
    
    var id: Int {
        self.movieSynopsis.id
    }
    
    var name: String {
        self.movieSynopsis.original_title
    }
    
    var genres: String {
        self.movieSynopsis.genres.map { $0.name }.joined(separator: ", ")
    }
    
    var voteAverage: String {
        String(format: "%.1f", self.movieSynopsis.vote_average) + "/10"
    }
    
    var voteCount: String {
        "\(self.movieSynopsis.vote_count) votes"
    }
    
    var releaseDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self.movieSynopsis.release_date) ?? Date()
        dateFormatter.dateFormat = "dd MMMM, yyyy"
        return dateFormatter.string(from: date)
    }
    
    var movieDescription: String {
        self.movieSynopsis.overview
    }
    
    var posterImageURL: URL? {
        URL(string: "https://image.tmdb.org/t/p/w500" + self.movieSynopsis.poster_path) ?? nil
    }
}
