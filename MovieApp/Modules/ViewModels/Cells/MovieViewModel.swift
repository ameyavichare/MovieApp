//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by Ameya on 26/04/21.
//

import Foundation
import Combine

struct MovieViewModel {
    
    private(set) var movie: Movie
    
    var movieSelected: AnyPublisher<MovieViewModel, Never> {
        return self.movieSelectedSubject.eraseToAnyPublisher()
    }
    
    private let movieSelectedSubject = PassthroughSubject<MovieViewModel, Never>()
}

extension MovieViewModel {
    
    init(_ movie: Movie) {
        self.movie = movie
    }
}

extension MovieViewModel {
    
    var id: Int {
        return self.movie.id
    }
    
    var name: String {
        return self.movie.original_title
    }
    
    var releaseDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self.movie.release_date) ?? Date()
        dateFormatter.dateFormat = "dd MMMM, yyyy"
        return dateFormatter.string(from: date)
    }
    
    var movieDescription: String {
        return self.movie.overview
    }
    
    var posterImageURL: URL? {
        guard let posterPath = self.movie.poster_path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500" + posterPath) ?? nil
    }
}

extension MovieViewModel {
    
    func bookPressed() {
        self.movieSelectedSubject.send(self)
    }
}
