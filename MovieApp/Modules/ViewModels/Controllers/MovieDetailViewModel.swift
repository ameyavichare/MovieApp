//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Ameya on 27/04/21.
//

import Foundation
import Combine

//MARK:- Movie Detail Cell types
enum MovieDetailCellType {
    case synopsisCell(_ vm: MovieSynopsisViewModel)
    case reviewCell(_ vm: MovieReviewListViewModel)
    case castCell(_ vm: MovieCastListViewModel)
    case similarCell(_ vm: MovieSimilarListViewModel)
}

class MovieDetailViewModel: ObservableObject {
    
    private(set) var movieId: Int ///ID of the movie for which the detail is being shown
    private var response: MovieDetailResponse = MovieDetailResponse() ///Stores the response from the api
    @Published private(set) var dataSource: [MovieDetailCellType] = [] /// DataSource for the table
    private var cancellables: Set<AnyCancellable> = [] ///Used for storing the bindings
    private let service = WebService() ///Service for making api calls
    private let group = DispatchGroup() ///Dispatch Group for getting notified when all the api calls have finished
    
    init(_ movieId: Int) {
        self.movieId = movieId
    }
}

//MARK:- Initial API Calls
extension MovieDetailViewModel {
    
    ///viewDidLoad has been called on the VC, make relevant api calls, get notified when all have finished
    func viewDidLoad() {
        self.fetchMovieSynopis()
        self.fetchReviews()
        self.fetchCast()
        self.fetchSimilarMovies()
        
        group.notify(queue: .main) {
            self.prepareDatasource()
        }
    }
    
    ///Make an api call using a resource which expects a Synopsis in return
    private func fetchMovieSynopis() {
        
        let urlString = WebServiceConstants.baseURL + "\(movieId)?" + "api_key=\(apiKey)" + "&language=en-US"
        guard let url = URL(string: urlString) else { return }
        let resource = Resource<Synopsis>(url: url)
        group.enter()

        service.load(resource)
            .sink { _ in } receiveValue: { [weak self] (response) in
                guard let weakSelf = self else { return }
                weakSelf.response.synopsis = response
                weakSelf.group.leave()
            }
            .store(in: &cancellables)
    }
    
    ///Make an api call using a resource which expects a MovieReviewResponse in return
    private func fetchReviews() {
        
        let urlString = WebServiceConstants.baseURL + "\(movieId)" + WebServiceConstants.movieReviewsAPI + "api_key=\(apiKey)" + "&language=en-US" + "&page=1"
        guard let url = URL(string: urlString) else { return }
        let resource = Resource<MovieReviewResponse>(url: url)
        group.enter()

        service.load(resource)
            .sink { _ in } receiveValue: { [weak self] (response) in
                guard let weakSelf = self else { return }
                weakSelf.response.reviews = response.results
                weakSelf.group.leave()
            }
            .store(in: &cancellables)
    }
    
    ///Make an api call using a resource which expects a MovieCastResponse in return
    private func fetchCast() {
        
        let urlString = WebServiceConstants.baseURL + "\(movieId)" + WebServiceConstants.movieCastAPI + "api_key=\(apiKey)" + "&language=en-US"
        guard let url = URL(string: urlString) else { return }
        let resource = Resource<MovieCastResponse>(url: url)
        group.enter()

        service.load(resource)
            .sink { _ in } receiveValue: { [weak self] (response) in
                guard let weakSelf = self else { return }
                weakSelf.response.cast = response.cast
                weakSelf.group.leave()
            }
            .store(in: &cancellables)
    }
    
    ///Make an api call using a resource which expects a MovieListResponse in return
    private func fetchSimilarMovies() {
        
        let urlString = WebServiceConstants.baseURL + "\(movieId)" + WebServiceConstants.movieSimilarAPI + "api_key=\(apiKey)" + "&language=en-US" + "&page=1"
        guard let url = URL(string: urlString) else { return }
        let resource = Resource<MovieListResponse>(url: url)
        group.enter()
        
        service.load(resource)
            .sink { _ in } receiveValue: { [weak self] (response) in
                guard let weakSelf = self else { return }
                weakSelf.response.similarMovies = response.results
                weakSelf.group.leave()
            }
            .store(in: &cancellables)
    }
}

//MARK:- Prepare datasource
extension MovieDetailViewModel {
    
    ///Prepares the datasource for the tableview
    private func prepareDatasource() {
        var preparedDataSource: [MovieDetailCellType] = []
        if let cell = cellTypeForSynopsisCell() {
            preparedDataSource.append(cell)
        }
        if let cell = cellTypeForReviewCell() {
            preparedDataSource.append(cell)
        }
        if let cell = cellTypeForCastCell() {
            preparedDataSource.append(cell)
        }
        if let cell = cellTypeForSimilarMovieCell() {
            preparedDataSource.append(cell)
        }
        self.dataSource = preparedDataSource
    }
    
    private func cellTypeForSynopsisCell() -> MovieDetailCellType? {
        if let synopsis = response.synopsis {
            let movieSynopsisVM = MovieSynopsisViewModel(synopsis)
            return MovieDetailCellType.synopsisCell(movieSynopsisVM)
        }
        return nil
    }
    
    private func cellTypeForReviewCell() -> MovieDetailCellType? {
        if self.response.reviews.count > 0 {
            let reviewListVM = MovieReviewListViewModel(self.response.reviews.map { MovieReviewViewModel($0) })
            return MovieDetailCellType.reviewCell(reviewListVM)
        }
        return nil
    }
    
    private func cellTypeForCastCell() -> MovieDetailCellType? {
        if self.response.cast.count > 0 {
            let castListVM = MovieCastListViewModel(self.response.cast.map { MovieCastViewModel($0) })
            return MovieDetailCellType.castCell(castListVM)
        }
        return nil
    }
    
    private func cellTypeForSimilarMovieCell() -> MovieDetailCellType? {
        if self.response.similarMovies.count > 0 {
            let similarListVM = MovieSimilarListViewModel(self.response.similarMovies.map { MovieViewModel($0) })
            return MovieDetailCellType.similarCell(similarListVM)
        }
        return nil
    }
    
    func cellTypeForIndex(_ index: Int) -> MovieDetailCellType {
        dataSource[index]
    }
    
    var numberOfSections: Int {
        1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        self.dataSource.count
    }
}
