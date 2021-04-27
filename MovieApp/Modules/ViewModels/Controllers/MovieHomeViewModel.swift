//
//  MovieListingViewModel.swift
//  MovieApp
//
//  Created by Ameya on 26/04/21.
//

import Foundation
import Combine

class MovieHomeViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    private var response: MovieListResponse!
    @Published private(set) var dataSource: [MovieViewModel] = []
    @Published private(set) var filteredDataSource: [MovieViewModel] = []
    private(set) var isSearching = Bool()
    
    var movieChoosed: AnyPublisher<MovieViewModel, Never> {
        movieChoosedSubject.eraseToAnyPublisher()
    }
    
    private let movieChoosedSubject = PassthroughSubject<MovieViewModel, Never>()
}

//MARK:- Initial API Calls
extension MovieHomeViewModel {
    
    func viewDidLoad() {
        self.fetchMovies()
    }
    
    private func fetchMovies() {
        
        let urlString = WebServiceConstants.baseURL + WebServiceConstants.movieListAPI + "api_key=\(apiKey)" + "&language=en-US" + "&page=1"
        guard let url = URL(string: urlString) else { return }
        let resource = Resource<MovieListResponse>(url: url)
        
        let service = WebService()
        service.load(resource)
            .sink { _ in } receiveValue: { [weak self] (response) in
                guard let weakSelf = self else { return }
                weakSelf.response = response
                weakSelf.prepareDatasource()
            }
            .store(in: &cancellables)
    }
}

//MARK:- Prepare datasource
extension MovieHomeViewModel {
    
    private func prepareDatasource() {
        self.dataSource = self.response.results.map {
            let vm = MovieViewModel($0)
            vm.movieSelected.sink { _ in } receiveValue: { [weak self] (vm) in
                guard let weakSelf = self else { return }
                weakSelf.movieChoosedSubject.send(vm)
                weakSelf.storeMovie(vm)
            }
            .store(in: &cancellables)
            return vm
        }
    }
    
    func vmAtIndex(_ index: Int) -> MovieViewModel {
        isSearching ? filteredDataSource[index] : dataSource[index]
    }
    
    var numberOfSections: Int {
        1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        isSearching ? self.filteredDataSource.count : self.dataSource.count
    }
}

//MARK:- Search handling
extension MovieHomeViewModel {
    
    func setIsSearching(as isSearching: Bool) {
        self.isSearching = isSearching
    }
    
    func searchMovies(with searchText: String) {
        self.filteredDataSource = self.dataSource.filter{ (item: MovieViewModel) -> Bool in
            return item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
    }
}

extension MovieHomeViewModel {
    
    func storeMovie(_ vm: MovieViewModel) {
        if !self.isSearching { return }
        DataStore.shared.storeMovie(vm)
    }
}

