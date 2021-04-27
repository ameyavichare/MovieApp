//
//  MovieSimilarListViewModel.swift
//  MovieApp
//
//  Created by Ameya on 27/04/21.
//

import Foundation

//Parent
struct MovieSimilarListViewModel {
    
    private(set) var sectionTitle = "Similar"
    private var viewModels: [MovieViewModel]
}

extension MovieSimilarListViewModel {
    
    init(_ viewModels: [MovieViewModel]) {
        self.viewModels = viewModels
    }
}

extension MovieSimilarListViewModel {
    
    var numberOfSections: Int {
        1
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        viewModels.count
    }
    
    func vmAtIndex(_ index: Int) -> MovieViewModel {
        viewModels[index]
    }
}

