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
}

class MovieDetailViewModel {
    
    private(set) var movieId: Int
    private var response: MovieDetailResponse!
    @Published private(set) var dataSource: [MovieDetailCellType] = []
    private var cancellables: Set<AnyCancellable> = []
    private let service = WebService()
    
    init(_ movieId: Int) {
        self.movieId = movieId
    }
}

extension MovieDetailViewModel {
    
    func viewDidLoad() {
        self.fetchMovieSynopis()
    }
    
    private func fetchMovieSynopis() {
        
        let urlString = WebServiceConstants.baseURL + "\(movieId)?" + "api_key=\(apiKey)" + "&language=en-US"
        guard let url = URL(string: urlString) else { return }
        let resource = Resource<Synopsis>(url: url)

        service.load(resource)
            .sink { _ in } receiveValue: { [weak self] (response) in
                guard let weakSelf = self else { return }
                weakSelf.response = MovieDetailResponse(synopsis: response)
                weakSelf.fetchReviews()
//                weakSelf.prepareDatasource()
            }
            .store(in: &cancellables)
    }
    
    private func fetchReviews() {
        
        let urlString = WebServiceConstants.baseURL + "\(movieId)" + WebServiceConstants.movieReviewsAPI + "api_key=\(apiKey)" + "&language=en-US" + "&page=1"
        print(urlString)
        guard let url = URL(string: urlString) else { return }
        let resource = Resource<MovieReviewResponse>(url: url)

        service.load(resource)
            .sink { _ in } receiveValue: { [weak self] (response) in
                guard let weakSelf = self else { return }
                weakSelf.response.reviews = response.results
                weakSelf.prepareDatasource()
                weakSelf.fetchCast()
            }
            .store(in: &cancellables)
    }
    
    private func fetchCast() {
        
        let urlString = WebServiceConstants.baseURL + "\(movieId)" + WebServiceConstants.movieCastAPI + "api_key=\(apiKey)" + "&language=en-US"
        print(urlString)
//        guard let url = URL(string: urlString) else { return }
//        let resource = Resource<MovieReviewResponse>(url: url)
//
//        service.load(resource)
//            .sink { _ in } receiveValue: { [weak self] (response) in
//                guard let weakSelf = self else { return }
//                print(response)
//                weakSelf.response.reviews = response.results
//                weakSelf.prepareDatasource()
//            }
//            .store(in: &cancellables)
    }
}

//MARK:- Prepare datasource
extension MovieDetailViewModel {
    
    private func prepareDatasource() {
        var preparedDataSource: [MovieDetailCellType] = []
        preparedDataSource.append(cellTypeForSynopsisCell())
        preparedDataSource.append(cellTypeForReviewCell())
        self.dataSource = preparedDataSource
    }
    
    private func cellTypeForSynopsisCell() -> MovieDetailCellType {
        let movieSynopsisVM = MovieSynopsisViewModel(response.synopsis)
        return MovieDetailCellType.synopsisCell(movieSynopsisVM)
    }
    
    private func cellTypeForReviewCell() -> MovieDetailCellType {
        let reviewListVM = MovieReviewListViewModel(self.response.reviews.map { MovieReviewViewModel($0) })
        return MovieDetailCellType.reviewCell(reviewListVM)
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
