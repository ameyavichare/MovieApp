//
//  SearchViewModel.swift
//  MovieApp
//
//  Created by Ameya on 27/04/21.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    
    @Published private(set) var dataSource: [MovieViewModel] = []
    let sectionTitle = "Recently Searched"
}

//MARK:- Prepare datasource
extension SearchViewModel {
    
    func prepareDatasource() {
        
        guard let storedMovies = DataStore.shared.retrieveStoredMovies() else { return }
        self.dataSource = storedMovies.map { MovieViewModel($0) }
    }
    
    func vmAtIndex(_ index: Int) -> MovieViewModel {
        dataSource[index]
    }
    
    var numberOfSections: Int {
        1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        self.dataSource.count
    }
}
