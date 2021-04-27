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
    
    private(set) var movieId: Int
    private var response: MovieDetailResponse = MovieDetailResponse()
    @Published private(set) var dataSource: [MovieDetailCellType] = []
    private var cancellables: Set<AnyCancellable> = []
    private let service = WebService()
    private let group = DispatchGroup()
    
    init(_ movieId: Int) {
        self.movieId = movieId
    }
}

extension MovieDetailViewModel {
    
    func viewDidLoad() {
        self.fetchMovieSynopis()
        self.fetchReviews()
        self.fetchCast()
        self.fetchSimilarMovies()
        
        group.notify(queue: .main) {
            self.prepareDatasource()
        }
    }
    
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
    
    private func prepareDatasource() {
        var preparedDataSource: [MovieDetailCellType] = []
        if let cell = cellTypeForSynopsisCell() {
            preparedDataSource.append(cell)
        }
        preparedDataSource.append(cellTypeForReviewCell())
        preparedDataSource.append(cellTypeForCastCell())
        preparedDataSource.append(cellTypeForSimilarMovieCell())
        self.dataSource = preparedDataSource
    }
    
    private func cellTypeForSynopsisCell() -> MovieDetailCellType? {
        if let synopsis = response.synopsis {
            let movieSynopsisVM = MovieSynopsisViewModel(synopsis)
            return MovieDetailCellType.synopsisCell(movieSynopsisVM)
        }
        return nil
    }
    
    private func cellTypeForReviewCell() -> MovieDetailCellType {
        let reviewListVM = MovieReviewListViewModel(self.response.reviews.map { MovieReviewViewModel($0) })
        return MovieDetailCellType.reviewCell(reviewListVM)
    }
    
    private func cellTypeForCastCell() -> MovieDetailCellType {
        let castListVM = MovieCastListViewModel(self.response.cast.map { MovieCastViewModel($0) })
        return MovieDetailCellType.castCell(castListVM)
    }
    
    private func cellTypeForSimilarMovieCell() -> MovieDetailCellType {
        let similarListVM = MovieSimilarListViewModel(self.response.similarMovies.map { MovieViewModel($0) })
        return MovieDetailCellType.similarCell(similarListVM)
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
