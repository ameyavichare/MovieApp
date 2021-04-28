//
//  DataStore.swift
//  MovieApp
//
//  Created by Ameya on 27/04/21.
//

import Foundation

final class DataStore {
    
    static let shared = DataStore()
    ///Max number of entries in the store at any given time
    private var maxLimit = 5
    
    private init() { }
    
    ///Takes in a movie and stores it only if it is already not present. Also handles the max store limit.
    func storeMovieRequest(_ movie: Movie) {
        
        ///Retrieve all the movies that are already stored
        guard var movies = retrieveStoredMovies() else { return }
        ///If a movie is already stored, dont do anything, else proceed
        if isMovieAlreadyStored(movies, movieToStore: movie) { return }
        
        ///Pop the least recent movie entry in our store and insert our current movie
        handleMaxCacheLimit(&movies)
        movies.insert(movie, at: 0)
        
        ///Store movies to the store
        storeMovies(movies)
    }
    
    ///Stores all the movies
    private func storeMovies(_ movies: [Movie]) {
        
        let archiver = NSKeyedArchiver(requiringSecureCoding: true)
        do {
            try archiver.encodeEncodable(movies, forKey: NSKeyedArchiveRootObjectKey)
            try archiver.encodedData.write(to: Movie.ArchiveURL)
        }
        catch {
            fatalError(error.localizedDescription)
        }
        archiver.finishEncoding()
    }
    
    ///Removes the last entry if cache has exceeded max limit
    private func handleMaxCacheLimit(_ movies: inout [Movie]) {
        if movies.count >= maxLimit {
            movies.remove(at: movies.count - 1)
        }
    }
    
    ///Checks if movie is already stored, based on the movie id, so as to not store it again
    private func isMovieAlreadyStored(_ movies: [Movie], movieToStore: Movie) -> Bool {
        for movie in movies {
            if movie.id == movieToStore.id {
                return true
            }
        }
        return false
    }
    
    ///Fetches all the stored movies, the user has searched
    func retrieveStoredMovies() -> [Movie]? {
        
        guard let nsData = NSData(contentsOf: Movie.ArchiveURL) else { return [] }
        let data = Data(referencing:nsData)
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
        unarchiver.decodingFailurePolicy = .setErrorAndReturn
        let decoded = unarchiver.decodeDecodable([Movie].self, forKey: NSKeyedArchiveRootObjectKey)!
        unarchiver.finishDecoding()
        return decoded
    }
}
