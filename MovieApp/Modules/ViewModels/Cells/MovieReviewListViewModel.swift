//
//  MovieReviewListViewModel.swift
//  MovieApp
//
//  Created by Ameya on 27/04/21.
//

import Foundation

//Parent
struct MovieReviewListViewModel {
    
    private(set) var sectionTitle = "Reviews"
    private var viewModels: [MovieReviewViewModel]
}

extension MovieReviewListViewModel {
    
    init(_ viewModels: [MovieReviewViewModel]) {
        self.viewModels = viewModels
    }
}

extension MovieReviewListViewModel {
    
    var numberOfSections: Int {
        1
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        viewModels.count
    }
    
    func vmAtIndex(_ index: Int) -> MovieReviewViewModel {
        viewModels[index]
    }
}

//Child
struct MovieReviewViewModel {
    
    private let review: Review
}

extension MovieReviewViewModel {
    
    init(_ review: Review) {
        self.review = review
    }
}

extension MovieReviewViewModel {
    
    var author: String {
        return self.review.author
    }
    
    var content: String {
        return self.review.content
    }
}
