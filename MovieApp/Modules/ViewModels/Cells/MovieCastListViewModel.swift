//
//  MovieCastListViewModel.swift
//  MovieApp
//
//  Created by Ameya on 27/04/21.
//

import Foundation

//Parent
struct MovieCastListViewModel {
    
    private(set) var sectionTitle = "Cast"
    private var viewModels: [MovieCastViewModel]
}

extension MovieCastListViewModel {
    
    init(_ viewModels: [MovieCastViewModel]) {
        self.viewModels = viewModels
    }
}

extension MovieCastListViewModel {
    
    var numberOfSections: Int {
        1
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        viewModels.count
    }
    
    func vmAtIndex(_ index: Int) -> MovieCastViewModel {
        viewModels[index]
    }
}

//Child
struct MovieCastViewModel {
    
    private let cast: Cast
}

extension MovieCastViewModel {
    
    init(_ cast: Cast) {
        self.cast = cast
    }
}

extension MovieCastViewModel {
    
    var name: String {
        return self.cast.name
    }
    
    var character: String {
        return self.cast.character
    }
    
    var profileImageURL: URL? {
        
        guard let profilePath = self.cast.profile_path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500" + profilePath) ?? nil
    }
}
