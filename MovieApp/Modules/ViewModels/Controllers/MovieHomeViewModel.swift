//
//  MovieListingViewModel.swift
//  MovieApp
//
//  Created by Ameya on 26/04/21.
//

import Foundation
import Combine

class MovieHomeViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = [] ///Used for storing the bindings
    private var response: MovieListResponse! ///Stores the response from the api
    @Published private(set) var dataSource: [MovieViewModel] = [] /// DataSource for the table when user is not searching
    @Published private(set) var filteredDataSource: [MovieViewModel] = [] /// DataSource for the table when user is searching
    private(set) var isSearching = Bool() ///State track whether user is searching or not
    
    ///Passthrough subject to pass data when the book button in movie list is pressed
    var movieChoosed: AnyPublisher<MovieViewModel, Never> {
        movieChoosedSubject.eraseToAnyPublisher()
    }
    
    private let movieChoosedSubject = PassthroughSubject<MovieViewModel, Never>()
}

//MARK:- Initial API Calls
extension MovieHomeViewModel {
    
    ///viewDidLoad has been called on the VC, make an api call to fetch movies to display
    func viewDidLoad() {
        self.fetchMovies()
    }
    
    ///Make an api call using a resource which expects a MovieListResponse in return
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
    
    ///Prepares the datasource for the tableview
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
        self.filteredDataSource = self.searchMovies(self.dataSource, with: searchText)
    }
    
    ///Takes in an array of movies, and search text and returns the ones that match using a regex containing word boundary and positive lookahead
    private func searchMovies(_ movies: [MovieViewModel], with searchText: String) -> [MovieViewModel] {
        let words: [String] = searchText.components(separatedBy: " ")
        ///Beginning
        var regex: String = "^"
        ///For each word, append to regex
        words.forEach { w in
            regex += "(?=.*\\b\(w))"
        }
        ///End
        regex += ".*$"
        
        return movies.filter { (movie) -> Bool in
            if let _ = movie.name.range(of: regex, options: [.regularExpression, .caseInsensitive]) {
                return true
            }
            return false
        }
    }
}

//MARK:- Data Store handling
extension MovieHomeViewModel {
    ///Store a movie after the user has tapped on a movie, but only if isSearching is true
    func storeMovie(_ vm: MovieViewModel) {
        if !self.isSearching { return }
        DataStore.shared.storeMovieRequest(vm.movie)
    }
}

