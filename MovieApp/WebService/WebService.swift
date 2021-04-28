//
//  WebService.swift
//  MovieApp
//
//  Created by Ameya on 26/04/21.
//

import Foundation
import Combine

///A generic resource
struct Resource<T: Decodable> {
    let url: URL
}

///Api endpoints & base url
struct WebServiceConstants {
    static let baseURL = "https://api.themoviedb.org/3/movie/"
    static let movieListAPI = "now_playing?"
    static let movieReviewsAPI = "/reviews?"
    static let movieCastAPI = "/credits?"
    static let movieSimilarAPI = "/similar?"
}

///Service for making api calls
class WebService {
    
    func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, Error> {
        let urlRequest = URLRequest(url: resource.url)
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
