//
//  DataStore.swift
//  MovieApp
//
//  Created by Ameya on 27/04/21.
//

import Foundation

final class DataStore {
    
    static let shared = DataStore()
    private var maxLimit = 5
    private init() { }
    
    func storeMovie(_ vm: MovieViewModel) {
        guard var movies = retrieveStoredMovies() else { return }
        if isMovieAlreadyStored(movies, movieToStore: vm.movie) { return }
        
        handleMaxCacheLimit(&movies)
        movies.insert(vm.movie, at: 0)
        
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
    
    ///Checks if movie is already stored so as to not store it again
    private func isMovieAlreadyStored(_ movies: [Movie], movieToStore: Movie) -> Bool {
        for movie in movies {
            if movie.id == movieToStore.id {
                return true
            }
        }
        return false
    }
    
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
